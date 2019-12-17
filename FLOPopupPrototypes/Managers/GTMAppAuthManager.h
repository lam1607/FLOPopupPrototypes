//
//  GTMAppAuthManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 12/17/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kIssuer                          = @"https://accounts.google.com";
static NSString *const kClientID                        = @"894903433095-8oags2o4n6haggh1j9ti2ge2oo79qign.apps.googleusercontent.com";
static NSString *const kClientSecret                    = @"CmqCjLhvn6F93hjmnieuwg2l";
static NSString *const kRedirectURI                     = @"com.googleusercontent.apps.894903433095-8oags2o4n6haggh1j9ti2ge2oo79qign:/oauthredirect";

static NSString *const kOAuthScopeCalendar              = @"https://www.googleapis.com/auth/calendar";
static NSString *const kOAuthScopeGmail                 = @"https://mail.google.com/";
static NSString *const kOAuthScopeEmail                 = @"https://www.googleapis.com/auth/userinfo.email";
static NSString *const kOAuthScopeProfile               = @"https://www.googleapis.com/auth/userinfo.profile";

// standard OAuth keys
static NSString *const kOAuth2AccessTokenKey            = @"access_token";
static NSString *const kOAuth2RefreshTokenKey           = @"refresh_token";
static NSString *const kOAuth2ScopeKey                  = @"scope";
static NSString *const kOAuth2ErrorKey                  = @"error";
static NSString *const kOAuth2TokenTypeKey              = @"token_type";
static NSString *const kOAuth2ExpiresInKey              = @"expires_in";
static NSString *const kOAuth2CodeKey                   = @"code";
static NSString *const kOAuth2AssertionKey              = @"assertion";
static NSString *const kOAuth2RefreshScopeKey           = @"refreshScope";

// additional persistent keys
static NSString *const kServiceProviderKey              = @"serviceProvider";
static NSString *const kUserIDKey                       = @"userID";
static NSString *const kUserEmailKey                    = @"email";
static NSString *const kUserEmailIsVerifiedKey          = @"isVerified";

@interface GTMAppAuthManager : NSObject

#pragma mark - Singleton

+ (GTMAppAuthManager *)sharedInstance;

#pragma mark - GTMAppAuthManager methods

- (void)authorizeWithCompletion:(void(^)(GTMAppAuthFetcherAuthorization *authorization, NSDictionary *authorizationInfo, NSError *error))complete;

@end
