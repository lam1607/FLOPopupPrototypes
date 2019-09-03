//
//  TestServiceProtocols.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 8/30/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#ifndef TestServiceProtocols_h
#define TestServiceProtocols_h

#import "AbstractServiceProtocols.h"

@protocol TestServiceProtocols <AbstractServiceProtocols>

@optional

@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, assign) BOOL verifyNeeded;

- (void)verifyUpdateWithUrl:(NSURL *)url completion:(void(^)(BOOL granted))complete;

@end

#endif /* TestServiceProtocols_h */
