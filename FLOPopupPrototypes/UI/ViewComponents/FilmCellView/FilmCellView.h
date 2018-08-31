//
//  FilmCellView.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/30/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FilmCellViewProtocols.h"
#import "FilmRepository.h"
#import "FilmCellPresenter.h"

@class Film;

@interface FilmCellView : NSCollectionViewItem <FilmCellViewProtocols>

- (CGFloat)getViewItemHeight;

- (void)updateUIWithData:(Film *)film;

@end
