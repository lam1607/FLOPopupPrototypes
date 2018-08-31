//
//  FLOPopoverConstants.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/31/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#ifndef FLOPopoverConstants_h
#define FLOPopoverConstants_h

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

#endif /* FLOPopoverConstants_h */
