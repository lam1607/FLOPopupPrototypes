//
//  FLOPopoverBackgroundView.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "FLOPopoverBackgroundView.h"

static CGFloat getMedianXFromRects(CGRect r1, CGRect r2) {
    CGFloat minX = fmax(NSMinX(r1), NSMinX(r2));
    CGFloat maxX = fmin(NSMaxX(r1), NSMaxX(r2));
    
    return (minX + maxX) / 2;
}

// Returns the median X value of the shared segment of the X edges of the given rects
static CGFloat getMedianYFromRects(CGRect r1, CGRect r2) {
    CGFloat minY = fmax(NSMinY(r1), NSMinY(r2));
    CGFloat maxY = fmin(NSMaxY(r1), NSMaxY(r2));
    
    return (minY + maxY) / 2;
}

#pragma mark -
#pragma mark - FLOPopoverClippingView
#pragma mark -
@implementation FLOPopoverClippingView
- (void)dealloc {
    self.clippingPath = NULL;
}

- (NSView *)hitTest:(NSPoint)aPoint {
    return nil;
}

- (void)setClippingPath:(CGPathRef)clippingPath {
    if (clippingPath == _clippingPath) return;
    
    CGPathRelease(_clippingPath);
    _clippingPath = clippingPath;
    CGPathRetain(_clippingPath);
    
    self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.clippingPath == NULL) return;
    
    [self setupArrowPath];
}

- (void)setupArrowPath {
    CGContextRef currentContext = NSGraphicsContext.currentContext.graphicsPort;
    
    if (currentContext != nil) {
        self.pathColor = (self.pathColor != nil) ? self.pathColor : [NSColor.brownColor CGColor];
        
        //        NSSize myShadowOffset = NSMakeSize(-0.1, 0.1);
        //        CGContextSetShadow(currentContext, myShadowOffset, 5);
        
        //        CGContextAddRect(currentContext, self.bounds);
        CGContextAddPath(currentContext, self.clippingPath);
        CGContextSetBlendMode(currentContext, kCGBlendModeCopy);
        CGContextSetFillColorWithColor(currentContext, self.pathColor);
        //        CGContextFillPath(currentContext);
        CGContextEOFillPath(currentContext);
    }
}

- (void)setupArrowPathColor:(CGColorRef)color {
    if (color != nil) {
        self.pathColor = color;
        self.needsDisplay = YES;
    }
}

@end

#pragma mark -
#pragma mark - FLOPopoverBackgroundView
#pragma mark -
@interface FLOPopoverBackgroundView ()

// The clipping view that's used to shape the popover to the correct path. This
// property is prefixed because it's private and this class is meant to be
// subclassed.
@property (nonatomic, strong, readonly) FLOPopoverClippingView *clippingView;
@property (nonatomic, assign, readwrite) NSRectEdge popoverEdge;
@property (nonatomic, assign, readwrite) NSRect popoverOrigin;

- (NSRectEdge)arrowEdgeForPopoverEdge:(NSRectEdge)popoverEdge;

@end

@implementation FLOPopoverBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    _arrowSize = NSZeroSize;
    _fillColor = NSColor.clearColor;
    
    _clippingView = [[FLOPopoverClippingView alloc] initWithFrame:self.bounds];
    self.clippingView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:self.clippingView];
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    [self.fillColor set];
    NSRectFill(rect);
}

- (void)viewWillDraw {
    [super viewWillDraw];
    [self updateClippingView];
}

#pragma mark -
#pragma mark - Others
#pragma mark -
- (NSRectEdge)arrowEdgeForPopoverEdge:(NSRectEdge)popoverEdge {
    NSRectEdge arrowEdge = NSRectEdgeMinY;
    switch (popoverEdge) {
        case NSRectEdgeMaxX:
            arrowEdge = NSRectEdgeMinX;
            break;
        case NSRectEdgeMaxY:
            arrowEdge = NSRectEdgeMinY;
            break;
        case NSRectEdgeMinX:
            arrowEdge = NSRectEdgeMaxX;
            break;
        case NSRectEdgeMinY:
            arrowEdge = NSRectEdgeMaxY;
            break;
        default:
            break;
    }
    
    return arrowEdge;
}

- (void)updateClippingView {
    // There's no point if it's not in a window
//    if (self.window == nil) return;
    
    if (NSEqualSizes(self.arrowSize, NSZeroSize) == NO) {
        CGPathRef clippingPath = [self newPopoverPathForEdge:self.popoverEdge inFrame:self.clippingView.bounds];
        self.clippingView.clippingPath = clippingPath;
        CGPathRelease(clippingPath);
    }
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (void)setBackgroundColor:(NSColor *)color {
    self.fillColor = color;
    [self.fillColor set];
}

- (void)setNeedShadow:(BOOL)needed {
    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor:[NSColor lightGrayColor]];
    [dropShadow setShadowOffset:NSMakeSize(-0.5f, 0.5f)];
    [dropShadow setShadowBlurRadius:5.0f];
    
    [self setWantsLayer:YES];
    [self setShadow:dropShadow];
}

- (void)setNeedArrow:(BOOL)needed {
    self.arrowSize = needed ? CGSizeMake(PopoverBackgroundViewArrowWidth, PopoverBackgroundViewArrowHeight) : NSZeroSize;
    
    if (NSEqualSizes(self.arrowSize, NSZeroSize) == NO) {
        [self updateClippingView];
    }
}

- (void)setArrowColor:(CGColorRef)color {
    if (NSEqualSizes(self.arrowSize, NSZeroSize) == NO) {
        [self.clippingView setupArrowPathColor:color];
    }
}

- (BOOL)isOpaque {
    return NO;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    self.needsDisplay = YES;
}

- (void)setArrowSize:(CGSize)arrowSize {
    if (CGSizeEqualToSize(arrowSize, self.arrowSize)) return;
    
    _arrowSize = arrowSize;
    self.needsDisplay = YES;
}

- (void)setPopoverEdge:(NSRectEdge)popoverEdge {
    if (popoverEdge == self.popoverEdge) return;
    
    _popoverEdge = popoverEdge;
    self.needsDisplay = YES;
}

- (void)setPopoverOrigin:(NSRect)popoverOrigin {
    if (NSEqualRects(popoverOrigin, self.popoverOrigin)) return;
    
    _popoverOrigin = popoverOrigin;
    self.needsDisplay = YES;
}

- (NSSize)sizeForBackgroundViewWithContentSize:(NSSize)contentSize popoverEdge:(NSRectEdge)popoverEdge {
    CGSize returnSize = contentSize;
    //    if (popoverEdge == NSRectEdgeMaxX || popoverEdge == NSRectEdgeMinX) {
    //        returnSize.width += self.arrowSize.height;
    //    } else {
    //        returnSize.height += self.arrowSize.height;
    //    }
    //
    //    returnSize.width += 2.0;
    //    returnSize.height += 2.0;
    
    return returnSize;
}

- (NSRect)contentViewFrameForBackgroundFrame:(NSRect)backgroundFrame popoverEdge:(NSRectEdge)popoverEdge {
    NSRect returnFrame = NSInsetRect(backgroundFrame, 1.0, 1.0);
    
    switch (popoverEdge) {
        case NSRectEdgeMinX:
            returnFrame.size.width -= self.arrowSize.height;
            break;
        case NSRectEdgeMinY:
            returnFrame.size.height -= self.arrowSize.height;
            break;
        case NSRectEdgeMaxX:
            returnFrame.size.width -= self.arrowSize.height;
            returnFrame.origin.x += self.arrowSize.height;
            break;
        case NSRectEdgeMaxY:
            returnFrame.size.height -= self.arrowSize.height;
            returnFrame.origin.y += self.arrowSize.height;
            break;
        default:
            NSAssert(NO, @"Failed to pass in a valid NSRectEdge");
            break;
    }
    
    return returnFrame;
}

- (CGPathRef)newPopoverPathForEdge:(NSRectEdge)popoverEdge inFrame:(CGRect)frame {
    NSRectEdge arrowEdge = [self arrowEdgeForPopoverEdge:popoverEdge];
    
    CGRect contentRect = CGRectIntegral([self contentViewFrameForBackgroundFrame:frame popoverEdge:self.popoverEdge]);
    CGFloat minX = NSMinX(contentRect);
    CGFloat maxX = NSMaxX(contentRect);
    CGFloat minY = NSMinY(contentRect);
    CGFloat maxY = NSMaxY(contentRect);
    
    NSWindow *window = (self.window != nil) ? self.window : [NSApp mainWindow];
    CGRect windowRect = [window convertRectFromScreen:self.popoverOrigin];
    CGRect originRect = [self convertRect:windowRect fromView:nil];
    CGFloat midOriginX = floor(getMedianXFromRects(originRect, contentRect));
    CGFloat midOriginY = floor(getMedianYFromRects(originRect, contentRect));
    
    CGFloat maxArrowX = 0.0;
    CGFloat minArrowX = 0.0;
    CGFloat minArrowY = 0.0;
    CGFloat maxArrowY = 0.0;
    
    // Even I have no idea at this point… :trollface:
    // So we don't have a weird arrow situation we need to make sure we draw it within the radius.
    // If we have to nudge it then we have to shrink the arrow as otherwise it looks all wonky and weird.
    // That is what this complete mess below does.
    if (arrowEdge == NSRectEdgeMinY || arrowEdge == NSRectEdgeMaxY) {
        maxArrowX = floor(midOriginX + (self.arrowSize.width / 2.0));
        CGFloat maxPossible = (NSMaxX(contentRect) - PopoverBackgroundViewBorderRadius);
        
        if (maxArrowX > maxPossible) {
            maxArrowX = maxPossible;
            minArrowX = maxArrowX - self.arrowSize.width;
        } else {
            minArrowX = floor(midOriginX - (self.arrowSize.width / 2.0));
            
            if (minArrowX < PopoverBackgroundViewBorderRadius) {
                minArrowX = PopoverBackgroundViewBorderRadius;
                maxArrowX = minArrowX + self.arrowSize.width;
            }
        }
    } else {
        minArrowY = floor(midOriginY - (self.arrowSize.width / 2.0));
        
        if (minArrowY < PopoverBackgroundViewBorderRadius) {
            minArrowY = PopoverBackgroundViewBorderRadius;
            maxArrowY = minArrowY + self.arrowSize.width;
        } else {
            maxArrowY = floor(midOriginY + (self.arrowSize.width / 2.0));
            CGFloat maxPossible = (NSMaxY(contentRect) - PopoverBackgroundViewBorderRadius);
            
            if (maxArrowY > maxPossible) {
                maxArrowY = maxPossible;
                minArrowY = maxArrowY - self.arrowSize.width;
            }
        }
    }
    
    // These represent the centerpoints of the popover's corner arcs.
    CGFloat minCenterpointX = floor(minX + PopoverBackgroundViewBorderRadius);
    CGFloat maxCenterpointX = floor(maxX - PopoverBackgroundViewBorderRadius);
    CGFloat minCenterpointY = floor(minY + PopoverBackgroundViewBorderRadius);
    CGFloat maxCenterpointY = floor(maxY - PopoverBackgroundViewBorderRadius);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, minCenterpointY);
    
    CGFloat radius = PopoverBackgroundViewBorderRadius;
    
    CGPathAddArc(path, NULL, minCenterpointX, maxCenterpointY, radius, M_PI, M_PI_2, true);
    CGPathAddArc(path, NULL, maxCenterpointX, maxCenterpointY, radius, M_PI_2, 0, true);
    CGPathAddArc(path, NULL, maxCenterpointX, minCenterpointY, radius, 0, -M_PI_2, true);
    CGPathAddArc(path, NULL, minCenterpointX, minCenterpointY, radius, -M_PI_2, M_PI, true);
    
    CGPoint minBasePoint, tipPoint, maxBasePoint;
    switch (arrowEdge) {
        case NSRectEdgeMinX:
            minBasePoint = CGPointMake(minX, minArrowY);
            tipPoint = CGPointMake(floor(minX - self.arrowSize.height), floor((minArrowY + maxArrowY) / 2));
            maxBasePoint = CGPointMake(minX, maxArrowY);
            break;
        case NSRectEdgeMaxY:
            minBasePoint = CGPointMake(minArrowX, maxY);
            tipPoint = CGPointMake(floor((minArrowX + maxArrowX) / 2), floor(maxY + self.arrowSize.height));
            maxBasePoint = CGPointMake(maxArrowX, maxY);
            break;
        case NSRectEdgeMaxX:
            minBasePoint = CGPointMake(maxX, minArrowY);
            tipPoint = CGPointMake(floor(maxX + self.arrowSize.height), floor((minArrowY + maxArrowY) / 2));
            maxBasePoint = CGPointMake(maxX, maxArrowY);
            break;
        case NSRectEdgeMinY:
            minBasePoint = CGPointMake(minArrowX, minY);
            tipPoint = CGPointMake(floor((minArrowX + maxArrowX) / 2), floor(minY - self.arrowSize.height));
            maxBasePoint = CGPointMake(maxArrowX, minY);
            break;
        default:
            break;
    }
    
    CGPathMoveToPoint(path, NULL, minBasePoint.x, minBasePoint.y);
    CGPathAddLineToPoint(path, NULL, tipPoint.x, tipPoint.y);
    CGPathAddLineToPoint(path, NULL, maxBasePoint.x, maxBasePoint.y);
    
    return path;
}

@end
