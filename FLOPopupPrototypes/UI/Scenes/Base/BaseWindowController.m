//
//  BaseWindowController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "BaseWindowController.h"

#import "FLOPopoverConstants.h"

#import "FLOPopoverWindowController.h"

#import "AppleScript.h"

@interface BaseWindowController ()

@end

@implementation BaseWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self setupUI];
    [self registerWindowChangeModeEvent];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - Setup UI
#pragma mark -
- (void)setupUI {
    NSRect visibleFrame = [self.window.screen visibleFrame];
    CGFloat width = 0.5f * visibleFrame.size.width;
    CGFloat height = 0.69f * visibleFrame.size.height;
    CGFloat x = (visibleFrame.size.width - width) / 2;
    CGFloat y = (visibleFrame.size.height + visibleFrame.origin.y - height) / 2;
    NSRect viewFrame = NSMakeRect(x, y, width, height);
    
    [self.window setFrame:viewFrame display:YES];
    [self.window setMinSize:NSMakeSize(0.5f * visibleFrame.size.width, 0.5f * visibleFrame.size.height)];
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (void)changeWindowToDesktopMode {
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask = NSBorderlessWindowMask;
    [self.window makeKeyAndOrderFront:nil];
    self.window.level = kCGDesktopIconWindowLevel + 1;
    
    //    [self.window setFrame:[self.window.screen visibleFrame] display:YES animate:YES];
    [self.window setFrame:[self.window.screen visibleFrame] display:YES];
}

- (void)changeWindowToNormalMode {
    self.window.titleVisibility = NSWindowTitleVisible;
    self.window.styleMask = (NSWindowStyleMaskTitled | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask);
    self.window.level = NSNormalWindowLevel;
    
    //    [self.window setFrame:[[FLOPopoverWindow sharedInstance] windowNormalFrame] display:YES animate:YES];
    [self.window setFrame:[[FLOPopoverWindow sharedInstance] windowNormalFrame] display:YES];
}

#pragma mark -
#pragma mark - Notification
#pragma mark -
- (void)registerWindowChangeModeEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeMode:) name:FLO_NOTIFICATION_WINDOW_DID_CHANGE_MODE object:nil];
}

- (void)removeWindowChangeModeEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FLO_NOTIFICATION_WINDOW_DID_CHANGE_MODE object:nil];
}

- (void)windowDidChangeMode:(NSNotification *)notification {
    if ([notification.name isEqualToString:FLO_NOTIFICATION_WINDOW_DID_CHANGE_MODE]) {
        if ([[FLOPopoverWindow sharedInstance] windowMode] == FLOWindowModeDesktop) {
            [self changeWindowToDesktopMode];
            AppleScriptHideAllApps();
        } else {
            [self changeWindowToNormalMode];
        }
    }
}

@end
