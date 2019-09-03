//
//  WindowManager.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "WindowManager.h"

@interface WindowManager ()
{
    BOOL _shouldChildWindowsFloat;
}

@end

@implementation WindowManager

#pragma mark - Singleton

+ (WindowManager *)sharedInstance
{
    static WindowManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WindowManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
    }
    
    return self;
}

#pragma mark - Getter/Setter

- (void)setShouldChildWindowsFloat:(BOOL)shouldChildWindowsFloat
{
    _shouldChildWindowsFloat = shouldChildWindowsFloat;
}

- (BOOL)shouldChildWindowsFloat
{
    return _shouldChildWindowsFloat;
}

#pragma mark - Local methods

- (CGWindowLevel)windowLevelDesktop
{
    return ((CGWindowLevel)WindowLevelGroupTagDesktop);
}

- (CGWindowLevel)windowLevelNormal
{
    return ((CGWindowLevel)WindowLevelGroupTagNormal);
}

- (CGWindowLevel)windowLevelFloat
{
    return ((CGWindowLevel)WindowLevelGroupTagFloat);
}

- (CGWindowLevel)windowLevelSetting
{
    return ((CGWindowLevel)WindowLevelGroupTagSetting);
}

- (CGWindowLevel)windowLevelAlert
{
    return ((CGWindowLevel)WindowLevelGroupTagAlert);
}

- (CGWindowLevel)windowLevelTop
{
    return ((CGWindowLevel)WindowLevelGroupTagTop);
}

#pragma mark - WindowManager methods

- (NSWindowLevel)levelForTag:(WindowLevelGroupTag)tag
{
    NSWindowLevel level = NSNormalWindowLevel;
    
    switch (tag)
    {
        case WindowLevelGroupTagDesktop:
            level = [self windowLevelDesktop];
            break;
        case WindowLevelGroupTagNormal:
            level = [self windowLevelNormal];
            break;
        case WindowLevelGroupTagFloat:
            level = [self windowLevelFloat];
            break;
        case WindowLevelGroupTagSetting:
            level = [self windowLevelSetting];
            break;
        case WindowLevelGroupTagAlert:
            level = [self windowLevelAlert];
            break;
        case WindowLevelGroupTagTop:
            level = [self windowLevelTop];
            break;
        default:
            break;
    }
    
    return level;
}

@end
