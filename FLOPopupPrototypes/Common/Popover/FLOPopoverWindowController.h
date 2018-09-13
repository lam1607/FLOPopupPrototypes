//
//  FLOPopoverWindowController.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLOPopoverConstants.h"

// FLOPopoverWindow subclased of NSWindow (can see AnimatedWindow in FloProj)
@interface FLOPopoverWindow : NSWindow

@property (nonatomic, strong, readonly) NSWindow *applicationWindow;
@property (nonatomic, assign, readonly) FLOWindowMode windowMode;
@property (nonatomic, assign, readonly) NSRect windowNormalFrame;
@property (nonatomic, assign, readonly) CGFloat windowTitleBarHeight;

@property (nonatomic, strong, readonly) NSWindow *topWindow;
@property (nonatomic, strong, readonly) NSView *topView;

@property (nonatomic, strong, readonly) NSWindow *animatedWindow;

+ (FLOPopoverWindow *)sharedInstance;

- (void)setWindowMode;
- (void)setWindowTitleBarHeight;
- (void)setTopmostWindow:(NSWindow *)topmostWindow;
- (void)setTopmostView:(NSView *)topmostView;

- (NSWindow *)snapshotWindowFromView:(NSView *)view;

@end

@interface FLOPopoverWindowController : NSWindowController

@end
