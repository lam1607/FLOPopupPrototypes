//
//  FLOPopoverWindowController.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOPopoverWindowController.h"

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
- (NSWindow *)applicationWindow {
    return [NSApp mainWindow];
}

- (NSWindow *)topWindow {
    return _topWindow;
}

- (NSView *)topView {
    return _topView;
}

- (NSWindow *)animatedWindow {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:self.applicationWindow.screen.visibleFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    window.hidesOnDeactivate = YES;
    window.releasedWhenClosed = YES;
    window.opaque = NO;
    window.hasShadow = NO;
    window.backgroundColor = [NSColor clearColor];
    window.contentView.wantsLayer = YES;
    window.level = NSScreenSaverWindowLevel;
    
    return window;
}

- (void)setTopmostWindow:(NSWindow *)topmostWindow {
    _topWindow = topmostWindow;
}

- (void)setTopmostView:(NSView *)topmostView {
    _topView = topmostView;
}

#pragma mark -
#pragma mark - Utilities
#pragma mark -
- (NSWindow *)snapshotWindowFromView:(NSView *)view {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:view.bounds styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    window.hidesOnDeactivate = YES;
    window.releasedWhenClosed = NO;
    window.opaque = NO;
    window.hasShadow = YES;
    window.backgroundColor = [NSColor clearColor];
    window.contentView.wantsLayer = YES;
    
    return window;
}

@end

@interface FLOPopoverWindowController ()

@end

@implementation FLOPopoverWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
