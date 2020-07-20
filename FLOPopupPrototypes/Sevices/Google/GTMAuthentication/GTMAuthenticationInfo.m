//
//  GTMAuthenticationInfo.m
//  SharedSources
//
//  Created by lamnguyen on 7/16/20.
//  Copyright © 2020 Floware. All rights reserved.
//

#import "GTMAuthenticationInfo.h"

#import "GTMAuthenticationConstants.h"

@implementation GTMAuthenticationInfo

@synthesize userEmail = _userEmail;

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
        _isVerified = -1;
    }
    
    return self;
}

- (instancetype)initWithAuthenticationInfo:(NSDictionary *)authenticationInfo
{
    if (self = [self init])
    {
        if ([authenticationInfo isKindOfClass:[NSDictionary class]] && ([authenticationInfo objectForKey:kGTMAuthErrorKey] == nil))
        {
            NSString *accessToken = [authenticationInfo objectForKey:kGTMAuthAccessTokenKey];
            NSString *refreshToken = [authenticationInfo objectForKey:kGTMAuthRefreshTokenKey];
            NSString *idToken = [authenticationInfo objectForKey:kGTMAuthIDTokenKey];
            NSString *scope = [authenticationInfo objectForKey:kGTMAuthScopeKey];
            NSString *expiredTime = [authenticationInfo objectForKey:kGTMAuthExpiresInKey];
            NSString *authorizationCode = [authenticationInfo objectForKey:kGTMAuthCodeKey];
            NSString *userID = [authenticationInfo objectForKey:kGTMAuthUserIDKey];
            NSString *authorizationQueryParams = [authenticationInfo objectForKey:kGTMAuthQueryParamsKey];
            NSString *userEmail = [authenticationInfo objectForKey:kGTMAuthUserEmailKey];
            NSString *isVerified = [authenticationInfo objectForKey:kGTMAuthUserEmailIsVerifiedKey];
            NSString *userFamilyName = [authenticationInfo objectForKey:kGTMAuthUserFamilyNameKey];
            NSString *userGivenName = [authenticationInfo objectForKey:kGTMAuthUserGivenNameKey];
            NSString *userName = [authenticationInfo objectForKey:kGTMAuthUserNameKey];
            NSString *userPicture = [authenticationInfo objectForKey:kGTMAuthUserPictureKey];
            
            [self setInfoAccessToken:accessToken];
            [self setInfoRefreshToken:refreshToken];
            [self setInfoIDToken:idToken];
            [self setInfoScope:scope];
            [self setInfoExpiredTime:[expiredTime doubleValue]];
            [self setInfoAuthorizationCode:authorizationCode];
            [self setInfoUserID:userID];
            [self setInfoAuthorizationQueryParams:authorizationQueryParams];
            [self setInfoUserEmail:userEmail];
            [self setInfoIsVerified:[isVerified integerValue]];
            [self setInfoUserFamilyName:userFamilyName];
            [self setInfoUserGivenName:userGivenName];
            [self setInfoUserName:userName];
            [self setInfoUserPicture:userPicture];
            
            return self;
        }
    }
    
    return nil;
}

- (instancetype)initWithTokenInfo:(NSDictionary *)tokenInfo
{
    if (self = [self init])
    {
        if ([tokenInfo isKindOfClass:[NSDictionary class]] && ([tokenInfo objectForKey:kGTMAuthErrorKey] == nil))
        {
            NSString *expiredTime = [tokenInfo objectForKey:kGTMAuthTokenInfoExpiresInKey];
            NSString *userID = [tokenInfo objectForKey:kGTMAuthTokenInfoUserIDKey];
            NSString *userEmail = [tokenInfo objectForKey:kGTMAuthTokenInfoEmailKey];
            NSString *isVerified = [tokenInfo objectForKey:kGTMAuthTokenInfoEmailVerifiedKey];
            NSString *userFamilyName = [tokenInfo objectForKey:kGTMAuthTokenInfoFamilyNameKey];
            NSString *userGivenName = [tokenInfo objectForKey:kGTMAuthTokenInfoGivenNameKey];
            NSString *userName = [tokenInfo objectForKey:kGTMAuthTokenInfoNameKey];
            NSString *userPicture = [tokenInfo objectForKey:kGTMAuthTokenInfoPictureKey];
            
            [self setInfoExpiredTime:[expiredTime doubleValue]];
            [self setInfoUserID:userID];
            [self setInfoUserEmail:userEmail];
            [self setInfoIsVerified:([isVerified boolValue] ? 1 : 0)];
            [self setInfoUserFamilyName:userFamilyName];
            [self setInfoUserGivenName:userGivenName];
            [self setInfoUserName:userName];
            [self setInfoUserPicture:userPicture];
            
            return self;
        }
    }
    
    return nil;
}

#pragma mark - Override methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\t<%@: %p>,\n\taccessToken: \"%@\",\n\trefreshToken: \"%@\",\n\tidToken: \"%@\",\n\texpiredTime: \"%f\",\n\tuserEmail: \"%@\",\n\tauthorizationQueryParams: \"%@\",\n\tisVerified: \"%ld\",\n\tuserID: \"%@\"\n}", NSStringFromClass([self class]), self, self.accessToken, self.refreshToken, self.idToken, self.expiredTime, self.userEmail, self.authorizationQueryParams, self.isVerified, self.userID];
}

#pragma mark - Local methods

- (void)setInfoAccessToken:(NSString *)accessToken
{
    if (accessToken != nil)
    {
        self.accessToken = accessToken;
    }
}

- (void)setInfoRefreshToken:(NSString *)refreshToken
{
    if (refreshToken != nil)
    {
        self.refreshToken = refreshToken;
    }
}

- (void)setInfoIDToken:(NSString *)idToken
{
    if (idToken != nil)
    {
        self.idToken = idToken;
    }
}

- (void)setInfoScope:(NSString *)scope
{
    if (scope != nil)
    {
        self.scope = scope;
    }
}

- (void)setInfoExpiredTime:(NSTimeInterval)expiredTime
{
    if (expiredTime != 0)
    {
        self.expiredTime = expiredTime;
        self.expiredDate = [NSDate dateWithTimeIntervalSince1970:self.expiredTime];
    }
}

- (void)setInfoAuthorizationCode:(NSString *)authorizationCode
{
    if (authorizationCode != nil)
    {
        self.authorizationCode = authorizationCode;
    }
}

- (void)setInfoUserID:(NSString *)userID
{
    if (userID != nil)
    {
        self.userID = userID;
    }
}

- (void)setInfoAuthorizationQueryParams:(NSString *)authorizationQueryParams
{
    if (authorizationQueryParams != nil)
    {
        self.authorizationQueryParams = authorizationQueryParams;
    }
}

- (void)setInfoUserEmail:(NSString *)userEmail
{
    if (userEmail != nil)
    {
        self.userEmail = userEmail;
    }
}

- (void)setInfoIsVerified:(NSInteger)isVerified
{
    if (isVerified != -1)
    {
        self.isVerified = isVerified;
    }
}

- (void)setInfoUserFamilyName:(NSString *)userFamilyName
{
    if (userFamilyName != nil)
    {
        self.userFamilyName = userFamilyName;
    }
}

- (void)setInfoUserGivenName:(NSString *)userGivenName
{
    if (userGivenName != nil)
    {
        self.userGivenName = userGivenName;
    }
}

- (void)setInfoUserName:(NSString *)userName
{
    if (userName != nil)
    {
        self.userName = userName;
    }
}

- (void)setInfoUserPicture:(NSString *)userPicture
{
    if (userPicture != nil)
    {
        self.userPicture = userPicture;
    }
}

#pragma mark - GTMAuthenticationInfo methods

- (void)updateByObject:(GTMAuthenticationInfo *)authenticationInfo
{
    if ([authenticationInfo isKindOfClass:[GTMAuthenticationInfo class]])
    {
        [self setInfoAccessToken:authenticationInfo.accessToken];
        [self setInfoRefreshToken:authenticationInfo.refreshToken];
        [self setInfoIDToken:authenticationInfo.idToken];
        [self setInfoScope:authenticationInfo.scope];
        [self setInfoExpiredTime:authenticationInfo.expiredTime];
        [self setInfoAuthorizationCode:authenticationInfo.authorizationCode];
        [self setInfoUserID:authenticationInfo.userID];
        [self setInfoAuthorizationQueryParams:authenticationInfo.authorizationQueryParams];
        [self setInfoUserEmail:authenticationInfo.userEmail];
        [self setInfoIsVerified:authenticationInfo.isVerified];
        [self setInfoUserFamilyName:authenticationInfo.userFamilyName];
        [self setInfoUserGivenName:authenticationInfo.userGivenName];
        [self setInfoUserName:authenticationInfo.userName];
        [self setInfoUserPicture:authenticationInfo.userPicture];
    }
}

#pragma mark - GTMFetcherAuthorizationProtocol implementation

#if NS_BLOCKS_AVAILABLE
// Authorizing with a completion block
- (void)authorizeRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(NSError *error))handler
{
    if (request)
    {
        NSString *value = [NSString stringWithFormat:@"%@ %@", kGTMAuthBearer, self.accessToken];
        [request setValue:value forHTTPHeaderField:@"Authorization"];
    }
}
#endif

- (void)authorizeRequest:(GTM_NULLABLE NSMutableURLRequest *)request delegate:(id)delegate didFinishSelector:(SEL)sel
{
    if (request)
    {
        NSString *value = [NSString stringWithFormat:@"%@ %@", kGTMAuthBearer, self.accessToken];
        [request setValue:value forHTTPHeaderField:@"Authorization"];
    }
    
    if (delegate && sel)
    {
        NSMethodSignature *sig = [delegate methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:sel];
        [invocation setTarget:delegate];
        [invocation setArgument:(__bridge void *)(self) atIndex:2];
        [invocation setArgument:&request atIndex:3];
        [invocation invoke];
    }
}

- (void)stopAuthorization
{
}

- (void)stopAuthorizationForRequest:(NSURLRequest *)request
{
}

- (BOOL)isAuthorizingRequest:(NSURLRequest *)request
{
    return YES;
}

- (BOOL)isAuthorizedRequest:(NSURLRequest *)request
{
    NSString *authorizedValue = [request valueForHTTPHeaderField:@"Authorization"];
    
    return ([authorizedValue length] > 0);
}

- (NSString *)userEmail
{
    return _userEmail;
}

- (void)setUserEmail:(NSString *)userEmail
{
    _userEmail = userEmail;
}

@end
