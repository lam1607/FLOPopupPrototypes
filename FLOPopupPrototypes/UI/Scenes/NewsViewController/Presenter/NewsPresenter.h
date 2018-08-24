//
//  NewsPresenter.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewsViewProtocols.h"
#import "NewsPresenterProtocols.h"
#import "NewsRepositoryProtocols.h"

@protocol NewsViewProtocols;
@protocol NewsRepositoryProtocols;

@interface NewsPresenter : NSObject <NewsPresenterProtocols>

@end
