//
//  FLOWindowPopup.h
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLOPopoverService.h"

@interface FLOWindowPopup : NSResponder <FLOPopoverService>

@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL closesWhenPopoverResignsKey;
@property (nonatomic, assign) BOOL closesWhenApplicationBecomesInactive;

- (void)setApplicationWindow:(NSWindow *)window;
/* @Display
 */
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge;

@end
