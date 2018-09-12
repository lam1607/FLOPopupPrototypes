//
//  NewsRepositoryProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRepositoryProtocols.h"

@class News;

@protocol NewsRepositoryProtocols <BaseRepositoryProtocols>

- (NSArray<News *> *)fetchNews;

@end
