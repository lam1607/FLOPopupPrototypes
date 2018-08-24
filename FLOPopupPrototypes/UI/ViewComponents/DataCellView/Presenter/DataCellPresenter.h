//
//  DataCellPresenter.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataCellViewProtocols.h"
#import "DataCellPresenterProtocols.h"
#import "ComicRepositoryProtocols.h"

@protocol DataCellViewProtocols;
@protocol ComicRepositoryProtocols;

@interface DataCellPresenter : NSObject <DataCellPresenterProtocols>

@end
