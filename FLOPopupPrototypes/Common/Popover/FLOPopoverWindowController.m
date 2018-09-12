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
@property (nonatomic, strong, readwrite) NSWindow *snapshotWindow;

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
    if (_animatedWindow == nil) {
        _animatedWindow = [[NSWindow alloc] initWithContentRect:self.applicationWindow.screen.visibleFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        
        _animatedWindow.hidesOnDeactivate = YES;
        _animatedWindow.releasedWhenClosed = NO;
        _animatedWindow.opaque = NO;
        _animatedWindow.hasShadow = NO;
        _animatedWindow.backgroundColor = [NSColor clearColor];
        _animatedWindow.contentView.wantsLayer = YES;
    }
    
    return _animatedWindow;
}

- (NSWindow *)snapshotWindow {
    if (_snapshotWindow == nil) {
        _snapshotWindow = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        
        _snapshotWindow.hidesOnDeactivate = YES;
        _snapshotWindow.releasedWhenClosed = NO;
        _snapshotWindow.opaque = NO;
        _snapshotWindow.hasShadow = YES;
        _snapshotWindow.backgroundColor = [NSColor clearColor];
        _snapshotWindow.contentView.wantsLayer = YES;
    }
    
    return _snapshotWindow;
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
    [self.snapshotWindow setFrame:view.bounds display:NO];
    
    return self.snapshotWindow;
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
