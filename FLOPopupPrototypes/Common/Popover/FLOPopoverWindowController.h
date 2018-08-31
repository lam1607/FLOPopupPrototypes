//
//  FLOPopoverWindowController.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// FLOPopoverWindow subclased of NSWindow (can see AnimatedWindow in FloProj)
@interface FLOPopoverWindow : NSWindow

@property (nonatomic, strong, readonly) NSWindow *applicationWindow;

@property (nonatomic, strong, readonly) NSWindow *topWindow;
@property (nonatomic, strong, readonly) NSView *topView;

+ (FLOPopoverWindow *)sharedInstance;

- (void)setTopmostWindow:(NSWindow *)topmostWindow;
- (void)setTopmostView:(NSView *)topmostView;

@end

@interface FLOPopoverWindowController : NSWindowController

@end
