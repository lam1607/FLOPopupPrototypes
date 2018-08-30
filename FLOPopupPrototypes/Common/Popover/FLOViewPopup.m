//
//  FLOViewPopup.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOViewPopup.h"

#import "FLOPopoverBackgroundView.h"

@interface FLOViewPopup () {
    NSWindow *applicationWindow;
    NSEvent *applicationEvent;
}

@property (nonatomic, strong) NSView *popoverView;

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

@implementation FLOViewPopup

@synthesize popoverDidShow;
@synthesize popoverDidClose;

- (instancetype)initWithContentView:(NSView *)contentView {
    if (self = [super init]) {
        applicationWindow = [[NSWindow alloc] init];
        _contentView = contentView;
        _backgroundView = [[FLOPopoverBackgroundView alloc] initWithFrame:contentView.frame];
        _anchorPoint = CGPointMake(1.0f, 1.0f);
        _shouldShowArrow = NO;
        _animated = NO;
        _closesWhenPopoverResignsKey = NO;
        _closesWhenApplicationBecomesInactive = NO;
    }
    
    return self;
}

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController {
    if (self = [super init]) {
        applicationWindow = [[NSWindow alloc] init];
        _contentViewController = contentViewController;
        _contentView = contentViewController.view;
        _backgroundView = [[FLOPopoverBackgroundView alloc] initWithFrame:contentViewController.view.frame];
        _anchorPoint = CGPointMake(1.0f, 1.0f);
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
    }
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (BOOL)isShown {
    return self.popoverView != nil;
}

- (void)setApplicationWindow:(NSWindow *)window {
    applicationWindow = window;
}

#pragma mark -
#pragma mark - Display
#pragma mark -
- (void)showRelativeToRect:(NSRect)rect ofView:(NSView *)view preferredEdge:(NSRectEdge)edge {
    if (self.shown) {
        [self close];
        return;
    }
    
    self.positioningRect = rect;
    self.positioningView = view;
    self.preferredEdge = edge;
    
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
    
    NSRect applicationScreenRect = [applicationWindow convertRectToScreen:applicationWindow.contentView.bounds];
    
    NSRect windowRelativeRect = [self.positioningView convertRect:[self.positioningView alignmentRectForFrame:self.positioningRect] toView:nil];
    NSRect positionOnScreenRect = [applicationWindow convertRectToScreen:windowRelativeRect];
    
    self.backgroundView.popoverOrigin = positionOnScreenRect;
    
    self.originalViewSize = self.contentView.frame.size;
    NSSize contentViewSize = NSEqualSizes(self.contentSize, NSZeroSize) ? self.contentView.frame.size : self.contentSize;
    
    NSRect (^popoverRectForEdge)(NSRectEdge *);
    __block __weak NSRect (^wPopoverRectForEdge)(NSRectEdge *);
    CGPoint anchorPoint = self.anchorPoint;
    wPopoverRectForEdge = popoverRectForEdge = [^(NSRectEdge *popoverEdge) {
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
                return wPopoverRectForEdge(popoverEdge);
            }
        } else if (*popoverEdge == NSRectEdgeMaxY) {
            CGFloat x0 = NSMinX(positionOnScreenRect);
            CGFloat x1 = NSMaxX(positionOnScreenRect) - contentViewSize.width;
            returnRect.origin.x = x0 + floor((x1 - x0) * anchorPoint.x);
            returnRect.origin.y = NSMaxY(positionOnScreenRect);
            
            if ((returnRect.origin.y + popoverSize.height) > NSMaxY(applicationScreenRect)) {
                *popoverEdge = NSRectEdgeMinY;
                return wPopoverRectForEdge(popoverEdge);
            }
        } else if (*popoverEdge == NSRectEdgeMinX) {
            CGFloat y0 = NSMinY(positionOnScreenRect);
            CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
            returnRect.origin.x = NSMinX(positionOnScreenRect) - popoverSize.width;
            returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
            
            if (returnRect.origin.x < NSMinX(applicationScreenRect)) {
                *popoverEdge = NSRectEdgeMaxX;
                return wPopoverRectForEdge(popoverEdge);
            }
        } else if (*popoverEdge == NSRectEdgeMaxX) {
            CGFloat y0 = NSMinY(positionOnScreenRect);
            CGFloat y1 = NSMaxY(positionOnScreenRect) - contentViewSize.height;
            returnRect.origin.x = NSMaxX(positionOnScreenRect);
            returnRect.origin.y = y0 + floor((y1 - y0) * anchorPoint.y);
            
            if ((returnRect.origin.x + popoverSize.width) > NSMaxX(applicationScreenRect)) {
                *popoverEdge = NSRectEdgeMinX;
                return wPopoverRectForEdge(popoverEdge);
            }
        } else {
            returnRect = NSZeroRect;
        }
        
        return returnRect;
    } copy];
    
    BOOL (^checkPopoverSizeForScreenWithPopoverEdge)(NSRectEdge *) = ^(NSRectEdge *popoverEdge) {
        NSRect popoverRect = popoverRectForEdge(popoverEdge);
        return NSContainsRect(applicationScreenRect, popoverRect);
    };
    
    //This is as ugly as sin… but it gets the job done. I couldn't think of a nice way to code this but still get the desired behavior
    __block NSRectEdge popoverEdge = self.preferredEdge;
    NSRect (^popoverRect)(void) = ^{
        NSRectEdge (^nextEdgeForEdge)(NSRectEdge) = ^NSRectEdge (NSRectEdge currentEdge) {
            if (currentEdge == NSRectEdgeMaxX) {
                return (self.preferredEdge == NSRectEdgeMinX ? NSRectEdgeMaxY : NSRectEdgeMinX);
            } else if (currentEdge == NSRectEdgeMinX) {
                return (self.preferredEdge == NSRectEdgeMaxX ? NSRectEdgeMaxY : NSRectEdgeMaxX);
            } else if (currentEdge == NSRectEdgeMaxY) {
                return (self.preferredEdge == NSRectEdgeMinY ? NSRectEdgeMaxX : NSRectEdgeMinY);
            } else if (currentEdge == NSRectEdgeMinY) {
                return (self.preferredEdge == NSRectEdgeMaxY ? NSRectEdgeMaxX : NSRectEdgeMaxY);
            }
            
            return currentEdge;
        };
        
        NSRect (^fitRectToScreen)(NSRect) = ^NSRect (NSRect proposedRect) {
            NSRect screenRect = applicationScreenRect;
            
            if (proposedRect.origin.y < NSMinY(screenRect)) {
                proposedRect.origin.y = NSMinY(screenRect);
            }
            if (proposedRect.origin.x < NSMinX(screenRect)) {
                proposedRect.origin.x = NSMinX(screenRect);
            }
            
            if (NSMaxY(proposedRect) > NSMaxY(screenRect)) {
                proposedRect.origin.y = (NSMaxY(screenRect) - NSHeight(proposedRect));
            }
            if (NSMaxX(proposedRect) > NSMaxX(screenRect)) {
                proposedRect.origin.x = (NSMaxX(screenRect) - NSWidth(proposedRect));
            }
            
            return proposedRect;
        };
        
        BOOL (^screenRectContainsRectEdge)(NSRectEdge) = ^ BOOL (NSRectEdge edge) {
            NSRect proposedRect = popoverRectForEdge(&edge);
            NSRect screenRect = applicationScreenRect;
            
            BOOL minYInBounds = (edge == NSRectEdgeMinY && NSMinY(proposedRect) >= NSMinY(screenRect));
            BOOL maxYInBounds = (edge == NSRectEdgeMaxY && NSMaxY(proposedRect) <= NSMaxY(screenRect));
            BOOL minXInBounds = (edge == NSRectEdgeMinX && NSMinX(proposedRect) >= NSMinX(screenRect));
            BOOL maxXInBounds = (edge == NSRectEdgeMaxX && NSMaxX(proposedRect) <= NSMaxX(screenRect));
            
            return minYInBounds || maxYInBounds || minXInBounds || maxXInBounds;
        };
        
        NSUInteger attemptCount = 0;
        while (!checkPopoverSizeForScreenWithPopoverEdge(&popoverEdge)) {
            if (attemptCount >= 4) {
                popoverEdge = (screenRectContainsRectEdge(self.preferredEdge) ? self.preferredEdge : nextEdgeForEdge(self.preferredEdge));
                
                return fitRectToScreen(popoverRectForEdge(&popoverEdge));
                break;
            }
            
            popoverEdge = nextEdgeForEdge(popoverEdge);
            ++attemptCount;
        }
        
        return popoverRectForEdge(&popoverEdge);
    };
    
    NSRect popoverScreenRect = popoverRect();
    
    [self.backgroundView setViewMovable:self.popoverMovable];
    [self.backgroundView setBorderRadius:PopoverBackgroundViewBorderRadius];
    [self.backgroundView setShouldShowArrow:self.shouldShowArrow];
    
    [self.backgroundView setArrowColor:self.contentView.layer.backgroundColor];
    CGSize size = [self.backgroundView sizeForBackgroundViewWithContentSize:contentViewSize popoverEdge:popoverEdge];
    self.backgroundView.frame = (NSRect){ .size = size };
    self.backgroundView.popoverEdge = popoverEdge;
    
    NSRect contentViewFrame = [self.backgroundView contentViewFrameForBackgroundFrame:self.backgroundView.bounds popoverEdge:popoverEdge];
    self.contentView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    self.contentView.frame = contentViewFrame;
    [self.backgroundView addSubview:self.contentView positioned:NSWindowAbove relativeTo:nil];
    
    self.popoverView = self.backgroundView;
    
    [self.backgroundView setShouldShowShadow:YES];
    [self.backgroundView setFrame:[applicationWindow convertRectFromScreen:popoverScreenRect]];
    [applicationWindow.contentView addSubview:self.backgroundView positioned:NSWindowAbove relativeTo:self.positioningView];
    
    if (popoverDidShow != nil) popoverDidShow(self);
}

- (void)close {
    if (!self.shown) return;
    
    if ([self.popoverView isDescendantOf:applicationWindow.contentView]) {
        [self removeApplicationEventsMonitor];
        
        [self.popoverView removeFromSuperview];
        self.popoverView = nil;
        
        if (popoverDidClose != nil) popoverDidClose(self);
        
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.originalViewSize.width, self.originalViewSize.height);
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
