//
//  WebServer.h
//  WebSocket
//
//  Created by Hung Truong on 8/30/19.
//  Copyright © 2019 hungtq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebServer : NSObject

- (instancetype)initWithPort:(int)port workingDirectory:(NSString *)workingDirectory;
- (void)close;

@end

NS_ASSUME_NONNULL_END
