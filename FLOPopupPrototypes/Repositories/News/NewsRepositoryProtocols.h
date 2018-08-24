//
//  NewsRepositoryProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class News;

@protocol NewsRepositoryProtocols <NSObject>

- (NSArray<News *> *)fetchNews;
- (void)fetchImageFromUrl:(NSURL *)url completion:(void (^)(NSImage *image))complete;

@end
