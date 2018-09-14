//
//  FLOPopoverWindowController.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLOPopoverConstants.h"

#pragma mark -
#pragma mark - FLOPopoverWindow
#pragma mark -
// FLOPopoverWindow subclased of NSWindow (can see AnimatedWindow in FloProj)
@interface FLOPopoverWindow : NSWindow

@property (nonatomic, strong, readonly) NSWindow *topWindow;
@property (nonatomic, strong, readonly) NSView *topView;

@property (nonatomic, strong, readonly) NSWindow *animatedWindow;

+ (FLOPopoverWindow *)sharedInstance;

- (void)setTopmostWindow:(NSWindow *)topmostWindow;
- (void)setTopmostView:(NSView *)topmostView;

@end

#pragma mark -
#pragma mark - FLOPopoverWindowController
#pragma mark -
@interface FLOPopoverWindowController : NSWindowController

@property (nonatomic, strong, readonly) NSWindow *applicationWindow;
@property (nonatomic, assign, readonly) FLOWindowMode windowMode;
@property (nonatomic, assign, readonly) BOOL windowInDesktopMode;
@property (nonatomic, assign, readonly) NSRect windowNormalFrame;
@property (nonatomic, assign, readonly) CGFloat windowTitleBarHeight;

+ (FLOPopoverWindowController *)sharedInstance;

- (void)setWindowMode;
- (void)setWindowTitleBarHeight;

- (void)hideChildenWindowsOnDeactivate;
- (void)showChildenWindowsOnActivate;

@end
