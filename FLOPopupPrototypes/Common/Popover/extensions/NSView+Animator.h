//
//  NSView+Animator.h
//  entitlement-apps-ws-concept
//
//  Created by Truong Quang Hung on 12/21/16.
//  Copyright © 2016 Truong Quang Hung. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, AXIS_XY) {
    axis_x              = 1,
    axis_y
};

@interface NSView (Animator)
- (CALayer *)layerFromContents;

#pragma mark transform animator
- (void)transformAlongAxis:(NSInteger)axis scaleFactor:(CGFloat)scaleFactor startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint onDuration:(CGFloat)duration;
- (void)transitionAlongAxis:(NSInteger)axis startPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint onDuration:(CGFloat)duration;

#pragma mark utilities
- (void)animatedDisplayWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)(void))handler;
- (void)animatedCloseWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)(void))handler;

- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition;
- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition completionHandler:(void(^)(void))complete;
- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition duration:(NSTimeInterval)duration completionHandler:(void(^)(void))complete;

@end
