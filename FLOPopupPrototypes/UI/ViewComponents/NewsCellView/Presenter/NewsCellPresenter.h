//
//  NewsCellPresenter.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewsCellViewProtocols.h"
#import "NewsCellPresenterProtocols.h"
#import "NewsRepositoryProtocols.h"

@protocol NewsCellViewProtocols;
@protocol NewsRepositoryProtocols;

@interface NewsCellPresenter : NSObject <NewsCellPresenterProtocols>

@end
