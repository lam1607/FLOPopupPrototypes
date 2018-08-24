//
//  Comic.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "Comic.h"

@interface Comic ()

@property (nonatomic, strong) NSImage *_comicImage;

@end

@implementation Comic

#pragma mark -
#pragma mark - Initialize
#pragma mark -
- (instancetype)initWithContent:(NSDictionary *)contentDict {
    if (self = [super init]) {
        if (![Utils isEmptyObject:contentDict]) {
            NSString *name = [contentDict objectForKey:@"name"];
            NSString *shortDesc = [contentDict objectForKey:@"shortDesc"];
            NSString *longDesc = [contentDict objectForKey:@"longDesc"];
            NSString *imageUrl = [contentDict objectForKey:@"imageUrl"];
            NSString *pageUrl = [contentDict objectForKey:@"pageUrl"];
            
            self = [self initWithName:name shortDesc:shortDesc longDesc:longDesc imageUrl:imageUrl pageUrl:pageUrl];
        }
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name shortDesc:(NSString *)shortDesc longDesc:(NSString *)longDesc
                    imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl {
    if (self = [super init]) {
        self.name = name;
        self.shortDesc = shortDesc;
        self.longDesc = longDesc;
        self.imageUrl = [NSURL URLWithString:imageUrl];
        self.pageUrl = [NSURL URLWithString:pageUrl];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (void)setImage:(NSImage *)image {
    self._comicImage = image;
}

- (NSImage *)getImage {
    return self._comicImage;
}

@end
