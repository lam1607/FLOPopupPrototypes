//
//  Settings.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "Settings.h"

@interface Settings ()
{
    FLOWindowMode _mode;
}

@end

@implementation Settings

#pragma mark - Singleton

+ (Settings *)sharedInstance
{
    static Settings *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Settings alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
        _mode = FLOWindowModeNormal;
    }
    
    return self;
}

#pragma mark - Local methods

#pragma mark - Settings methods

- (BOOL)isNormalMode
{
    return (_mode == FLOWindowModeNormal);
}

- (BOOL)isDesktopMode
{
    return (_mode == FLOWindowModeDesktop);
}

- (FLOWindowMode)nextMode
{
    return [self isNormalMode] ? FLOWindowModeDesktop : FLOWindowModeNormal;
}

- (void)changeMode:(FLOWindowMode)mode
{
    if (mode != _mode)
    {
        FLOWindowMode old = _mode;
        
        _mode = mode;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFlowarePopover_WindowDidChangeModeNotification object:nil userInfo:@{@"original": @(old), @"object": @(mode)}];
    }
}

@end
