//
//  FilmRepositoryProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/31/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRepositoryProtocols.h"

@class Film;

@protocol FilmRepositoryProtocols <BaseRepositoryProtocols>

- (NSArray<Film *> *)fetchFilms;

@end