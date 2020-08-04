//
//  GTMAuthenticationInfo.h
//  SharedSources
//
//  Created by lamnguyen on 7/16/20.
//  Copyright © 2020 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTMAuthenticationInfo : NSObject <GTMFetcherAuthorizationProtocol>

/// @property
///
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *idToken;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, assign) NSTimeInterval expiredTime;
@property (nonatomic, strong) NSDate *expiredDate;
@property (nonatomic, strong) NSString *authorizationCode;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *serviceProvider;

@property (nonatomic, strong) NSString *authorizationQueryParams;

// These fields are only included when the user has granted the "profile" and
// "email" OAuth scopes to the application.
@property (nonatomic, assign) NSInteger isVerified;
@property (nonatomic, strong) NSString *userFamilyName;
@property (nonatomic, strong) NSString *userGivenName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPicture;

/// Initialize
///
- (instancetype)initWithAuthenticationInfo:(NSDictionary *)authenticationInfo;
- (instancetype)initWithTokenInfo:(NSDictionary *)tokenInfo;

/// Methods
///
- (void)updateByObject:(GTMAuthenticationInfo *)authenticationInfo;

@end
