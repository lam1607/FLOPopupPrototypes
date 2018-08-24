//
//  DataPresenter.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataViewProtocols.h"
#import "DataPresenterProtocols.h"
#import "ComicRepositoryProtocols.h"

@protocol DataViewProtocols;
@protocol ComicRepositoryProtocols;

@interface DataPresenter : NSObject <DataPresenterProtocols>

@end

