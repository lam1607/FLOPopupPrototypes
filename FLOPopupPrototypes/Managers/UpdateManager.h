//
//  UpdateManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UpdateManager : NSObject

#pragma mark - Singleton

+ (UpdateManager *)sharedInstance;

#pragma mark - Methods

- (IBAction)checkForUpdates:(id)sender;
- (void)setAutomaticallyChecksForUpdates:(BOOL)automaticallyChecksForUpdates;
- (void)setUpdateCheckInterval:(NSTimeInterval)updateCheckInterval;

@end
