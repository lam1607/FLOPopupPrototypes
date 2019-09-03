//
//  EntitlementsManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntitlementsManager : NSObject

@property (nonatomic, strong, readonly) NSArray *entitlementAppBundles;

#pragma mark - Singleton

+ (EntitlementsManager *)sharedInstance;

#pragma mark - Methods

- (void)observeActivationForEntitlementApps;

- (NSString *)getAppPathWithIdentifier:(NSString *)bundleIdentifier;
- (NSString *)getAppNameWithIdentifier:(NSString *)bundleIdentifier;

- (void)addWithBundleIdentifier:(NSString *)bundleIdentifier;
- (void)removeWithBundleIdentifier:(NSString *)bundleIdentifier;
- (void)activateWithBundleIdentifier:(NSString *)bundleIdentifier;
- (void)inactivateWithBundleIdentifier:(NSString *)bundleIdentifier;
- (BOOL)isEntitlementAppForBundleIdentifier:(NSString *)bundleIdentifier;
- (BOOL)isEntitlementAppFocusedForBundleIdentifier:(NSString *)bundleIdentifier;
- (BOOL)isEntitlementAppFocused;
- (BOOL)isFinderAppFocused;

@end
