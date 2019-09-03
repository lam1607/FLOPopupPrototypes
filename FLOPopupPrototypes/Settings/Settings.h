//
//  Settings.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

#pragma mark - Singleton

+ (Settings *)sharedInstance;

#pragma mark - Methods

- (BOOL)isNormalMode;
- (BOOL)isDesktopMode;
- (FLOWindowMode)nextMode;
- (void)changeMode:(FLOWindowMode)mode;

@end
