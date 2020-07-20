//
//  GTMAuthentication.m
//  SharedSources
//
//  Created by lamnguyen on 7/16/20.
//  Copyright © 2020 Floware. All rights reserved.
//

#import <GTMAppAuth/GTMAppAuth.h>
#import <AppAuth/AppAuthCore.h>
#import <AppAuth/AppAuth.h>
#import <GTMSessionFetcher/GTMSessionFetcher.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>

#import "GTMAuthentication.h"

#import "GTMAuthenticationConstants.h"

#import "GTMAuthenticationInfo.h"

@interface GTMAuthentication ()
{
    id<OIDExternalUserAgentSession> _currentAuthorization;
}

@end

@implementation GTMAuthentication

#pragma mark - Singleton

+ (GTMAuthentication *)sharedInstance
{
    static GTMAuthentication *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GTMAuthentication alloc] init];
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

#pragma mark - Getter/Setter

- (void)setCurrentAuthorization:(id<OIDExternalUserAgentSession>)currentAuthorization
{
    _currentAuthorization = currentAuthorization;
}

#pragma mark - Local methods

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *URLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [_currentAuthorization resumeExternalUserAgentFlowWithURL:URL];
}

#pragma mark - GTMAuthentication local class methods

+ (NSString *)queryStringForParams:(NSDictionary *)params
{
    if (![params isKindOfClass:[NSDictionary class]]) return nil;
    
    NSMutableArray *requestParams = [NSMutableArray new];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *paramList = (NSArray *)obj;
            
            for (NSObject *param in paramList)
            {
                NSString *paramString = [NSString stringWithFormat:@"%@[]=%@", key, param];
                [requestParams addObject:paramString];
            }
        }
        else
        {
            NSString *paramString = [NSString stringWithFormat:@"%@=%@", key, obj];
            [requestParams addObject:paramString];
        }
    }];
    
    NSString *queryString = [requestParams componentsJoinedByString:@"&"];
    
    return queryString;
}

+ (NSMutableDictionary *)persistenceResponseString:(GTMAppAuthFetcherAuthorization *)authorization
{
    NSMutableDictionary *authorizationInfo = [[NSMutableDictionary alloc] init];
    
    NSString *refreshToken = authorization.authState.refreshToken;
    NSString *accessToken = authorization.authState.lastTokenResponse.accessToken;
    NSString *tokenType = authorization.authState.lastTokenResponse.tokenType;
    NSString *idToken = authorization.authState.lastTokenResponse.idToken;
    NSString *tokenExpiredTime = [NSString stringWithFormat:@"%f", [authorization.authState.lastTokenResponse.accessTokenExpirationDate timeIntervalSince1970]];
    NSString *authorizationCode = authorization.authState.lastAuthorizationResponse.authorizationCode;
    
    // Any nil values will not set a dictionary entry
    [authorizationInfo setValue:refreshToken forKey:kGTMAuthRefreshTokenKey];
    [authorizationInfo setValue:idToken forKey:kGTMAuthIDTokenKey];
    [authorizationInfo setValue:tokenExpiredTime forKey:kGTMAuthExpiresInKey];
    [authorizationInfo setValue:authorizationCode forKey:kGTMAuthCodeKey];
    [authorizationInfo setValue:tokenType forKey:kGTMAuthTokenTypeKey];
    [authorizationInfo setValue:authorization.serviceProvider forKey:kGTMAuthServiceProviderKey];
    [authorizationInfo setValue:authorization.userID forKey:kGTMAuthUserIDKey];
    [authorizationInfo setValue:authorization.userEmail forKey:kGTMAuthUserEmailKey];
    [authorizationInfo setValue:authorization.userEmailIsVerified forKey:kGTMAuthUserEmailIsVerifiedKey];
    [authorizationInfo setValue:authorization.authState.scope forKey:kGTMAuthScopeKey];
    
    NSString *authorizationQueryParams = [[self class] encodedQueryParametersForDictionary:authorizationInfo];
    
    [authorizationInfo setValue:accessToken forKey:kGTMAuthAccessTokenKey];
    [authorizationInfo setValue:authorizationQueryParams forKey:kGTMAuthQueryParamsKey];
    
    return authorizationInfo;
}

+ (NSURL *)requestIssuer
{
    return [NSURL URLWithString:kGTMAuthIssuer];
}

+ (NSURL *)requestRedirectURL
{
    return [NSURL URLWithString:kGTMAuthRedirectURI];
}

+ (NSArray *)requestScopes
{
    return @[OIDScopeOpenID, kGTMAuthScopeEmail, kGTMAuthScopeProfile, kGTMAuthScopeCalendar, kGTMAuthScopeGmail];
}

+ (void)fetchUserInfo:(GTMAppAuthFetcherAuthorization *)authorization completion:(void(^)(NSDictionary *userInfo, NSError *error))complete
{
    // Creates a GTMSessionFetcherService with the authorization.
    // Normally you would save this service object and re-use it for all REST API calls.
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = authorization;
    
    // Creates a fetcher for the API call.
    NSURL *endpoint = [NSURL URLWithString:kGTMAuthUserInfoURI];
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithURL:endpoint];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (complete != nil)
        {
            if (data != nil)
            {
                // Parses the JSON response.
                NSError *error = nil;
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                NSLog(@"%s-%d userInfo JSON decoding error:%@", __PRETTY_FUNCTION__, __LINE__, error);
                
                complete(userInfo, error);
            }
            else
            {
                complete(nil, error);
            }
        }
    }];
}

#pragma mark - GTMAuthentication methods

#pragma mark - GTMAuthentication class methods

+ (NSString *)encodedOAuthValueForString:(NSString *)originalString
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

+ (NSString *)encodedQueryParametersForDictionary:(NSDictionary *)dict
{
    // Make a string like "cat=fluffy&dog=spot"
    NSMutableString *result = [NSMutableString string];
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *joiner = @"";
    
    for (NSString *key in sortedKeys)
    {
        NSString *value = [dict objectForKey:key];
        NSString *encodedValue = [[self class] encodedOAuthValueForString:value];
        NSString *encodedKey = [[self class] encodedOAuthValueForString:key];
        [result appendFormat:@"%@%@=%@", joiner, encodedKey, encodedValue];
        joiner = @"&";
    }
    
    return result;
}

+ (NSString *)unencodedOAuthParameterForString:(NSString *)str
{
#if (!TARGET_OS_IPHONE && defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9) \
|| (TARGET_OS_IPHONE && defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    // On iOS 7, -stringByRemovingPercentEncoding incorrectly returns nil for an empty string.
    if (str != nil && [str length] == 0) return @"";
    
    NSString *plainStr = [str stringByRemovingPercentEncoding];
    return plainStr;
#else
    NSString *plainStr = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return plainStr;
#endif
}

+ (NSDictionary *)dictionaryWithResponseString:(NSString *)responseStr
{
    // Build a dictionary from a response string of the form
    // "cat=fluffy&dog=spot".  Missing or empty values are considered
    // empty strings; keys and values are percent-decoded.
    if (responseStr == nil) return nil;
    
    NSArray *items = [responseStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionaryWithCapacity:[items count]];
    
    for (NSString *item in items)
    {
        NSString *key = nil;
        NSString *value = @"";
        
        NSRange equalsRange = [item rangeOfString:@"="];
        
        if (equalsRange.location != NSNotFound)
        {
            // The parameter has at least one '='
            key = [item substringToIndex:equalsRange.location];
            
            // There are characters after the '='
            value = [item substringFromIndex:(equalsRange.location + 1)];
        }
        else
        {
            // The parameter has no '='
            key = item;
        }
        
        NSString *plainKey = [[self class] unencodedOAuthParameterForString:key];
        NSString *plainValue = [[self class] unencodedOAuthParameterForString:value];
        
        [responseDict setObject:plainValue forKey:plainKey];
    }
    
    return responseDict;
}

+ (GTMAuthenticationInfo * _Nullable)authenticationInfoWithResponseString:(NSString * _Nonnull)responseStr
{
    NSDictionary *responseDict = [[self class] dictionaryWithResponseString:responseStr];
    GTMAuthenticationInfo *authenticationInfo = [[GTMAuthenticationInfo alloc] initWithAuthenticationInfo:responseDict];
    
    return authenticationInfo;
}

#pragma mark -

+ (void)authorizeWithClientId:(NSString * _Nonnull)clientId clientSecret:(NSString * _Nonnull)clientSecret completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete
{
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:[[self class] requestIssuer] completion:^(OIDServiceConfiguration *configuration, NSError *error) {
        if (configuration != nil)
        {
            OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration clientId:clientId clientSecret:clientSecret scopes:[[self class] requestScopes] redirectURL:[[self class] requestRedirectURL] responseType:OIDResponseTypeCode additionalParameters:nil];
            
            // performs authentication request
            id<OIDExternalUserAgentSession> currentAuthorization = [OIDAuthState authStateByPresentingAuthorizationRequest:request callback:^(OIDAuthState *authState, NSError *error) {
                if (authState)
                {
                    // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
                    GTMAppAuthFetcherAuthorization *authorization = [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
                    NSMutableDictionary *authorizationInfo = [[self class] persistenceResponseString:authorization];
                    
                    [[self class] fetchUserInfo:authorization completion:^(NSDictionary *userInfo, NSError *error) {
                        if (userInfo != nil)
                        {
                            for (id infoKey in userInfo)
                            {
                                [authorizationInfo setValue:[userInfo valueForKey:infoKey] forKey:infoKey];
                            }
                            
                            GTMAuthenticationInfo *authenticationInfo = [[GTMAuthenticationInfo alloc] initWithAuthenticationInfo:authorizationInfo];
                            
                            if (complete != nil)
                            {
                                complete(authenticationInfo, nil);
                            }
                        }
                        else
                        {
                            // Checks for an error.
                            // OIDOAuthTokenErrorDomain indicates an issue with the authorization.
                            if ([error.domain isEqual:OIDOAuthTokenErrorDomain])
                            {
                                // Other errors are assumed transient.
                                NSLog(@"%s-%d Authorization error during token refresh, clearing state:%@", __PRETTY_FUNCTION__, __LINE__, error);
                            }
                            else
                            {
                                NSLog(@"%s-%d Transient error during token refresh:%@", __PRETTY_FUNCTION__, __LINE__, error);
                            }
                            
                            if (complete != nil)
                            {
                                complete(nil, error);
                            }
                        }
                    }];
                }
                else
                {
                    NSLog(@"%s-%d Request authorization error:%@", __PRETTY_FUNCTION__, __LINE__, error);
                    
                    if (complete != nil)
                    {
                        complete(nil, error);
                    }
                }
            }];
            
            [[GTMAuthentication sharedInstance] setCurrentAuthorization:currentAuthorization];
        }
        else
        {
            NSLog(@"%s-%d Authorization error:%@", __PRETTY_FUNCTION__, __LINE__, error);
            
            if (complete != nil)
            {
                complete(nil, error);
            }
        }
    }];
}

+ (void)getTokenInfoWithID:(NSString * _Nonnull)idToken completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete
{
    if ([idToken isKindOfClass:[NSString class]])
    {
        NSDictionary *urlParams = @{kGTMAuthIDTokenKey: idToken};
        
        NSString *endpoint = [NSString stringWithFormat:@"%@?%@", kGTMAuthTokenInfoURI, [[self class] queryStringForParams:urlParams]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:endpoint]];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:kGTMAuthTimeoutInterval];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            GTMAuthenticationInfo *authenticationInfo = nil;
            
            if (data != nil)
            {
                NSDictionary *tokenInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                if (tokenInfo != nil)
                {
                    authenticationInfo = [[GTMAuthenticationInfo alloc] initWithTokenInfo:tokenInfo];
                    
                    if ((authenticationInfo == nil) && ([tokenInfo objectForKey:kGTMAuthErrorKey] != nil))
                    {
                        error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{kGTMAuthInvalidTokenKey: [tokenInfo objectForKey:kGTMAuthErrorDescriptionKey]}];
                    }
                }
            }
            
            if ((error == nil) && (authenticationInfo == nil))
            {
                error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Get token info failed with nil data"}];
            }
            
            if (complete != nil)
            {
                complete(authenticationInfo, error);
            }
        }] resume];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Token id cannot be nil"}];
        
        if (complete != nil)
        {
            complete(nil, error);
        }
    }
}

+ (void)refreshAccessTokenWithClientId:(NSString * _Nonnull)clientId clientSecret:(NSString * _Nonnull)clientSecret refreshToken:(NSString * _Nonnull)refreshToken completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete
{
    if ([refreshToken isKindOfClass:[NSString class]])
    {
        [OIDAuthorizationService discoverServiceConfigurationForIssuer:[NSURL URLWithString:kGTMAuthIssuer] completion:^(OIDServiceConfiguration *configuration, NSError *error) {
            if (configuration != nil)
            {
                OIDTokenRequest *tokenRequest = [[OIDTokenRequest alloc] initWithConfiguration:configuration grantType:OIDGrantTypeRefreshToken authorizationCode:nil redirectURL:[[self class] requestRedirectURL] clientID:clientId clientSecret:clientSecret scopes:[[self class] requestScopes] refreshToken:refreshToken codeVerifier:nil additionalParameters:nil];
                
                [OIDAuthorizationService performTokenRequest:tokenRequest callback:^(OIDTokenResponse * _Nullable tokenResponse, NSError * _Nullable error) {
                    GTMAuthenticationInfo *authenticationInfo = nil;
                    
                    if (tokenResponse != nil)
                    {
                        OIDAuthState *authState = [[OIDAuthState alloc] initWithAuthorizationResponse:nil tokenResponse:tokenResponse registrationResponse:nil];
                        
                        // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
                        GTMAppAuthFetcherAuthorization *authorization = [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
                        NSMutableDictionary *authorizationInfo = [[self class] persistenceResponseString:authorization];
                        
                        if (authorizationInfo.count > 0)
                        {
                            authenticationInfo = [[GTMAuthenticationInfo alloc] initWithAuthenticationInfo:authorizationInfo];
                        }
                    }
                    
                    if ((error == nil) && (authenticationInfo == nil))
                    {
                        error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Refresh token failed with nil data"}];
                    }
                    
                    if (complete != nil)
                    {
                        complete(authenticationInfo, error);
                    }
                }];
            }
            else
            {
                NSLog(@"%s-%d Request refresh access token error:%@", __PRETTY_FUNCTION__, __LINE__, error);
                
                if (complete != nil)
                {
                    complete(nil, error);
                }
            }
        }];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Refresh token cannot be nil"}];
        
        if (complete != nil)
        {
            complete(nil, error);
        }
    }
}

@end
