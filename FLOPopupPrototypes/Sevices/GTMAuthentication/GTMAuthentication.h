//
//  GTMAuthentication.h
//  SharedSources
//
//  Created by lamnguyen on 7/16/20.
//  Copyright © 2020 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMAuthenticationInfo;

@interface GTMAuthentication : NSObject

#pragma mark - GTMAuthentication methods

#pragma mark - GTMAuthentication class methods

/// Utilities
///
+ (NSString * _Nonnull)encodedOAuthValueForString:(NSString * _Nonnull)originalString;
+ (NSString * _Nonnull)encodedQueryParametersForDictionary:(NSDictionary * _Nonnull)dict;
+ (NSString * _Nonnull)unencodedOAuthParameterForString:(NSString * _Nonnull)str;
+ (NSDictionary * _Nullable)dictionaryWithResponseString:(NSString * _Nonnull)responseStr;

+ (GTMAuthenticationInfo * _Nullable)authenticationInfoWithResponseString:(NSString * _Nonnull)responseStr;

/// Authentication
///
+ (void)authorizeWithClientId:(NSString * _Nonnull)clientId clientSecret:(NSString * _Nonnull)clientSecret completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete;
+ (void)getTokenInfoWithID:(NSString * _Nonnull)idToken completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete;
+ (void)refreshAccessTokenWithClientId:(NSString * _Nonnull)clientId clientSecret:(NSString * _Nonnull)clientSecret refreshToken:(NSString * _Nonnull)refreshToken completion:(void(^ _Nullable)(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error))complete;

@end
