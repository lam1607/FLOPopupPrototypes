//
//  FLOViewPopup.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLOPopoverConstants.h"

#import "FLOPopoverService.h"

@interface FLOViewPopup : NSResponder <FLOPopoverService>

@property (nonatomic, readonly, getter = isShown) BOOL shown;

@property (nonatomic, assign) BOOL alwaysOnTop;
@property (nonatomic, assign) BOOL shouldShowArrow;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL closesWhenPopoverResignsKey;
@property (nonatomic, assign) BOOL closesWhenApplicationBecomesInactive;

// Make the popover movable.
//
@property (nonatomic, assign) BOOL popoverMovable;

/* @Display
 */
- (void)setAnimationBehaviour:(FLOPopoverAnimationBehaviour)animationBehaviour type:(FLOPopoverAnimationTransition)animationType;
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView edgeType:(FLOPopoverEdgeType)edgeType;

@end
