//
//  FLOPopoverConstants.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/31/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#ifndef FLOPopoverConstants_h
#define FLOPopoverConstants_h

static CGFloat const FLOPopoverAnimationTimeIntervalStandard = 0.2f;

typedef NS_ENUM(NSInteger, FLOPopoverType) {
    FLOWindowPopover,
    FLOViewPopover
};

typedef NS_ENUM(NSInteger, FLOPopoverEdgeType) {
    FLOPopoverEdgeTypeHorizontalAboveLeftEdge,
    FLOPopoverEdgeTypeHorizontalAboveRightEdge,
    FLOPopoverEdgeTypeHorizontalBelowLeftEdge,
    FLOPopoverEdgeTypeHorizontalBelowRightEdge,
    FLOPopoverEdgeTypeVerticalBackwardBottomEdge,
    FLOPopoverEdgeTypeVerticalBackwardTopEdge,
    FLOPopoverEdgeTypeVerticalForwardBottomEdge,
    FLOPopoverEdgeTypeVerticalForwardTopEdge,
    FLOPopoverEdgeTypeHorizontalBelowCenter
};

typedef NS_ENUM(NSInteger, FLOPopoverAppearance) {
    /*
     - popover will display with the utility animation (if animations anable)
     - arrow point to the preferred Edge (if required)
     */
    FLOPopoverAppearanceUtility = 0,
    
    /*
     - popover will display with the custom animation (if animations anable)
     - arrow point to the preferred Edge (if required)
     */
    FLOPopoverAppearanceUserDefined
};

typedef NS_ENUM(NSInteger, FLOPopoverAnimationBehaviour) {
    /*
     - popover will display with the utility effect
     */
    FLOPopoverAnimationBehaviorNone = 0,
    
    /*
     - popover will display with the transform effect (scale, rotate, ...)
     */
    FLOPopoverAnimationBehaviorTransform,
    
    /*
     - popover will display with the the following requires:
     + shift from left to right before displaying
     + shift from right to right before displaying
     + shift from top to bottom before displaying
     + shift from bottom to top before displaying
     */
    FLOPopoverAnimationBehaviorTransition
};


typedef NS_ENUM(NSInteger, FLOPopoverAnimationTransition) {
    FLOPopoverAnimationLeftToRight = 0,
    FLOPopoverAnimationRightToLeft,
    FLOPopoverAnimationTopToBottom,
    FLOPopoverAnimationBottomToTop,
    FLOPopoverAnimationFromMiddle
};

#endif /* FLOPopoverConstants_h */
