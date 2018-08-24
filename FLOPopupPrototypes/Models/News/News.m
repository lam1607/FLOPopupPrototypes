//
//  News.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "News.h"

@interface News ()

@property (nonatomic, strong) NSImage *_newsImage;

@end

@implementation News

#pragma mark -
#pragma mark - Initialize
#pragma mark -
- (instancetype)initWithContent:(NSDictionary *)contentDict {
    if (self = [super init]) {
        if (![Utils isEmptyObject:contentDict]) {
            NSString *title = [contentDict objectForKey:@"title"];
            NSString *content = [contentDict objectForKey:@"content"];
            NSString *imageUrl = [contentDict objectForKey:@"imageUrl"];
            NSString *pageUrl = [contentDict objectForKey:@"pageUrl"];
            
            return [self initWithTitle:title content:content imageUrl:imageUrl pageUrl:pageUrl];
        }
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl {
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.imageUrl = [NSURL URLWithString:imageUrl];
        self.pageUrl = [NSURL URLWithString:pageUrl];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (void)setImage:(NSImage *)image {
    self._newsImage = image;
}

- (NSImage *)getImage {
    return self._newsImage;
}

@end
