//
//  FLOPopover.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLOPopoverConstants.h"

@protocol FLOPopoverDelegate <NSObject>

@optional
- (void)popoverDidShow:(NSResponder *)popover;
- (void)popoverDidClose:(NSResponder *)popover;

@end

@protocol FLOPopoverDelegate;

@interface FLOPopover : NSResponder

@property (weak, readwrite) id<FLOPopoverDelegate> delegate;

/* @Internal agruments
 */
@property (nonatomic, strong, readonly) NSView *contentView;
@property (nonatomic, strong, readonly) NSViewController *contentViewController;
@property (nonatomic, assign, readonly) FLOPopoverType popupType;

/* @Inits
 */
- (id)initWithContentView:(NSView *)contentView;
- (id)initWithContentView:(NSView *)contentView popoverType:(FLOPopoverType)popoverType;
- (id)initWithContentViewController:(NSViewController *)contentViewController;
- (id)initWithContentViewController:(NSViewController *)contentViewController popoverType:(FLOPopoverType)popoverType;

/* @Properties
 */
@property (nonatomic, assign) BOOL alwaysOnTop;
@property (nonatomic, assign) BOOL shouldShowArrow;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL closesWhenPopoverResignsKey;
@property (nonatomic, assign) BOOL closesWhenApplicationBecomesInactive;

/**
 * Make the popover movable.
 */
@property (nonatomic, assign) BOOL popoverMovable;

/**
 * Make the popover detach from its parent window. Only apply for FLOWindowPopover type.
 */
@property (nonatomic, assign) BOOL popoverShouldDetach;

/* @Utilities
 */
- (IBAction)closePopover:(FLOPopover *)sender;
- (void)closePopover:(FLOPopover *)sender completion:(void(^)(void))complete;

/* @Display
 */
- (void)setAnimationBehaviour:(FLOPopoverAnimationBehaviour)animationBehaviour type:(FLOPopoverAnimationTransition)animationType;
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView edgeType:(FLOPopoverEdgeType)edgeType;

@end
