//
//  ComicRepositoryProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comic;

@protocol ComicRepositoryProtocols <NSObject>

- (NSArray<Comic *> *)fetchComics;
- (void)fetchImageFromUrl:(NSURL *)url completion:(void (^)(NSImage *image))complete;

@end
