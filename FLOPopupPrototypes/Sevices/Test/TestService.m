//
//  TestService.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 8/30/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "TestService.h"

@implementation TestService

@synthesize isVerified = _isVerified;

#pragma mark - TestServiceProtocols implementation

- (void)verifyUpdateWithUrl:(NSURL *)url completion:(void(^)(BOOL granted))complete
{
    NSInteger random = arc4random_uniform(CHAR_MAX) + 1;
    
    BOOL isGranted = (random % 2) == 0;
    
    sleep(1.5);
    
    if (complete != nil)
    {
        complete(isGranted);
    }
}

@end
