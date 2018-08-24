//
//  NewsRepository.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "NewsRepository.h"

#import "News.h"
#import "NewsService.h"

@interface NewsRepository ()

@property (nonatomic, strong) NewsService *_service;

@end

@implementation NewsRepository

- (instancetype)init {
    if (self = [super init]) {
        self._service = [[NewsService alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark - NewsServiceProtocols implementation
#pragma mark -
- (NSArray<News *> *)fetchNews {
    NSMutableArray *news = [[NSMutableArray alloc] init];
    NSArray<NSDictionary *> *newsDicts = [self._service getMockupData];
    
    [newsDicts enumerateObjectsUsingBlock:^(NSDictionary *contentDict, NSUInteger idx, BOOL *stop) {
        News *item = [[News alloc] initWithContent:contentDict];
        [news addObject:item];
    }];
    
    return news;
}

- (void)fetchImageFromUrl:(NSURL *)url completion:(void (^)(NSImage *image))complete {
    [self._service fetchDataFromUrl:url completion:^(NSData *data) {
        if (complete) {
            complete((data != nil) ? [[NSImage alloc] initWithData:data] : nil);
        }
    }];
}

@end
