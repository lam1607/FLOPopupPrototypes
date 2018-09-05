//
//  NSView+WSAnimator.m
//  entitlement-apps-ws-concept
//
//  Created by Truong Quang Hung on 12/21/16.
//  Copyright © 2016 Truong Quang Hung. All rights reserved.
//

#import "NSView+Animator.h"

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CoreImage.h>

#import "CABasicAnimation+Extensions.h"
#import "FLOGraphicsContext.h"
#import "FLOKeyframeAnimation.h"

@implementation NSView (Animator)
- (NSImage *)imageRepresentationOffscreen:(NSRect)screenBounds {
    // Grab the image representation of the window, without the shadows.
    CGImageRef windowImageRef;
    windowImageRef = CGWindowListCreateImage(screenBounds, kCGWindowListOptionIncludingWindow, (CGWindowID)self.window.windowNumber, kCGWindowImageBoundsIgnoreFraming);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(windowImageRef);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(windowImageRef), CGImageGetHeight(windowImageRef));
    
    CGContextRef ctx = FLOCreateGraphicsContext(screenBounds.size, colorSpace);
    
    // Draw the window image into the newly-created context.
    CGContextDrawImage(ctx, (CGRect){ .size = imageSize }, windowImageRef);
    
    CGImageRef copiedWindowImageRef = CGBitmapContextCreateImage(ctx);
    NSImage *image = [[NSImage alloc] initWithCGImage:copiedWindowImageRef
                                                 size:imageSize];
    
    CGContextRelease(ctx);
    CGImageRelease(windowImageRef);
    CGImageRelease(copiedWindowImageRef);
    
    return image;
}

- (CALayer *)layerFromVisibleContents {
    CALayer *newLayer = [CALayer layer];
    newLayer.contents = [self imageRepresentationOffscreen:NSZeroRect];
    return newLayer;
}

- (CALayer *)layerFromContents {
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = self.bounds;
    NSBitmapImageRep *bitmapRep;
    bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
    id layerContents = (id)bitmapRep.CGImage;;
    newLayer.contents = layerContents;
    return newLayer;
}

#pragma mark internals
- (CGRect)shadowRect {
    CGRect windowBounds = (CGRect){ .size = self.frame.size };
    CGRect rect = CGRectInset(windowBounds, -JNWAnimatableWindowShadowHorizontalOutset, 0);
    rect.size.height += JNWAnimatableWindowShadowTopOffset;
    
    return rect;
}

- (CGRect)convertWindowFrameToScreenFrame:(CGRect)windowFrame {
    return (CGRect) {
        .size = windowFrame.size,
        .origin.x = windowFrame.origin.x - self.window.screen.frame.origin.x,
        .origin.y = windowFrame.origin.y - self.window.screen.frame.origin.y
    };
}

#pragma mark view animated
static const CGFloat JNWAnimatableWindowShadowOpacity = 0.58f;
static const CGSize JNWAnimatableWindowShadowOffset = (CGSize){ 0, -30.f };
static const CGFloat JNWAnimatableWindowShadowRadius = 19.f;
static const CGFloat JNWAnimatableWindowShadowHorizontalOutset = 7.f;
static const CGFloat JNWAnimatableWindowShadowTopOffset = 14.f;

static CALayer *subLayer;
- (void)resizeAnimationWithDuration:(NSTimeInterval)duration fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame fromOpacity:(CGFloat)fromOpacity toOpacity:(CGFloat)toOpacity {
    
    subLayer = [CALayer layer];
    subLayer.contentsScale = 1.2;
    
    CGColorRef shadowColor = CGColorCreateGenericRGB(0, 0, 0, JNWAnimatableWindowShadowOpacity);
    subLayer.shadowColor = shadowColor;
    subLayer.shadowOffset = JNWAnimatableWindowShadowOffset;
    subLayer.shadowRadius = JNWAnimatableWindowShadowRadius;
    subLayer.shadowOpacity = 1.f;
    CGColorRelease(shadowColor);
    
    CGPathRef shadowPath = CGPathCreateWithRect(self.shadowRect, NULL);
    subLayer.shadowPath = shadowPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)subLayer.shadowPath;
    animation.toValue = (__bridge id)(shadowPath);
    animation.duration = 5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    subLayer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    
    subLayer.contentsGravity = kCAGravityResize;
    subLayer.opaque = YES;

    
    // ensure that the layer's contents are set before we get rid of the real window.
    subLayer.frame = [self convertWindowFrameToScreenFrame:fromFrame];
    
    [self.layer addSublayer:subLayer];
    
    NSImage *originalImg = [self imageRepresentationOffscreen:fromFrame];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    subLayer.contents = originalImg;
    [CATransaction commit];
    
    NSImage *finalImg = [self imageRepresentationOffscreen:toFrame];
    [NSAnimationContext beginGrouping];
    [CATransaction begin];
    [CATransaction setAnimationDuration:5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    [CATransaction setCompletionBlock:^{
        
        [subLayer removeFromSuperlayer];
        subLayer = nil;
    }];

    [subLayer addAnimation:animation forKey:@"shadowPath"];
    subLayer.contents = finalImg;
    subLayer.frame = toFrame;
    [CATransaction commit];
    [NSAnimationContext endGrouping];
}

- (void)transformAlongAxis:(NSInteger)axis scaleFactor:(CGFloat)scaleFactor startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint onDuration:(CGFloat)duration {

    // ensure that the layer's contents are set before we get rid of the real window.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    CAAnimation  *animator;
    if(axis == axis_x) {
        animator = [CABasicAnimation transformAxisXAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.f fromTransX:startPoint toTransX:endPoint fromOpacity:0.f toOpacity:1.f];
    } else if(axis == axis_y) {
        animator = [CABasicAnimation transformAxisYAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.f fromTransY:startPoint toTransY:endPoint fromOpacity:0.f toOpacity:1.f];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [CATransaction setCompletionBlock:^{
        self.alphaValue = 1.f;
        [self.layer removeAllAnimations];
    }];
    
    [self.layer addAnimation:animator forKey:@"axis-transform"];
    [CATransaction commit];
}

- (void)transitionAlongAxis:(NSInteger)axis startPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint onDuration:(CGFloat)duration {
    
    // ensure that the layer's contents are set before we get rid of the real window.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    CABasicAnimation* positionAnim;
    if(axis == axis_x) {
        positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnim.fromValue = [NSValue valueWithPoint:startPoint];
        positionAnim.toValue = [NSValue valueWithPoint:endPoint];
    } else if(axis == axis_y) {
        positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnim.fromValue = [NSValue valueWithPoint:startPoint];
        positionAnim.toValue = [NSValue valueWithPoint:endPoint];
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [CATransaction setCompletionBlock:^{
        [self.layer removeAllAnimations];
    }];
    
    [self.layer addAnimation:positionAnim forKey:@"axis-transform"];
    [CATransaction commit];
}

#pragma mark utilities
- (void)animatedDisplayWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)())handler {
     [self.layer removeAllAnimations];
     // along x-axis / this is
     CABasicAnimation *animationx = [CABasicAnimation animationWithKeyPath:nil];
     
     animationx.toValue = [NSValue valueWithPoint:endedPoint];
     animationx.fromValue = [NSValue valueWithPoint:beginPoint];
     
     CABasicAnimation *topOpacity = [CABasicAnimation animationWithKeyPath:nil];
     topOpacity.fromValue = @(0.0);
     topOpacity.toValue = @(1);
     
     [CATransaction begin];
     [CATransaction setAnimationDuration:0.3];
     [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
     [CATransaction setCompletionBlock:^{
         if(handler != nil) {
             handler();
         }
     }];
    
     [self.layer addAnimation:animationx forKey:@"position.x"];
     [self.layer addAnimation:topOpacity forKey:@"opacity"];
     [CATransaction commit];
}

- (void)animatedCloseWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)())handler {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:nil];
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:nil];
    opacityAnim.fromValue = @(0.5);
    opacityAnim.toValue = @(0.0);
    
    animation.toValue = [NSValue valueWithPoint:endedPoint];
    animation.fromValue = [NSValue valueWithPoint:beginPoint];
    
    self.alphaValue = 0.f;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [CATransaction setCompletionBlock:^{
        self.alphaValue = 1.f;
        [self .layer removeAllAnimations];
        if(handler != nil) {
            handler();
        }
    }];
    [self.layer addAnimation:opacityAnim forKey:@"opacity"];
    [self.layer addAnimation:animation forKey:@"position.x"];
    [CATransaction commit];

}

@end
