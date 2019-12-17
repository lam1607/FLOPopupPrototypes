//
//  GTMAppAuthManager.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 12/17/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "GTMAppAuthManager.h"

@interface GTMAppAuthManager ()
{
    id<OIDExternalUserAgentSession> _currentAuthorizationFlow;
    GTMAppAuthFetcherAuthorization *_authorization;
}

@end

@implementation GTMAppAuthManager

#pragma mark - Singleton

+ (GTMAppAuthManager *)sharedInstance
{
    static GTMAppAuthManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GTMAppAuthManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                           andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                                                         forEventClass:kInternetEventClass
                                                            andEventID:kAEGetURL];
    }
    
    return self;
}

#pragma mark - Local methods

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *URLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [_currentAuthorizationFlow resumeExternalUserAgentFlowWithURL:URL];
}

- (NSString *)encodedOAuthValueForString:(NSString *)originalString
{
    // For parameters, we'll explicitly leave spaces unescaped now, and replace
    // them with +'s
    NSString *const kForceEscape = @"!*'();:@&=+$,/?%#[]";
    
#if (!TARGET_OS_IPHONE && defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9) \
|| (TARGET_OS_IPHONE && defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    // Builds targeting iOS 7/OS X 10.9 and higher only.
    NSMutableCharacterSet *cs = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [cs removeCharactersInString:kForceEscape];
    
    NSString *escapedStr = [originalString stringByAddingPercentEncodingWithAllowedCharacters:cs];
#else
    // Builds targeting iOS 6/OS X 10.8.
    CFStringRef leaveUnescaped = NULL;
    
    CFStringRef escapedStr = NULL;
    if (originalString)
    {
        escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             (CFStringRef)originalString,
                                                             leaveUnescaped,
                                                             (CFStringRef)kForceEscape,
                                                             kCFStringEncodingUTF8);
        [(NSString *)escapedStr autorelease];
    }
#endif
    
    return (NSString *)escapedStr;
}

- (NSString *)encodedQueryParametersForDictionary:(NSDictionary *)dict
{
    // Make a string like "cat=fluffy&dog=spot"
    NSMutableString *result = [NSMutableString string];
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *joiner = @"";
    
    for (NSString *key in sortedKeys)
    {
        NSString *value = [dict objectForKey:key];
        NSString *encodedValue = [self encodedOAuthValueForString:value];
        NSString *encodedKey = [self encodedOAuthValueForString:key];
        [result appendFormat:@"%@%@=%@", joiner, encodedKey, encodedValue];
        joiner = @"&";
    }
    
    return result;
}

- (NSMutableDictionary *)persistenceResponseString:(GTMAppAuthFetcherAuthorization *)authorization
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *refreshToken = authorization.authState.refreshToken;
    NSString *accessToken = authorization.authState.lastTokenResponse.accessToken;
    
    // Any nil values will not set a dictionary entry
    [dict setValue:refreshToken forKey:kOAuth2RefreshTokenKey];
    [dict setValue:accessToken forKey:kOAuth2AccessTokenKey];
    [dict setValue:authorization.serviceProvider forKey:kServiceProviderKey];
    [dict setValue:authorization.userID forKey:kUserIDKey];
    [dict setValue:authorization.userEmail forKey:kUserEmailKey];
    [dict setValue:authorization.userEmailIsVerified forKey:kUserEmailIsVerifiedKey];
    [dict setValue:authorization.authState.scope forKey:kOAuth2ScopeKey];
    
    NSString *result = [self encodedQueryParametersForDictionary:dict];
    
    [dict setValue:result forKey:@"refreshToken"];
    
    return dict;
}

- (void)setAuthorization:(GTMAppAuthFetcherAuthorization *)authorization
{
    _authorization = authorization;
}

#pragma mark - GTMAppAuthManager methods

- (void)authorizeWithCompletion:(void(^)(GTMAppAuthFetcherAuthorization *authorization, NSDictionary *authorizationInfo, NSError *error))complete
{
    __weak typeof(self) wself = self;
    
    __block NSURL *issuer = [NSURL URLWithString:kIssuer];
    __block NSURL *redirectURI = [NSURL URLWithString:kRedirectURI];
    
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer completion:^(OIDServiceConfiguration *configuration, NSError *error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        if (configuration == nil) return;
        
        OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration clientId:kClientID clientSecret:kClientSecret scopes:@[OIDScopeOpenID, kOAuthScopeEmail, kOAuthScopeProfile, kOAuthScopeCalendar, kOAuthScopeGmail] redirectURL:redirectURI responseType:OIDResponseTypeCode additionalParameters:nil];
        
        // performs authentication request
        this->_currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request callback:^(OIDAuthState *authState, NSError *error) {
            if (authState)
            {
                // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
                GTMAppAuthFetcherAuthorization *authorization = [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
                NSMutableDictionary *authorizationInfo = [self persistenceResponseString:authorization];
                
                [this setAuthorization:authorization];
                
                // Creates a GTMSessionFetcherService with the authorization.
                // Normally you would save this service object and re-use it for all REST API calls.
                GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
                fetcherService.authorizer = authorization;
                
                // Creates a fetcher for the API call.
                NSURL *userinfoEndpoint = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v3/userinfo"];
                GTMSessionFetcher *fetcher = [fetcherService fetcherWithURL:userinfoEndpoint];
                
                [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
                    if (error != nil)
                    {
                        // Checks for an error.
                        // OIDOAuthTokenErrorDomain indicates an issue with the authorization.
                        if ([error.domain isEqual:OIDOAuthTokenErrorDomain])
                        {
                            [this setAuthorization:nil];
                            // Other errors are assumed transient.
                            NSLog(@"Authorization error during token refresh, clearing state. %@", error);
                        }
                        else
                        {
                            NSLog(@"Transient error during token refresh. %@", error);
                        }
                        
                        if (complete != nil)
                        {
                            complete(nil, nil, error);
                        }
                    }
                    else
                    {
                        // Parses the JSON response.
                        NSError *jsonError = nil;
                        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        
                        if (jsonError)
                        {
                            NSLog(@"JSON decoding error %@", jsonError);
                        }
                        else
                        {
                            for (id infoKey in userInfo)
                            {
                                [authorizationInfo setValue:[userInfo valueForKey:infoKey] forKey:infoKey];
                            }
                            
                            if (complete != nil)
                            {
                                complete(authorization, authorizationInfo, nil);
                            }
                        }
                    }
                }];
            }
            else
            {
                NSLog(@"Authorization error: %@", [error localizedDescription]);
                
                [this setAuthorization:nil];
                
                if (complete != nil)
                {
                    complete(nil, nil, error);
                }
            }
        }];
    }];
}

@end
