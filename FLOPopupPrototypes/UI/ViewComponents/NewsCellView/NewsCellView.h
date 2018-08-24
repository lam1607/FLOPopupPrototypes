//
//  NewsCellView.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NewsCellViewProtocols.h"
#import "NewsRepository.h"
#import "NewsCellPresenter.h"

@class News;

@interface NewsCellView : NSTableCellView <NewsCellViewProtocols>

- (CGFloat)getCellHeight;

- (void)updateUIWithData:(News *)news;

@end
