//
//  AppDelegate.m
//  FLOPopupPrototypes
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "AppDelegate.h"

#import "FLOPopoverWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableDictionary *_entitlementAppBundleIdentifiers;
@property (nonatomic, strong) NSString *_lastBundleIdentifier;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self._entitlementAppBundleIdentifiers = [[NSMutableDictionary alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)applicationDidResignActive:(NSNotification *)notification {
    DLog(@"applicationDidResignActive");
    
    if ([[FLOPopoverWindowController sharedInstance] windowInDesktopMode]) {
        [[FLOPopoverWindowController sharedInstance] hideChildenWindowsOnDeactivate];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    DLog(@"applicationDidBecomeActive");
    
    if ([[FLOPopoverWindowController sharedInstance] windowInDesktopMode]) {
        [[FLOPopoverWindowController sharedInstance] showChildenWindowsOnActivate];
    }
    
//    [[FlowWindowController getInstance] activate];
//
//    if ([[LCLFloViewController getInstance] checkPresentationMode] && [FlowSettings getInstance].backgroundVisible) {
//        if (![self isEntitlementAppFocused]) {
//            [[LCLFloViewController getInstance] hideAllAppsExceptThoseInWorkspace];
//        }
//    }
}

#pragma mark -
#pragma mark - BundleIdentifier from entitlement apps
#pragma mark -
- (void)addEntitlementBundleId:(NSString *)bundleId {
    if (!bundleId.length) return;
    // Yes: entitlement app has been activated
    // NO: entitlemnt app has been inactivated
    [self._entitlementAppBundleIdentifiers setObject:[NSNumber numberWithBool:NO] forKey:bundleId];
}

- (void)removeEntitlementBundleId:(NSString *)bundleId {
    if (!bundleId.length) return;
    
    [self._entitlementAppBundleIdentifiers removeObjectForKey:bundleId];
}

- (void)activateEntitlementForBundleId:(NSString *)bundleId {
    if (!bundleId.length) return;
    
    NSNumber *obj = [self._entitlementAppBundleIdentifiers objectForKey:bundleId];
    
    if (obj != nil) {
        BOOL status = [obj boolValue];
        
        if (status == NO) {
            [self._entitlementAppBundleIdentifiers setObject:[NSNumber numberWithBool:YES] forKey:bundleId];
        }
    }
}

- (void)inactivateEntitlementForBundleId:(NSString *)bundleId {
    if (!bundleId.length) return;
    
    NSNumber *obj = [self._entitlementAppBundleIdentifiers objectForKey:bundleId];
    
    if (obj != nil) {
        BOOL status = [obj boolValue];
        
        if (status == YES) {
            [self._entitlementAppBundleIdentifiers setObject:[NSNumber numberWithBool:NO] forKey:bundleId];
        }
    }
}

- (BOOL)isEntitlementAppForBundleId:(NSString *)bundleId {
    if (!bundleId.length) return NO;
    
    return ([self._entitlementAppBundleIdentifiers objectForKey:bundleId] != nil) ? YES : NO;
}

- (BOOL)isEntitlementAppFocusedForBundleId:(NSString *)bundleId {
    BOOL result = [self isEntitlementAppForBundleId:bundleId];
    
    if (!result) return NO;
    
    NSNumber *obj = [self._entitlementAppBundleIdentifiers objectForKey:bundleId];
    
    if (obj != nil) {
        result = [obj boolValue];
    }
    return result;
}

- (BOOL)isEntitlementAppFocused {
    return [self isEntitlementAppFocusedForBundleId:self._lastBundleIdentifier];
}

- (BOOL)isFinderAppFocused {
    return [self._lastBundleIdentifier isEqualToString:FLO_ENTITLEMENT_APP_IDENTIFIER_FINDER];
}

@end
