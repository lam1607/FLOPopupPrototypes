//
//  ComicRepositoryProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRepositoryProtocols.h"

@class Comic;

@protocol ComicRepositoryProtocols <BaseRepositoryProtocols>

- (NSArray<Comic *> *)fetchComics;

@end
