//
//  EntitlementsManager.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "EntitlementsManager.h"

#import "AbstractWindowController.h"

@interface EntitlementsManager ()
{
    NSArray<NSString *> *_entitlementAppBundles;
    
    NSMutableDictionary *_entitlementAppStates;
    NSMutableArray<NSString *> *_openedBundleIdentifiers;
    NSString *_lastBundleIdentifier;
}

@end

@implementation EntitlementsManager

#pragma mark - Singleton

+ (EntitlementsManager *)sharedInstance
{
    static EntitlementsManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EntitlementsManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    
    return self;
}

#pragma mark - Getter/Setter

- (NSArray *)entitlementAppBundles
{
    if (_entitlementAppBundles == nil)
    {
        _entitlementAppBundles = [[NSArray alloc] initWithObjects:kFlowarePopover_BundleIdentifier_Finder, kFlowarePopover_BundleIdentifier_Safari, nil];
    }
    
    return _entitlementAppBundles;
}

#pragma mark - Local methods

- (void)initialize
{
    _entitlementAppBundles = [[NSArray alloc] initWithObjects:kFlowarePopover_BundleIdentifier_Finder, kFlowarePopover_BundleIdentifier_Safari, nil];
    
    if (_entitlementAppStates == nil)
    {
        _entitlementAppStates = [[NSMutableDictionary alloc] init];
    }
    
    _openedBundleIdentifiers = [[NSMutableArray alloc] init];
    [_openedBundleIdentifiers addObject:[[NSBundle mainBundle] bundleIdentifier]];
    
    [self setupEntitlementAppBundles];
}

- (void)setupEntitlementAppBundles
{
    for (NSString *bundleIdentifier in _entitlementAppBundles)
    {
        [self addWithBundleIdentifier:bundleIdentifier];
    }
}

#pragma mark - EntitlementsManager methods

- (void)observeActivationForEntitlementApps
{
    __weak typeof(self) wself = self;
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceDidActivateApplicationNotification object:nil queue:nil usingBlock:^(NSNotification *notif) {
        if (wself == nil) return;
        
        typeof(self) this = wself;
        
        NSRunningApplication *app = [notif.userInfo objectForKey:NSWorkspaceApplicationKey];
        
        if (![app.bundleIdentifier isEqualToString:[[NSBundle mainBundle] bundleIdentifier]])
        {
            if (![this isEntitlementAppForBundleIdentifier:app.bundleIdentifier])
            {
                [this->_openedBundleIdentifiers removeAllObjects];
            }
            
            this->_lastBundleIdentifier = app.bundleIdentifier;
            
            [this validateChildWindowsFloating];
            
            [[AbstractWindowController sharedInstance] performSelectorOnMainThread:@selector(hideChildWindowsOnDeactivate) withObject:nil waitUntilDone:YES];
        }
        else
        {
            if (![this->_openedBundleIdentifiers containsObject:app.bundleIdentifier])
            {
                [this->_openedBundleIdentifiers addObject:app.bundleIdentifier];
            }
        }
    }];
}

- (NSString *)getAppPathWithIdentifier:(NSString *)bundleIdentifier
{
    NSString *path = nil;
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSLocalDomainMask];
    NSArray *properties = [NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    NSError *error = nil;
    
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[urls firstObject]
                                                   includingPropertiesForKeys:properties
                                                                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                                                                        error:&error];
    
    for (NSURL *appUrl in array)
    {
        NSString *appPath = [appUrl path];
        NSBundle *appBundle = [NSBundle bundleWithPath:appPath];
        
        if ([bundleIdentifier isEqualToString:[appBundle bundleIdentifier]])
        {
            path = appPath;
            break;
        }
    }
    
    if (path == nil)
    {
        path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleIdentifier];
    }
    
    return path;
}

- (NSString *)getAppNameWithIdentifier:(NSString *)bundleIdentifier
{
    if ([bundleIdentifier isKindOfClass:[NSString class]])
    {
        NSString *path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleIdentifier];
        path = [self getAppPathWithIdentifier:bundleIdentifier];
        
        return [[NSFileManager defaultManager] displayNameAtPath:path];
    }
    
    return nil;
}

- (void)addWithBundleIdentifier:(NSString *)bundleIdentifier
{
    if (bundleIdentifier.length == 0) return;
    
    // Yes: entitlement app has been activated
    // NO: entitlement app has been inactivated
    if (_entitlementAppStates == nil)
    {
        _entitlementAppStates = [[NSMutableDictionary alloc] init];
    }
    
    [_entitlementAppStates setObject:[NSNumber numberWithBool:NO] forKey:bundleIdentifier];
}

- (void)removeWithBundleIdentifier:(NSString *)bundleIdentifier
{
    if (bundleIdentifier.length == 0) return;
    
    [_entitlementAppStates removeObjectForKey:bundleIdentifier];
}

- (void)activateWithBundleIdentifier:(NSString *)bundleIdentifier
{
    if (bundleIdentifier.length == 0) return;
    
    NSNumber *state = [_entitlementAppStates objectForKey:bundleIdentifier];
    
    if (state != nil)
    {
        BOOL active = [state boolValue];
        
        if (!active)
        {
            [_entitlementAppStates setObject:[NSNumber numberWithBool:YES] forKey:bundleIdentifier];
        }
    }
}

- (void)inactivateWithBundleIdentifier:(NSString *)bundleIdentifier
{
    if (bundleIdentifier.length == 0) return;
    
    NSNumber *state = [_entitlementAppStates objectForKey:bundleIdentifier];
    
    if (state != nil)
    {
        BOOL active = [state boolValue];
        
        if (active)
        {
            [_entitlementAppStates setObject:[NSNumber numberWithBool:NO] forKey:bundleIdentifier];
        }
    }
}

- (BOOL)isEntitlementAppForBundleIdentifier:(NSString *)bundleIdentifier
{
    if (bundleIdentifier.length == 0) return NO;
    
    return ([_entitlementAppStates objectForKey:bundleIdentifier] != nil) ? YES : NO;
}

- (BOOL)isEntitlementAppFocusedForBundleIdentifier:(NSString *)bundleIdentifier
{
    BOOL isEntitlementAppFocused = [self isEntitlementAppForBundleIdentifier:bundleIdentifier];
    
    if (!isEntitlementAppFocused) return NO;
    
    NSNumber *state = [_entitlementAppStates objectForKey:bundleIdentifier];
    
    if (state != nil)
    {
        isEntitlementAppFocused = [state boolValue];
    }
    
    return isEntitlementAppFocused;
}

- (BOOL)isEntitlementAppFocused
{
    return [self isEntitlementAppFocusedForBundleIdentifier:_lastBundleIdentifier];
}

- (BOOL)isFinderAppFocused
{
    return [_lastBundleIdentifier isEqualToString:kFlowarePopover_BundleIdentifier_Finder];
}

- (void)validateChildWindowsFloating
{
    BOOL shouldChildWindowsFloat = ((_openedBundleIdentifiers.count > 0) && [self isEntitlementAppFocused] && [[_openedBundleIdentifiers firstObject] isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]);
    
    [[WindowManager sharedInstance] setShouldChildWindowsFloat:shouldChildWindowsFloat];
}

@end
