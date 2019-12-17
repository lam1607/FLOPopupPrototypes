//
//  SettingsManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 12/16/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApplicationMode)
{
    ApplicationModeNormal,
    ApplicationModeDesktop
};

@interface SettingsManager : NSObject

@property (nonatomic, assign, readonly) ApplicationMode appMode;

#pragma mark - Singleton

+ (SettingsManager *)sharedInstance;

#pragma mark - Methods

- (BOOL)isNormalMode;
- (BOOL)isDesktopMode;
- (void)changeApplicationMode;

@end
