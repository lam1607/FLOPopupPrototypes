//
//  BaseWindowController.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BaseWindowController : NSWindowController

@property (nonatomic, assign, readonly) FLOWindowMode windowMode;
@property (nonatomic, assign, readonly) BOOL windowInDesktopMode;
@property (nonatomic, assign, readonly) NSRect windowNormalFrame;
@property (nonatomic, assign, readonly) CGFloat windowTitleBarHeight;

+ (BaseWindowController *)sharedInstance;

- (void)setWindowMode;
- (void)setWindowTitleBarHeight;

- (void)activate;
- (void)hideChildenWindowsOnDeactivate;
- (void)showChildenWindowsOnActivate;
- (void)hideOtherAppsExceptThoseInside;

@end
