//
//  FLOPopoverService.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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


typedef NS_ENUM(NSInteger, FLOPopoverAnimationMovable) {
    FLOPopoverAnimationLeftToRight = 0,
    FLOPopoverAnimationRightToLeft,
    FLOPopoverAnimationTopToBottom,
    FLOPopoverAnimationBottomToTop,
    FLOPopoverAnimationFromMiddle
};

@protocol FLOPopoverService <NSObject>

@property (nonatomic, copy) void (^popoverDidClose)(NSResponder *popover);
@property (nonatomic, copy) void (^popoverDidShow)(NSResponder *popover);

@optional
/*
 * @Inits
 */
- (id)initWithContentView:(NSView *)contentView;
- (id)initWithContentViewController:(NSViewController *)contentViewController;

/*
 * @Display
 */

@required
- (IBAction)closePopover:(NSResponder *)sender;
- (void)closePopover:(NSResponder *)sender completion:(void(^)(void))complete;

@end
