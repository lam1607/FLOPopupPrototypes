//
//  FLOViewPopup.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOViewPopup.h"

#import <QuartzCore/QuartzCore.h>

#import "FLOGraphicsContext.h"
#import "FLOPopoverWindowController.h"

#import "FLOPopoverBackgroundView.h"

@interface FLOViewPopup () <CAAnimationDelegate> {
    NSWindow *applicationWindow;
    NSEvent *applicationEvent;
    NSView *_snapshotView;
    CALayer *_snapshotLayer;
}

@property (nonatomic, strong) NSView *popoverView;

@property (nonatomic, readonly, getter = isShown) BOOL shown;

@property (nonatomic, strong) NSView *contentView;
@property (nonatomic, strong) NSViewController *contentViewController;

@property (nonatomic, assign) FLOPopoverAnimationBehaviour animationBehaviour;
@property (nonatomic, assign) FLOPopoverAnimationTransition animationType;

@property (nonatomic, strong) FLOPopoverBackgroundView *backgroundView;
@property (nonatomic) NSRect positioningRect;
@property (nonatomic, strong) NSView *positioningView;
@property (nonatomic) NSRectEdge preferredEdge;
@property (nonatomic) CGSize contentSize;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic) CGSize originalViewSize;

@end

@implementation FLOViewPopup

@synthesize popoverDidShow;
@synthesize popoverDidClose;

- (instancetype)initWithContentView:(NSView *)contentView {
    if (self = [super init]) {
        applicationWindow = [[FLOPopoverWindow sharedInstance] applicationWindow];
        _contentView = contentView;
        _backgroundView = [[FLOPopoverBackgroundView alloc] initWithFrame:contentView.frame];
        _anchorPoint = CGPointMake(0.0f, 0.0f);
        _alwaysOnTop = NO;
        _shouldShowArrow = NO;
        _animated = NO;
        _animationBehaviour = FLOPopoverAnimationBehaviorNone;
        _animationType = FLOPopoverAnimationLeftToRight;
        _closesWhenPopoverResignsKey = NO;
        _closesWhenApplicationBecomesInactive = NO;
    }
    
    return self;
}

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController {
    if (self = [super init]) {
        applicationWindow = [[FLOPopoverWindow sharedInstance] applicationWindow];
        _contentViewController = contentViewController;
        _contentView = contentViewController.view;
        _backgroundView = [[FLOPopoverBackgroundView alloc] initWithFrame:contentViewController.view.frame];
        _anchorPoint = CGPointMake(0.0f, 0.0f);
        _alwaysOnTop = NO;
        _shouldShowArrow = NO;
        _animated = NO;
        _closesWhenPopoverResignsKey = NO;
        _closesWhenApplicationBecomesInactive = NO;
    }
    
    return self;
}

- (void)dealloc {
    if ([self.popoverView isDescendantOf:applicationWindow.contentView]) {
        [self.popoverView removeFromSuperview];
        self.popoverView = nil;
        
        [_snapshotView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (BOOL)isShown {
    return self.popoverView != nil;
}

- (void)setPopoverEdgeType:(FLOPopoverEdgeType)edgeType {
    switch (edgeType) {
        case FLOPopoverEdgeTypeHorizontalAboveLeftEdge:
            self.preferredEdge = NSRectEdgeMaxY;
            self.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case FLOPopoverEdgeTypeHorizontalAboveRightEdge:
            self.preferredEdge = NSRectEdgeMaxY;
            self.anchorPoint = CGPointMake(1.0f, 1.0f);
            break;
        case FLOPopoverEdgeTypeHorizontalBelowLeftEdge:
            self.preferredEdge = NSRectEdgeMinY;
            self.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case FLOPopoverEdgeTypeHorizontalBelowRightEdge:
            self.preferredEdge = NSRectEdgeMinY;
            self.anchorPoint = CGPointMake(1.0f, 1.0f);
            break;
        case FLOPopoverEdgeTypeVerticalBackwardBottomEdge:
            self.preferredEdge = NSRectEdgeMinX;
            self.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case FLOPopoverEdgeTypeVerticalBackwardTopEdge:
            self.preferredEdge = NSRectEdgeMinX;
            self.anchorPoint = CGPointMake(1.0f, 1.0f);
            break;
        case FLOPopoverEdgeTypeVerticalForwardBottomEdge:
            self.preferredEdge = NSRectEdgeMaxX;
            self.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case FLOPopoverEdgeTypeVerticalForwardTopEdge:
            self.preferredEdge = NSRectEdgeMaxX;
            self.anchorPoint = CGPointMake(1.0f, 1.0f);
            break;
        default:
            self.preferredEdge = NSRectEdgeMinY;
            self.anchorPoint = CGPointMake(0.5f, 0.5f);
            break;
    }
}

- (void)setTopMostViewIfNecessary {
    NSView *topView = [[FLOPopoverWindow sharedInstance] topView];
    NSArray *viewStack = applicationWindow.contentView.subviews;
    
    if ((topView != nil) && [viewStack containsObject:topView]) {
        [topView removeFromSuperview];
        [applicationWindow.contentView addSubview:topView];
    }
}

#pragma mark -
#pragma mark - Display
#pragma mark -
- (void)setAnimationBehaviour:(FLOPopoverAnimationBehaviour)animationBehaviour type:(FLOPopoverAnimationTransition)animationType {
    self.animationBehaviour = animationBehaviour;
    self.animationType = animationType;
}

- (void)showRelativeToRect:(NSRect)rect ofView:(NSView *)view edgeType:(FLOPopoverEdgeType)edgeType {
    if (self.shown) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(close) object:nil];
        [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
        
        return;
    }
    
    self.positioningRect = rect;
    self.positioningView = view;
    
    [self setPopoverEdgeType:edgeType];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(show) object:nil];
    [self performSelector:@selector(show) withObject:nil afterDelay:0.1f];
    
    [self registerForApplicationEvents];
}

- (void)show {
    if (self.shown) {
        [self close];
        return;
    }
    
    if (NSEqualRects(self.positioningRect, NSZeroRect)) {
        self.positioningRect = [self.positioningView bounds];
    }
    
    NSRect windowRelativeRect = [self.positioningView convertRect:[self.positioningView alignmentRectForFrame:self.positioningRect] toView:nil];
    NSRect positionOnScreenRect = [applicationWindow convertRectToScreen:windowRelativeRect];
    
    self.backgroundView.popoverOrigin = positionOnScreenRect;
    
    self.originalViewSize = self.contentView.frame.size;
    NSSize contentViewSize = NSEqualSizes(self.contentSize, NSZeroSize) ? self.contentView.frame.size : self.contentSize;
    NSRectEdge popoverEdge = self.preferredEdge;
    NSRect popoverScreenRect = [self popoverRect];
    
    [self.backgroundView setViewMovable:self.popoverMovable];
    [self.backgroundView setBorderRadius:PopoverBackgroundViewBorderRadius];
    [self.backgroundView setShouldShowArrow:self.shouldShowArrow];
    
    [self.backgroundView setArrowColor:self.contentView.layer.backgroundColor];
    CGSize size = [self.backgroundView sizeForBackgroundViewWithContentSize:contentViewSize popoverEdge:popoverEdge];
    self.backgroundView.frame = (NSRect) { .size = size };
    self.backgroundView.popoverEdge = popoverEdge;
    
    NSRect contentViewFrame = [self.backgroundView contentViewFrameForBackgroundFrame:self.backgroundView.bounds popoverEdge:popoverEdge];
    self.contentView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    self.contentView.frame = contentViewFrame;
    [self.backgroundView addSubview:self.contentView positioned:NSWindowAbove relativeTo:nil];
    
    [self.backgroundView setShouldShowShadow:YES];
    [self.backgroundView setFrame:[applicationWindow convertRectFromScreen:popoverScreenRect]];
    [applicationWindow.contentView addSubview:self.backgroundView positioned:NSWindowAbove relativeTo:self.positioningView];
    
    [self popoverShowing:YES animated:self.animated];
    self.popoverView = self.backgroundView;
    
    if (popoverDidShow != nil) popoverDidShow(self);
    
    if (self.alwaysOnTop) {
        [[FLOPopoverWindow sharedInstance] setTopmostView:self.backgroundView];
    }
    
    [self setTopMostViewIfNecessary];
}

- (void)close {
    if (!self.shown) return;
    
    if ([self.popoverView isDescendantOf:applicationWindow.contentView]) {
        [self removeApplicationEventsMonitor];
        [self popoverShowing:NO animated:self.animated];
        
        [self.popoverView removeFromSuperview];
        self.popoverView = nil;
        
        if (popoverDidClose != nil) popoverDidClose(self);
        
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.originalViewSize.width, self.originalViewSize.height);
    }
}

#pragma mark -
#pragma mark - Display utilities
#pragma mark -
- (NSRect)popoverRectForEdge:(NSRectEdge *)popoverEdge {
    NSRect applicationScreenRect = [applicationWindow convertRectToScreen:applicationWindow.contentView.bounds];
    NSRect windowRelativeRect = [self.positioningView convertRect:[self.positioningView alignmentRectForFrame:self.positioningRect] toView:nil];
    NSRect positionOnScreenRect = [applicationWindow convertRectToScreen:windowRelativeRect];
    NSSize contentViewSize = NSEqualSizes(self.contentSize, NSZeroSize) ? self.contentView.frame.size : self.contentSize;
    NSPoint anchorPoint = self.anchorPoint;
    
    NSSize popoverSize = [self.backgroundView sizeForBackgroundViewWithContentSize:contentViewSize popoverEdge:*popoverEdge];
    NSRect returnRect = NSMakeRect(0.0, 0.0, popoverSize.width, popoverSize.height);
    
    // In all the cases below, find the minimum and maximum position of the
    // popover and then use the anchor point to determine where the popover
    // should be between these two locations.
    //
    // `x0` indicates the x origin of the popover if `self.anchorPoint.x` is
    // 0 and aligns the left edge of the popover to the left edge of the
    // origin view. `x1` is the x origin if `self.anchorPoint.x` is 1 and
    // aligns the right edge of the popover to the right edge of the origin
    // view. The anchor point determines where the popover should be between
    // these extremes.
    if (*popoverEdge == NSRectEdgeMinY) {
        CGFloat x0 = NSMinX(positionOnScreenRect);
        CGFloat x1 = NSMaxX(positionOnScreenRect) - contentViewSize.width;
        
        returnRect.origin.x = x0 + floor((x1 - x0) * anchorPoint.x);
        returnRect.origin.y = NSMinY(positionOnScreenRect) - popoverSize.height;
        
        if (returnRect.origin.y < NSMinY(applicationScreenRect)) {
            *popoverEdge = NSRectEdgeMaxY;
            return [self popoverRectForEdge:popoverEdge];
        }
    } else if (*popoverEdge == NSRectEdgeMaxY) {
        CGFloat x0 = NSMinX(positionOnScreenRect);
        CGFloat x1 = NSMaxX(positionOnScreenRect) - contentViewSize.width;
        
        returnRect.origin.x = x0 + floor((x1 - x0) * anchorPoint.x);
        returnRect.origin.y = NSMaxY(positionOnScreenRect);
        
        if ((returnRect.origin.y + popoverSize.height) > NSMaxY(applicationScreenRect)) {
            *popoverEdge = NSRectEdgeMinY;
            return [self popoverRectForEdge:popoverEdge];
        }
    } else if (*popoverEdge == NSRectEdgeMinX) {
        CGFloat y0 = NSMinY(positionOnScreenRect);
        CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
        
        returnRect.origin.x = NSMinX(positionOnScreenRect) - popoverSize.width;
        returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
        
        if (returnRect.origin.x < NSMinX(applicationScreenRect)) {
            *popoverEdge = NSRectEdgeMaxX;
            return [self popoverRectForEdge:popoverEdge];
        }
    } else if (*popoverEdge == NSRectEdgeMaxX) {
        CGFloat y0 = NSMinY(positionOnScreenRect);
        CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
        
        returnRect.origin.x = NSMaxX(positionOnScreenRect);
        returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
        
        if ((returnRect.origin.x + popoverSize.width) > NSMaxX(applicationScreenRect)) {
            *popoverEdge = NSRectEdgeMinX;
            return [self popoverRectForEdge:popoverEdge];
        }
    } else {
        returnRect = NSZeroRect;
    }
    
    return returnRect;
}

- (BOOL)checkPopoverSizeForScreenWithPopoverEdge:(NSRectEdge *)popoverEdge {
    NSRect applicationScreenRect = [applicationWindow convertRectToScreen:applicationWindow.contentView.bounds];
    NSRect popoverRect = [self popoverRectForEdge:popoverEdge];
    
    return NSContainsRect(applicationScreenRect, popoverRect);
}

- (NSRectEdge)nextEdgeForEdge:(NSRectEdge)currentEdge {
    if (currentEdge == NSRectEdgeMaxX) {
        return (self.preferredEdge == NSRectEdgeMinX) ? NSRectEdgeMaxY : NSRectEdgeMinX;
    } else if (currentEdge == NSRectEdgeMinX) {
        return (self.preferredEdge == NSRectEdgeMaxX) ? NSRectEdgeMaxY : NSRectEdgeMaxX;
    } else if (currentEdge == NSRectEdgeMaxY) {
        return (self.preferredEdge == NSRectEdgeMinY) ? NSRectEdgeMaxX : NSRectEdgeMinY;
    } else if (currentEdge == NSRectEdgeMinY) {
        return (self.preferredEdge == NSRectEdgeMaxY) ? NSRectEdgeMaxX : NSRectEdgeMaxY;
    }
    
    return currentEdge;
}

- (NSRect)fitRectToScreen:(NSRect)proposedRect {
    NSRect applicationScreenRect = [applicationWindow convertRectToScreen:applicationWindow.contentView.bounds];
    
    if (proposedRect.origin.y < NSMinY(applicationScreenRect)) {
        proposedRect.origin.y = NSMinY(applicationScreenRect);
    }
    if (proposedRect.origin.x < NSMinX(applicationScreenRect)) {
        proposedRect.origin.x = NSMinX(applicationScreenRect);
    }
    
    if (NSMaxY(proposedRect) > NSMaxY(applicationScreenRect)) {
        proposedRect.origin.y = NSMaxY(applicationScreenRect) - NSHeight(proposedRect);
    }
    if (NSMaxX(proposedRect) > NSMaxX(applicationScreenRect)) {
        proposedRect.origin.x = NSMaxX(applicationScreenRect) - NSWidth(proposedRect);
    }
    
    return proposedRect;
}

- (BOOL)screenRectContainsRectEdge:(NSRectEdge)edge {
    NSRect proposedRect = [self popoverRectForEdge:&edge];
    NSRect applicationScreenRect = [applicationWindow convertRectToScreen:applicationWindow.contentView.bounds];
    
    BOOL minYInBounds = (edge == NSRectEdgeMinY) && (NSMinY(proposedRect) >= NSMinY(applicationScreenRect));
    BOOL maxYInBounds = (edge == NSRectEdgeMaxY) && (NSMaxY(proposedRect) <= NSMaxY(applicationScreenRect));
    BOOL minXInBounds = (edge == NSRectEdgeMinX) && (NSMinX(proposedRect) >= NSMinX(applicationScreenRect));
    BOOL maxXInBounds = (edge == NSRectEdgeMaxX) && (NSMaxX(proposedRect) <= NSMaxX(applicationScreenRect));
    
    return minYInBounds || maxYInBounds || minXInBounds || maxXInBounds;
}

- (NSRect)popoverRect {
    NSRectEdge popoverEdge = self.preferredEdge;
    NSUInteger attemptCount = 0;
    
    while (![self checkPopoverSizeForScreenWithPopoverEdge:&popoverEdge]) {
        if (attemptCount >= 4) {
            popoverEdge = [self screenRectContainsRectEdge:self.preferredEdge] ? self.preferredEdge : [self nextEdgeForEdge:self.preferredEdge];
            
            return [self fitRectToScreen:[self popoverRectForEdge:&popoverEdge]];
            break;
        }
        
        popoverEdge = [self nextEdgeForEdge:popoverEdge];
        ++attemptCount;
    }
    
    return [self popoverRectForEdge:&popoverEdge];
}

#pragma mark -
#pragma mark - Display animations
#pragma mark -
- (void)popoverShowing:(BOOL)showing animated:(BOOL)animated {
    if (animated) {
        switch (self.animationBehaviour) {
            case FLOPopoverAnimationBehaviorTransform:
                break;
            case FLOPopoverAnimationBehaviorTransition:
                [self popoverTransitionAnimationShowing:showing];
                break;
            default:
                return;
        }
    }
}

- (void)popoverTransitionAnimationShowing:(BOOL)showing {
    if (self.animationBehaviour == FLOPopoverAnimationBehaviorTransition) {
        _snapshotView = [[NSView alloc] initWithFrame:applicationWindow.contentView.frame];
        _snapshotView.wantsLayer = YES;
        _snapshotView.layer.backgroundColor = [[NSColor clearColor] CGColor];
        
        if (_snapshotLayer.superlayer != nil) {
            [_snapshotLayer removeFromSuperlayer];
        }
        
        _snapshotLayer = [self snapshotToImageLayerFromView:self.contentView];
        _snapshotLayer.frame = self.backgroundView.frame;
        
        [[_snapshotView layer] addSublayer:_snapshotLayer];
        [applicationWindow.contentView addSubview:_snapshotView positioned:NSWindowAbove relativeTo:self.backgroundView];
        
        //============================================================================================================
        // Animation for snapshots
        //============================================================================================================
        CAAnimation *snapshotAnimation = [self showingAnimated:showing withLayer:_snapshotLayer animationType:self.animationType];
        
        self.backgroundView.needsDisplay = NO;
        snapshotAnimation.delegate = self;
        [CATransaction begin];
        [_snapshotLayer addAnimation:snapshotAnimation forKey:nil];
        [CATransaction commit];
    }
}

//- (void)popoverTransitionAnimationShowing:(BOOL)showing {
//    if (self.animationBehaviour == FLOPopoverAnimationBehaviorTransition) {
//        NSRect fromFrame = self.backgroundView.frame;
//        NSRect toFrame = fromFrame;
//
//        switch (self.animationType) {
//            case FLOPopoverAnimationLeftToRight:
//                if (showing) {
//                    fromFrame.origin.x -= toFrame.size.width / 2;
//                } else {
//                    toFrame.origin.x -= fromFrame.size.width / 2;
//                }
//                break;
//            case FLOPopoverAnimationRightToLeft:
//                if (showing) {
//                    fromFrame.origin.x += toFrame.size.width / 2;
//                } else {
//                    toFrame.origin.x += fromFrame.size.width / 2;
//                }
//                break;
//            case FLOPopoverAnimationTopToBottom:
//                if (showing) {
//                    fromFrame.origin.y += toFrame.size.height / 2;
//                } else {
//                    toFrame.origin.y += fromFrame.size.height / 2;
//                }
//                break;
//            case FLOPopoverAnimationBottomToTop:
//                if (showing) {
//                    fromFrame.origin.y -= toFrame.size.height / 2;
//                } else {
//                    toFrame.origin.y -= fromFrame.size.height / 2;
//                }
//                break;
//            case FLOPopoverAnimationFromMiddle:
//                break;
//            default:
//                break;
//        }
//
//        [self movePopoverAnimatedFromFrame:fromFrame toFrame:toFrame showing:showing];
//    }
//}
//
//- (void)movePopoverAnimatedFromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame showing:(BOOL)showing {
//    if (showing) {
//        [self.backgroundView setFrame:toFrame];
//    }
//
//    NSString *fadeEffect = showing ? NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect;
//
//    NSDictionary *resizeEffect = [[NSDictionary alloc] initWithObjectsAndKeys: self.backgroundView, NSViewAnimationTargetKey,
//                                  [NSValue valueWithRect:fromFrame], NSViewAnimationStartFrameKey,
//                                  [NSValue valueWithRect:toFrame], NSViewAnimationEndFrameKey,
//                                  fadeEffect, NSViewAnimationEffectKey, nil];
//
//    NSArray *effects = [[NSArray alloc] initWithObjects:resizeEffect, nil];
//    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:effects];
//
//    // Use our standard window-resize animation speed for the transition
//    animation.animationBlockingMode = NSAnimationBlocking;
//    animation.duration = 0.25f;
//    animation.animationCurve = NSAnimationLinear;
//    [animation startAnimation];
//}

/**
 * Convert rectangle from one view coordinates to another
 *
 * @param rect <#rect description#>
 * @param fromView <#fromView description#>
 * @param toView <#toView description#>
 * @return <#return value description#>
 */
- (CGRect)rect:(NSRect)rect fromView:(NSView *)fromView toView:(NSView *)toView {
    rect = [fromView convertRect:rect toView:nil];
    rect = [fromView.window convertRectToScreen:rect];
    rect = [toView.window convertRectFromScreen:rect];
    rect = [toView convertRect:rect fromView:nil];
    
    return NSRectToCGRect(rect);
}

/**
 * Get snapshot of selected view as layer with bitmap image
 *
 * @param view <#view description#>
 * @return <#return value description#>
 */
- (CALayer *)snapshotToImageLayerFromView:(NSView*)view {
    // Make view snapshot
    NSBitmapImageRep *imageRep = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
    [view cacheDisplayInRect:view.bounds toBitmapImageRep:imageRep];
    NSImage *image = [[NSImage alloc] initWithSize:view.bounds.size];
    [image addRepresentation:imageRep];
    CALayer *layer = [CALayer layer];
    layer.contents = image;
    // Add shadow of window to snapshot
    [layer setShadowOpacity:0.5];
    [layer setShadowColor:[[NSColor lightGrayColor] CGColor]];
    [layer setShadowOffset:NSMakeSize(-0.5f, 0.5f)];
    [layer setShadowRadius:5.0f];
    
    return layer;
}

- (CAAnimation *)showingAnimated:(BOOL)showing withLayer:(CALayer *)layer animationType:(FLOPopoverAnimationTransition)animationType {
    // Set transition direction
    NSString *transitionKeypath = (animationType == FLOPopoverAnimationBottomToTop || animationType == FLOPopoverAnimationTopToBottom) ? @"position.y" : @"position.x";
    CABasicAnimation *transitionAnimation = [CABasicAnimation animationWithKeyPath:transitionKeypath];
    
    NSPoint fromPostion = layer.position;
    NSPoint toPostion = layer.position;
    
    if (animationType == FLOPopoverAnimationLeftToRight) {
        if (showing) {
            fromPostion.x -= layer.frame.size.width / 2;
        } else {
            toPostion.x -= layer.frame.size.width / 2;
        }
    } else if (animationType == FLOPopoverAnimationRightToLeft) {
        if (showing) {
            fromPostion.x += layer.frame.size.width / 2;
        } else {
            toPostion.x += layer.frame.size.width / 2;
        }
    } else if (animationType == FLOPopoverAnimationTopToBottom) {
        if (showing) {
            layer.position = NSMakePoint(fromPostion.x, fromPostion.y + layer.frame.size.height / 2);
            toPostion.y += layer.frame.size.height / 2;
        } else {
            fromPostion.y += layer.frame.size.height / 2;
        }
    } else if (animationType == FLOPopoverAnimationBottomToTop) {
        if (showing) {
            layer.position = NSMakePoint(fromPostion.x, fromPostion.y - layer.frame.size.height / 2);
            toPostion.y -= layer.frame.size.height / 2;
        } else {
            fromPostion.y -= layer.frame.size.height / 2;
        }
    } else {
    }
    
    NSValue *fromValue = [NSValue valueWithPoint:fromPostion];
    NSValue *toValue = [NSValue valueWithPoint:toPostion];
    
    if ((animationType == FLOPopoverAnimationLeftToRight) || (animationType == FLOPopoverAnimationRightToLeft)) {
        transitionAnimation.fromValue = fromValue;
        transitionAnimation.toValue = toValue;
    } else {
        transitionAnimation.byValue = @(fromPostion.y - toPostion.y);
    }
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = showing ? @(0.0) : @(0.5);
    opacityAnimation.toValue = showing ? @(1.0) : @(0.0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:transitionAnimation, opacityAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = 3.15f;
    animationGroup.removedOnCompletion = YES;
    
    return animationGroup;
}

#pragma mark -
#pragma mark - CAAnimationDelegate
#pragma mark -
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (self.popoverView.superview != nil) {
        self.backgroundView.alphaValue = 1.0f;
    }
    
    if ([_snapshotView isDescendantOf:applicationWindow.contentView]) {
        [_snapshotView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - Event monitor
#pragma mark -
- (void)registerForApplicationEvents {
    if (self.closesWhenPopoverResignsKey) {
        [self registerApplicationEventsMonitor];
    }
    
    if (self.closesWhenApplicationBecomesInactive) {
        [self registerApplicationActiveNotification];
    }
}

- (void)removeAllApplicationEvents {
    [self removeApplicationEventsMonitor];
    [self removeApplicationActiveNotification];
}

- (void)registerApplicationActiveNotification {
    if (self.closesWhenApplicationBecomesInactive) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appResignedActive:) name:NSApplicationDidResignActiveNotification object:NSApp];
    }
}

- (void)removeApplicationActiveNotification {
    if (self.closesWhenApplicationBecomesInactive) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSApplicationDidResignActiveNotification object:NSApp];
        
        self.closesWhenApplicationBecomesInactive = NO;
    }
}

- (void)registerApplicationEventsMonitor {
    if (!applicationEvent) {
        applicationEvent = [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown) handler:^(NSEvent* event) {
            if (self.closesWhenPopoverResignsKey) {
                if (self.popoverView.window != event.window) {
                    [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
                } else {
                    NSPoint eventPoint = [self.popoverView convertPoint:event.locationInWindow fromView:nil];
                    BOOL didClickInsidePopoverView = NSPointInRect(eventPoint, self.popoverView.frame);
                    
                    if (didClickInsidePopoverView == NO) {
                        [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
                    } else {
                        DLog(@"Did click inside self.popoverView");
                    }
                }
            }
            
            return event;
        }];
    }
}

- (void)removeApplicationEventsMonitor {
    if (applicationEvent) {
        [NSEvent removeMonitor:applicationEvent];
        
        applicationEvent = nil;
    }
}

#pragma mark -
#pragma mark - Utilities
#pragma mark -
- (void)closePopover:(NSResponder *)sender {
    // code ...
}

- (void)closePopover:(NSResponder *)sender completion:(void (^)(void))complete {
    // code ...
}

- (void)appResignedActive:(NSNotification *)notification {
    if ([notification.name isEqualToString:NSApplicationDidResignActiveNotification]) {
        [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
    }
}

@end
