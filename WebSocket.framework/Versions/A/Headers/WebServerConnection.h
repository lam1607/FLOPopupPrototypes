//
//  WebServerConnection.h
//  WebSocket
//
//  Created by Hung Truong on 8/30/19.
//  Copyright © 2019 hungtq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

@class WebServerConnection;

@protocol WebServerConnectionDelegate <NSObject>
@required
- (void)connectionDidClose:(WebServerConnection *)sender;
@end

@interface WebServerConnection : NSObject <NSStreamDelegate>

- (instancetype)initWithNativeHandle:(CFSocketNativeHandle)handle workingDirectory:(NSString*)workingDirectory delegate:(id<WebServerConnectionDelegate>)delegate;
- (void)close;

@property (nonatomic) NSString *workingDirectory;
@property (nonatomic, weak) id<WebServerConnectionDelegate> delegate;
@property (nonatomic) NSInputStream * _Nullable inputStream;
@property (nonatomic) NSOutputStream * _Nullable outputStream;
@property (nonatomic) NSData * _Nullable dataToWrite;
@property (nonatomic) NSInteger numBytesToWrite;

@end

NS_ASSUME_NONNULL_END
