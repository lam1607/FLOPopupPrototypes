//
//  ComicRepository.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "ComicRepository.h"

#import "Comic.h"
#import "ComicService.h"

@interface ComicRepository ()

@property (nonatomic, strong) ComicService *_service;

@end

@implementation ComicRepository

- (instancetype)init {
    if (self = [super init]) {
        self._service = [[ComicService alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark - ComicRepositoryProtocols implementation
#pragma mark -
- (NSArray<Comic *> *)fetchComics {
    NSMutableArray *comics = [[NSMutableArray alloc] init];
    NSArray<NSDictionary *> *comicDicts = [self._service getMockupData];
    
    [comicDicts enumerateObjectsUsingBlock:^(NSDictionary *contentDict, NSUInteger idx, BOOL *stop) {
        Comic *item = [[Comic alloc] initWithContent:contentDict];
        [comics addObject:item];
    }];
    
    return comics;
}

- (void)fetchImageFromUrl:(NSURL *)url completion:(void (^)(NSImage *image))complete {
    [self._service fetchDataFromUrl:url completion:^(NSData *data) {
        if (complete) {
            complete((data != nil) ? [[NSImage alloc] initWithData:data] : nil);
        }
    }];
}

@end
