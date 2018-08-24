//
//  DataCellView.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DataCellViewProtocols.h"
#import "ComicRepository.h"
#import "DataCellPresenter.h"

@class Comic;

@interface DataCellView : NSTableCellView <DataCellViewProtocols>

- (CGFloat)getCellHeight;

- (void)updateUIWithData:(Comic *)comic;

@end
