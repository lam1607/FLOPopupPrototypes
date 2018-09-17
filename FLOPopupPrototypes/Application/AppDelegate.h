//
//  AppDelegate.h
//  FLOPopupPrototypes
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;

#pragma mark -
#pragma mark - BundleIdentifier from entitlement apps
#pragma mark -
- (void)addEntitlementBundleId:(NSString *)bundleId;
- (void)removeEntitlementBundleId:(NSString *)bundleId;
- (void)activateEntitlementForBundleId:(NSString *)bundleId;
- (void)inactivateEntitlementForBundleId:(NSString *)bundleId;
- (BOOL)isEntitlementAppForBundleId:(NSString *)bundleId;
- (BOOL)isEntitlementAppFocusedForBundleId:(NSString *)bundleId;
- (BOOL)isEntitlementAppFocused;
- (BOOL)isFinderAppFocused;

@end

