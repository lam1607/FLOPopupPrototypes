//
//  AppDelegate.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 9/20/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "AbstractWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenuItem *checkUpdateItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[EntitlementsManager sharedInstance] observeActivationForEntitlementApps];
    
    [self.checkUpdateItem setTarget:[UpdateManager sharedInstance]];
    [self.checkUpdateItem setAction:@selector(checkForUpdates:)];
    
    [[WebSocketManager sharedInstance] connect];
    
    [[UpdateManager sharedInstance] setAutomaticallyChecksForUpdates:YES];
    [[UpdateManager sharedInstance] setUpdateCheckInterval:3600];
    
#ifdef kFlowarePopover_UpdateRelease
    [[UpdateManager sharedInstance] runningReleaseScript];
#endif
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if ([[SettingsManager sharedInstance] isDesktopMode] && ![[EntitlementsManager sharedInstance] isEntitlementAppFocused])
    {
        [[EntitlementsManager sharedInstance] hideOtherAppsExceptThoseInside];
    }
    
    [[AbstractWindowController sharedInstance] activate];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
    [[WebSocketManager sharedInstance] close];
}

@end
