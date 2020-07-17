//
//  GTMAuthenticationConstants.h
//  SharedSources
//
//  Created by lamnguyen on 7/16/20.
//  Copyright © 2020 Floware. All rights reserved.
//

#ifndef GTMAuthenticationConstants_h
#define GTMAuthenticationConstants_h

// https://developers.google.com/identity/protocols/oauth2/native-app
// https://developers.google.com/identity/protocols/oauth2/scopes
// https://tools.ietf.org/html/rfc6749
// https://tools.ietf.org/html/rfc8252
// https://developers.google.com/identity/sign-in/devices
// https://blog.dgunia.de/2016/11/29/googles-new-oauth2-mechanism-for-native-apps/
// https://developers.google.com/identity/sign-in/web/backend-auth

static NSTimeInterval const kGTMAuthTimeoutInterval             = 30;

static NSString *const kGTMAuthIssuer                           = @"https://accounts.google.com";
static NSString *const kGTMAuthClientID                         = @"894903433095-8oags2o4n6haggh1j9ti2ge2oo79qign.apps.googleusercontent.com";
static NSString *const kGTMAuthClientSecret                     = @"CmqCjLhvn6F93hjmnieuwg2l";
static NSString *const kGTMAuthRedirectURI                      = @"com.googleusercontent.apps.894903433095-8oags2o4n6haggh1j9ti2ge2oo79qign:/oauthredirect";

static NSString *const kGTMAuthUserInfoURI                      = @"https://www.googleapis.com/oauth2/v3/userinfo";
static NSString *const kGTMAuthRefreshTokenURI                  = @"https://oauth2.googleapis.com/token";
static NSString *const kGTMAuthTokenInfoURI                     = @"https://oauth2.googleapis.com/tokeninfo";

// scopes
static NSString *const kGTMAuthScopeCalendar                    = @"https://www.googleapis.com/auth/calendar";
static NSString *const kGTMAuthScopeGmail                       = @"https://mail.google.com/";
static NSString *const kGTMAuthScopeEmail                       = @"https://www.googleapis.com/auth/userinfo.email";
static NSString *const kGTMAuthScopeProfile                     = @"https://www.googleapis.com/auth/userinfo.profile";

// standard OAuth keys
static NSString *const kGTMAuthAccessTokenKey                   = @"access_token";
static NSString *const kGTMAuthRefreshTokenKey                  = @"refresh_token";
static NSString *const kGTMAuthIDTokenKey                       = @"id_token";
static NSString *const kGTMAuthScopeKey                         = @"scope";
static NSString *const kGTMAuthErrorKey                         = @"error";
static NSString *const kGTMAuthTokenTypeKey                     = @"token_type";
static NSString *const kGTMAuthExpiresInKey                     = @"expires_in";
static NSString *const kGTMAuthCodeKey                          = @"code";
static NSString *const kGTMAuthAssertionKey                     = @"assertion";
static NSString *const kGTMAuthRefreshScopeKey                  = @"refreshScope";

// additional persistent keys
static NSString *const kGTMAuthServiceProviderKey               = @"serviceProvider";
static NSString *const kGTMAuthUserIDKey                        = @"userID";
static NSString *const kGTMAuthUserEmailKey                     = @"email";
static NSString *const kGTMAuthUserEmailIsVerifiedKey           = @"isVerified";
static NSString *const kGTMAuthUserEmailVerifiedKey             = @"email_verified";
static NSString *const kGTMAuthUserFamilyNameKey                = @"family_name";
static NSString *const kGTMAuthUserGivenNameKey                 = @"given_name";
static NSString *const kGTMAuthUserNameKey                      = @"name";
static NSString *const kGTMAuthUserPictureKey                   = @"picture";

// token keys
static NSString *const kGTMAuthAuthorizationCodeKey             = @"authorization_code";
static NSString *const kGTMAuthRedirectURIKey                   = @"redirect_uri";
static NSString *const kGTMAuthClientIDKey                      = @"client_id";
static NSString *const kGTMAuthClientSecretKey                  = @"client_secret";
static NSString *const kGTMAuthGrantTypeKey                     = @"grant_type";
static NSString *const kGTMAuthQueryParamsKey                   = @"authorization_query_params";

static NSString *const kGTMAuthTokenInfoIssuerKey               = @"iss";
static NSString *const kGTMAuthTokenInfoEmailKey                = @"email";
static NSString *const kGTMAuthTokenInfoEmailVerifiedKey        = @"email_verified";
static NSString *const kGTMAuthTokenInfoExpiresInKey            = @"exp";
static NSString *const kGTMAuthTokenInfoFamilyNameKey           = @"family_name";
static NSString *const kGTMAuthTokenInfoGivenNameKey            = @"given_name";
static NSString *const kGTMAuthTokenInfoNameKey                 = @"name";
static NSString *const kGTMAuthTokenInfoPictureKey              = @"picture";
static NSString *const kGTMAuthTokenInfoUserIDKey               = @"sub";

#endif /* GTMAuthenticationConstants_h */
