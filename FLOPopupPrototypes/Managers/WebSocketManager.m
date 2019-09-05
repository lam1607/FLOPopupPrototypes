//
//  WebSocketManager.m
//  FLOPopupPrototypes
//
//  Created by Lam Nguyen on 9/4/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "WebSocketManager.h"

@interface WebSocketManager ()
{
    WebServer *_server;
    NSString *_serverPath;
}

@end

@implementation WebSocketManager

#pragma mark - Singleton

+ (WebSocketManager *)sharedInstance
{
    static WebSocketManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WebSocketManager alloc] init];
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

- (WebServer *)server
{
    return _server;
}

#pragma mark - Local methods

#pragma mark - WebSocketManager methods

- (void)setupServerWithPort:(int)port
{
    @synchronized (self)
    {
        if (port < 0)
        {
            NSLog(@"%s-[%d] Port must be positive number \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, [NSThread callStackSymbols]);
            assert(NO);
        }
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSError *cacheError = nil;
        NSURL *cacheURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&cacheError];
        
        if (cacheURL == nil)
        {
            NSLog(@"%s-[%d] Failed to locate cache directory with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, cacheError, [NSThread callStackSymbols]);
            assert(NO);
        }
        
        NSString *bundleIdentifier = [mainBundle bundleIdentifier];
        assert(bundleIdentifier != nil);
        
        // Create a directory that'll be used for our web server listing
        NSURL *serverURL = [[cacheURL URLByAppendingPathComponent:bundleIdentifier] URLByAppendingPathComponent:@"SocketServer"];
        
#ifdef kFlowarePopover_UpdateRelease
        //        if ([serverURL checkResourceIsReachableAndReturnError:nil])
        //        {
        //            NSError *removeServerDirectoryError = nil;
        //
        //            if (![[NSFileManager defaultManager] removeItemAtURL:serverURL error:&removeServerDirectoryError])
        //            {
        //                assert(NO);
        //            }
        //        }
        
        NSError *createDirectoryError = nil;
        
        if (![[NSFileManager defaultManager] createDirectoryAtURL:serverURL withIntermediateDirectories:YES attributes:nil error:&createDirectoryError])
        {
            NSLog(@"%s-[%d] Failed creating directory at %@ with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, serverURL.path, createDirectoryError, [NSThread callStackSymbols]);
            assert(NO);
        }
        
        if (![[NSFileManager defaultManager] createDirectoryAtURL:[serverURL URLByAppendingPathComponent:@"downloads"] withIntermediateDirectories:YES attributes:nil error:&createDirectoryError])
        {
            NSLog(@"%s-[%d] Failed creating directory at %@ with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, serverURL.path, createDirectoryError, [NSThread callStackSymbols]);
            assert(NO);
        }
        
        if (![[NSFileManager defaultManager] createDirectoryAtURL:[serverURL URLByAppendingPathComponent:@"release-notes"] withIntermediateDirectories:YES attributes:nil error:&createDirectoryError])
        {
            NSLog(@"%s-[%d] Failed creating directory at %@ with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, serverURL.path, createDirectoryError, [NSThread callStackSymbols]);
            assert(NO);
        }
        
        // Copy appcast.xml from project to server path.
        NSURL *appcastURL = [[serverURL URLByAppendingPathComponent:@"appcast"] URLByAppendingPathExtension:@"xml"];
        NSURL *appcastPath = [mainBundle URLForResource:@"appcast" withExtension:@"xml"];
        
        assert(appcastPath);
        
        if (![appcastURL checkResourceIsReachableAndReturnError:nil])
        {
            NSError *copyAppcastError = nil;
            
            if (![[NSFileManager defaultManager] copyItemAtURL:appcastPath toURL:appcastURL error:&copyAppcastError])
            {
                NSLog(@"%s-[%d] Failed to copy appcast.xml into cache directory with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, copyAppcastError, [NSThread callStackSymbols]);
                assert(NO);
            }
        }
        
        // Copy release-notes.html from project to server path.
        NSURL *releaseNotesURL = [[serverURL URLByAppendingPathComponent:@"release-notes/release-notes"] URLByAppendingPathExtension:@"html"];
        NSURL *releaseNotesPath = [mainBundle URLForResource:@"release-notes" withExtension:@"html"];
        
        assert(releaseNotesPath);
        
        if (![releaseNotesURL checkResourceIsReachableAndReturnError:nil])
        {
            NSError *copyReleaseNotesError = nil;
            
            if (![[NSFileManager defaultManager] copyItemAtURL:releaseNotesPath toURL:releaseNotesURL error:&copyReleaseNotesError])
            {
                NSLog(@"%s-[%d] Failed to copy release-notes.html into cache directory with error: %@ \n[NSThread callStackSymbols] = %@", __PRETTY_FUNCTION__, __LINE__, copyReleaseNotesError, [NSThread callStackSymbols]);
                assert(NO);
            }
        }
#endif
        
        NSString *serverPath = serverURL.path;
        
        assert(serverPath != nil);
        
        WebServer *server = [[WebServer alloc] initWithPort:port workingDirectory:serverPath];
        
        if (!server)
        {
            NSLog(@"Failed to create the web server");
            assert(NO);
        }
        
        _server = server;
        _serverPath = serverPath;
    }
}

- (void)connect
{
    @synchronized (self)
    {
        if (_server != nil)
        {
            [_server close];
            _server = nil;
        }
        
        [self setupServerWithPort:1607];
    }
}

- (void)close
{
    @synchronized (self)
    {
        [_server close];
        _server = nil;
    }
}

@end
