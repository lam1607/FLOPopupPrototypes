//
//  FLOPopoverWindowController.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOPopoverWindowController.h"

#import "AppDelegate.h"

#import "FLOPopoverConstants.h"

#import "AppleScript.h"

#pragma mark -
#pragma mark - FLOPopoverWindow
#pragma mark -
@interface FLOPopoverWindow ()

@property (nonatomic, strong, readwrite) NSWindow *topWindow;
@property (nonatomic, strong, readwrite) NSView *topView;

@property (nonatomic, strong, readwrite) NSWindow *animatedWindow;

@end

@implementation FLOPopoverWindow

@synthesize topWindow = _topWindow;
@synthesize topView = _topView;

#pragma mark -
#pragma mark - Singleton
#pragma mark -
+ (FLOPopoverWindow *)sharedInstance {
    static FLOPopoverWindow *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FLOPopoverWindow alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark -
#pragma mark - Getter/Setter
#pragma mark -
- (NSWindow *)topWindow {
    return _topWindow;
}

- (NSView *)topView {
    return _topView;
}

- (NSWindow *)animatedWindow {
    if (_animatedWindow == nil) {
        _animatedWindow = [[NSWindow alloc] initWithContentRect:[[FLOPopoverWindowController sharedInstance] applicationWindow].screen.visibleFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        
        _animatedWindow.hidesOnDeactivate = YES;
        _animatedWindow.releasedWhenClosed = NO;
        _animatedWindow.opaque = NO;
        _animatedWindow.hasShadow = NO;
        _animatedWindow.backgroundColor = [NSColor clearColor];
        _animatedWindow.contentView.wantsLayer = YES;
    }
    
    return _animatedWindow;
}

- (void)setTopmostWindow:(NSWindow *)topmostWindow {
    _topWindow = topmostWindow;
}

- (void)setTopmostView:(NSView *)topmostView {
    _topView = topmostView;
}

@end

#pragma mark -
#pragma mark - FLOPopoverWindowController
#pragma mark -
@interface FLOPopoverWindowController ()

@property (nonatomic, assign, readwrite) FLOWindowMode windowMode;
@property (nonatomic, assign, readwrite) BOOL windowInDesktopMode;
@property (nonatomic, assign, readwrite) NSRect windowNormalFrame;
@property (nonatomic, assign, readwrite) CGFloat windowTitleBarHeight;

@end

@implementation FLOPopoverWindowController

@synthesize windowMode = _windowMode;
@synthesize windowTitleBarHeight = _windowTitleBarHeight;

#pragma mark -
#pragma mark - Singleton
#pragma mark -
+ (FLOPopoverWindowController *)sharedInstance {
    static FLOPopoverWindowController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FLOPopoverWindowController alloc] init];
        _sharedInstance.windowMode = FLOWindowModeNormal;
    });
    
    return _sharedInstance;
}

#pragma mark -
#pragma mark - Window lifecycle
#pragma mark -
- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self registerWindowChangeModeEvent];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - Getter/Setter
#pragma mark -
- (NSWindow *)applicationWindow {
    return [NSApp mainWindow];
}

- (FLOWindowMode)windowMode {
    return _windowMode;
}

- (BOOL)windowInDesktopMode {
    return [[FLOPopoverWindowController sharedInstance] windowMode] == FLOWindowModeDesktop;
}

- (NSRect)windowNormalFrame {
    return _windowNormalFrame;
}

- (CGFloat)windowTitleBarHeight {
    return _windowTitleBarHeight;
}

- (void)setWindowMode {
    if (_windowMode == FLOWindowModeNormal) {
        _windowMode = FLOWindowModeDesktop;
        _windowNormalFrame = self.applicationWindow.frame;
    } else {
        _windowMode = FLOWindowModeNormal;
    }
}

- (void)setWindowTitleBarHeight {
    _windowTitleBarHeight = self.applicationWindow.frame.size.height - self.applicationWindow.contentView.frame.size.height;
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
    [self.window setFrame:[[FLOPopoverWindowController sharedInstance] windowNormalFrame] display:YES];
}

//static const NSWindowLevel NSNormalWindowLevel = kCGNormalWindowLevel;
//static const NSWindowLevel NSFloatingWindowLevel = kCGFloatingWindowLevel;
//static const NSWindowLevel NSSubmenuWindowLevel = kCGTornOffMenuWindowLevel;
//static const NSWindowLevel NSTornOffMenuWindowLevel = kCGTornOffMenuWindowLevel;
//static const NSWindowLevel NSMainMenuWindowLevel = kCGMainMenuWindowLevel;
//static const NSWindowLevel NSStatusWindowLevel = kCGStatusWindowLevel;
//static const NSWindowLevel NSDockWindowLevel NS_DEPRECATED_MAC(10_0, 10_13) = kCGDockWindowLevel;
//static const NSWindowLevel NSModalPanelWindowLevel = kCGModalPanelWindowLevel;
//static const NSWindowLevel NSPopUpMenuWindowLevel = kCGPopUpMenuWindowLevel;
//static const NSWindowLevel NSScreenSaverWindowLevel = kCGScreenSaverWindowLevel;

- (void)hideChildenWindowsOnDeactivate {
    DLog(@"self.window = %@", self.window);
    DLog(@"[[FLOPopoverWindowController sharedInstance] applicationWindow] = %@", [[FLOPopoverWindowController sharedInstance] applicationWindow]);
    DLog(@"[[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows = %@", [[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows);
    
    for (NSWindow *childWindow in [[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows) {
        childWindow.level = (childWindow == [FLOPopoverWindow sharedInstance].topWindow) ? self.window.level + 1 : self.window.level;
    }
}

- (void)showChildenWindowsOnActivate {
    DLog(@"self.window = %@", self.window);
    DLog(@"[[FLOPopoverWindowController sharedInstance] applicationWindow] = %@", [[FLOPopoverWindowController sharedInstance] applicationWindow]);
    DLog(@"[[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows = %@", [[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows);
    
    for (NSWindow *childWindow in [[FLOPopoverWindowController sharedInstance] applicationWindow].childWindows) {
        if (childWindow.level >= [[FLOPopoverWindowController sharedInstance] applicationWindow].level) {
            childWindow.level = (childWindow == [FLOPopoverWindow sharedInstance].topWindow) ? NSStatusWindowLevel : NSFloatingWindowLevel;
        }
    }
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
        if ([[FLOPopoverWindowController sharedInstance] windowMode] == FLOWindowModeDesktop) {
            [self changeWindowToDesktopMode];
            AppleScriptHideAllApps();
        } else {
            [self changeWindowToNormalMode];
        }
    }
}

@end
