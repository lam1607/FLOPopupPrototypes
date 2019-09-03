//
//  WindowManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindowManager : NSObject

@property (nonatomic, assign, readonly) BOOL shouldChildWindowsFloat;

#pragma mark - Singleton

+ (WindowManager *)sharedInstance;

#pragma mark - Methods

- (void)setShouldChildWindowsFloat:(BOOL)shouldChildWindowsFloat;
- (NSWindowLevel)levelForTag:(WindowLevelGroupTag)tag;

@end
