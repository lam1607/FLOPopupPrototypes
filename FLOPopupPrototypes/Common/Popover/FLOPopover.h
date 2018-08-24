//
//  FLOPopover.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLOPopoverWindowController.h"

typedef NS_ENUM(NSInteger, FLOPopoverType) {
    FLOWindowPopover,
    FLOViewPopover
};

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
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL closesWhenPopoverResignsKey;
@property (nonatomic, assign) BOOL closesWhenApplicationBecomesInactive;

/* @Utilities
 */
- (IBAction)closePopover:(FLOPopover *)sender;
- (void)closePopover:(FLOPopover *)sender completion:(void(^)(void))complete;

/* @Display
 */
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge;

@end
