//
//  FilmCellPresenter.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/31/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FilmCellViewProtocols.h"
#import "FilmCellPresenterProtocols.h"
#import "FilmRepositoryProtocols.h"

@protocol FilmCellViewProtocols;
@protocol FilmRepositoryProtocols;

@interface FilmCellPresenter : NSObject <FilmCellPresenterProtocols>

@end
