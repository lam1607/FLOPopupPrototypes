//
//  FLOWindowPopup.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOWindowPopup.h"

#import "FLOPopoverBackgroundView.h"

#import "FLOPopoverWindowController.h"

@interface FLOWindowPopup () <FLOPopoverBackgroundViewDelegate> {
    NSWindow *applicationWindow;
    NSEvent *applicationEvent;
}

@property (nonatomic, strong) NSWindow *popoverWindow;

@property (nonatomic, readonly, getter = isShown) BOOL shown;

@property (nonatomic, strong) NSView *contentView;
@property (nonatomic, strong) NSViewController *contentViewController;

@property (nonatomic, strong) FLOPopoverBackgroundView *backgroundView;
@property (nonatomic) NSRect positioningRect;
@property (nonatomic, strong) NSView *positioningView;
@property (nonatomic) NSRectEdge preferredEdge;
@property (nonatomic) CGSize contentSize;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic) CGSize originalViewSize;

@end

@implementation FLOWindowPopup

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
    [self.popoverWindow close];
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (BOOL)isShown {
    return self.popoverWindow.isVisible;
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

- (void)setTopMostWindowIfNecessary {
    NSWindow *topWindow = [[FLOPopoverWindow sharedInstance] topWindow];
    NSArray *windowStack = applicationWindow.childWindows;
    
    if ((topWindow != nil) && [windowStack containsObject:topWindow]) {
        [applicationWindow removeChildWindow:topWindow];
        [applicationWindow addChildWindow:topWindow ordered:NSWindowAbove];
    }
}

- (void)resetContentViewControllerRect:(NSNotification *)notification {
    self.contentViewController.view.frame = CGRectMake(self.contentViewController.view.frame.origin.x, self.contentViewController.view.frame.origin.y, self.originalViewSize.width, self.originalViewSize.height);
    
    if ([notification.name isEqualToString:NSWindowWillCloseNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:nil];
    }
}

#pragma mark -
#pragma mark - Display
#pragma mark -
- (void)showRelativeToRect:(NSRect)rect ofView:(NSView *)view edgeType:(FLOPopoverEdgeType)edgeType {
    if (self.shown) {
        [self close];
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
    [self.backgroundView setWindowDetachable:self.popoverShouldDetach];
    [self.backgroundView setBorderRadius:PopoverBackgroundViewBorderRadius];
    [self.backgroundView setShouldShowArrow:self.shouldShowArrow];
    
    if (self.popoverShouldDetach) {
        self.backgroundView.delegate = self;
    }
    
    [self.backgroundView setArrowColor:self.contentView.layer.backgroundColor];
    CGSize size = [self.backgroundView sizeForBackgroundViewWithContentSize:contentViewSize popoverEdge:popoverEdge];
    self.backgroundView.frame = (NSRect) { .size = size };
    self.backgroundView.popoverEdge = popoverEdge;
    
    NSRect contentViewFrame = [self.backgroundView contentViewFrameForBackgroundFrame:self.backgroundView.bounds popoverEdge:popoverEdge];
    self.contentView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    self.contentView.frame = contentViewFrame;
    [self.backgroundView addSubview:self.contentView positioned:NSWindowAbove relativeTo:nil];
    
    self.popoverWindow = [[NSWindow alloc] initWithContentRect:popoverScreenRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:YES];
    self.popoverWindow.hasShadow = YES;
    self.popoverWindow.releasedWhenClosed = NO;
    self.popoverWindow.opaque = NO;
    self.popoverWindow.backgroundColor = NSColor.clearColor;
    self.popoverWindow.contentView = self.backgroundView;
    
    [applicationWindow addChildWindow:self.popoverWindow ordered:NSWindowAbove];
    [self.popoverWindow makeKeyAndOrderFront:nil];
    
    if (popoverDidShow != nil) popoverDidShow(self);
    
    if (self.alwaysOnTop) {
        [[FLOPopoverWindow sharedInstance] setTopmostWindow:self.popoverWindow];
    }
    
    [self setTopMostWindowIfNecessary];
}

- (void)close {
    if (!self.shown) return;
    
    [self removeAllApplicationEvents];
    
    [applicationWindow removeChildWindow:self.popoverWindow];
    [self.popoverWindow close];
    
    if (popoverDidClose != nil) popoverDidClose(self);
    
    [self resetContentViewControllerRect:nil];
}

#pragma mark -
#pragma mark - Display utilities
#pragma mark -
- (NSRect)popoverRectForEdge:(NSRectEdge)popoverEdge {
    NSRect windowRelativeRect = [self.positioningView convertRect:[self.positioningView alignmentRectForFrame:self.positioningRect] toView:nil];
    NSRect positionOnScreenRect = [applicationWindow convertRectToScreen:windowRelativeRect];
    NSSize contentViewSize = NSEqualSizes(self.contentSize, NSZeroSize) ? self.contentView.frame.size : self.contentSize;
    NSPoint anchorPoint = self.anchorPoint;
    
    NSSize popoverSize = [self.backgroundView sizeForBackgroundViewWithContentSize:contentViewSize popoverEdge:popoverEdge];
    NSRect returnRect = NSMakeRect(0.0f, 0.0f, popoverSize.width, popoverSize.height);
    
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
    if (popoverEdge == NSRectEdgeMinY) {
        CGFloat x0 = NSMinX(positionOnScreenRect);
        CGFloat x1 = NSMaxX(positionOnScreenRect) - contentViewSize.width;
        
        returnRect.origin.x = x0 + floor((x1 - x0) * anchorPoint.x);
        returnRect.origin.y = NSMinY(positionOnScreenRect) - popoverSize.height;
    } else if (popoverEdge == NSRectEdgeMaxY) {
        CGFloat x0 = NSMinX(positionOnScreenRect);
        CGFloat x1 = NSMaxX(positionOnScreenRect) - contentViewSize.width;
        
        returnRect.origin.x = x0 + floor((x1 - x0) * anchorPoint.x);
        returnRect.origin.y = NSMaxY(positionOnScreenRect);
    } else if (popoverEdge == NSRectEdgeMinX) {
        CGFloat y0 = NSMinY(positionOnScreenRect);
        CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
        
        returnRect.origin.x = NSMinX(positionOnScreenRect) - popoverSize.width;
        returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
    } else if (popoverEdge == NSRectEdgeMaxX) {
        CGFloat y0 = NSMinY(positionOnScreenRect);
        CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
        
        returnRect.origin.x = NSMaxX(positionOnScreenRect);
        returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
    } else {
        returnRect = NSZeroRect;
    }
    
    return returnRect;
}

- (BOOL)checkPopoverSizeForScreenWithPopoverEdge:(NSRectEdge)popoverEdge {
    NSRect screenRect = applicationWindow.screen.visibleFrame;
    NSRect popoverRect = [self popoverRectForEdge:popoverEdge];
    
    return NSContainsRect(screenRect, popoverRect);
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
    NSRect screenRect = applicationWindow.screen.visibleFrame;
    
    if (proposedRect.origin.y < NSMinY(screenRect)) {
        proposedRect.origin.y = NSMinY(screenRect);
    }
    if (proposedRect.origin.x < NSMinX(screenRect)) {
        proposedRect.origin.x = NSMinX(screenRect);
    }
    
    if (NSMaxY(proposedRect) > NSMaxY(screenRect)) {
        proposedRect.origin.y = NSMaxY(screenRect) - NSHeight(proposedRect);
    }
    if (NSMaxX(proposedRect) > NSMaxX(screenRect)) {
        proposedRect.origin.x = NSMaxX(screenRect) - NSWidth(proposedRect);
    }
    
    return proposedRect;
}

- (BOOL)screenRectContainsRectEdge:(NSRectEdge)edge {
    NSRect proposedRect = [self popoverRectForEdge:edge];
    NSRect screenRect = applicationWindow.screen.visibleFrame;
    
    BOOL minYInBounds = (edge == NSRectEdgeMinY) && (NSMinY(proposedRect) >= NSMinY(screenRect));
    BOOL maxYInBounds = (edge == NSRectEdgeMaxY) && (NSMaxY(proposedRect) <= NSMaxY(screenRect));
    BOOL minXInBounds = (edge == NSRectEdgeMinX) && (NSMinX(proposedRect) >= NSMinX(screenRect));
    BOOL maxXInBounds = (edge == NSRectEdgeMaxX) && (NSMaxX(proposedRect) <= NSMaxX(screenRect));
    
    return minYInBounds || maxYInBounds || minXInBounds || maxXInBounds;
}

- (NSRect)popoverRect {
    NSRectEdge popoverEdge = self.preferredEdge;
    NSUInteger attemptCount = 0;
    
    while (![self checkPopoverSizeForScreenWithPopoverEdge:popoverEdge]) {
        if (attemptCount >= 4) {
            popoverEdge = [self screenRectContainsRectEdge:self.preferredEdge] ? self.preferredEdge : [self nextEdgeForEdge:self.preferredEdge];
            
            return [self fitRectToScreen:[self popoverRectForEdge:popoverEdge]];
            break;
        }
        
        popoverEdge = [self nextEdgeForEdge:popoverEdge];
        ++attemptCount;
    }
    
    return [self popoverRectForEdge:popoverEdge];
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
                if (self.popoverWindow != event.window) {
                    [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
                } else {
                    NSPoint eventPoint = [self.popoverWindow.contentView convertPoint:event.locationInWindow fromView:nil];
                    BOOL didClickInsidePopoverWindow = NSPointInRect(eventPoint, self.popoverWindow.contentView.bounds);
                    
                    if (didClickInsidePopoverWindow == NO) {
                        [self performSelector:@selector(close) withObject:nil afterDelay:0.1f];
                    } else {
                        DLog(@"Did click inside self.popoverWindow");
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

#pragma mark -
#pragma mark - FLOPopoverBackgroundViewDelegate
#pragma mark -
- (void)didDragViewToBecomeDetachableWindow:(NSWindow *)detachedWindow {
    if (detachedWindow == self.popoverWindow) {
        if ([applicationWindow.childWindows containsObject:detachedWindow]) {
            [applicationWindow removeChildWindow:self.popoverWindow];
            
            NSView *contentView = self.popoverWindow.contentView;
            NSRect windowRect = self.popoverWindow.frame;
            NSUInteger styleMask = NSWindowStyleMaskTitled + NSWindowStyleMaskClosable;
            
            NSWindow *temp = [[NSWindow alloc] initWithContentRect:windowRect styleMask:styleMask backing:NSBackingStoreBuffered defer:YES];
            NSRect detachableWindowRect = [temp frameRectForContentRect:windowRect];
            
            contentView.wantsLayer = YES;
            contentView.layer.cornerRadius = 0.0f;
            [self.popoverWindow setStyleMask:styleMask];
            [self.popoverWindow setFrame:detachableWindowRect display:YES];
            [self.popoverWindow makeKeyAndOrderFront:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetContentViewControllerRect:) name:NSWindowWillCloseNotification object:nil];
        }
    }
}

@end
