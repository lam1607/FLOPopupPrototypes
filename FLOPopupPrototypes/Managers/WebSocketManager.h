//
//  WebSocketManager.h
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/4/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSocketManager : NSObject

@property (nonatomic, weak, readonly) WebServer *server;
@property (nonatomic, strong, readonly) NSString *serverPath;

#pragma mark - Singleton

+ (WebSocketManager *)sharedInstance;

#pragma mark - Methods

- (void)setupServerWithPort:(int)port;
- (void)connect;
- (void)close;

@end
