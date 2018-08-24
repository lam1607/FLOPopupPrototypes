//
//  DataPresenterProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataViewProtocols.h"
#import "ComicRepositoryProtocols.h"

@class Comic;

@protocol DataPresenterProtocols <NSObject>

@property (nonatomic, strong) id<DataViewProtocols> view;
@property (nonatomic, strong) id<ComicRepositoryProtocols> repository;

- (void)attachView:(id<DataViewProtocols>)view repository:(id<ComicRepositoryProtocols>)repository;
- (void)detachView;

- (void)fetchData;
- (NSArray<Comic *> *)comics;

@end
