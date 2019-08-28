//
//  HomeViewProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "AbstractViewProtocols.h"
#import "AbstractPresenterProtocols.h"

///
/// View
@protocol HomeViewProtocols <AbstractViewProtocols>

- (void)viewDidSelectWindowModeChanging;
- (void)viewShouldOpenFinder;
- (void)viewShouldOpenSafari;
- (void)viewShouldOpenFilmsView;
- (void)viewShouldOpenNewsView;
- (void)viewShouldOpenComicsView;
- (void)viewShouldShowSecondBar;
- (void)viewShouldShowTrashView;

@end

///
/// Presenter
@protocol HomePresenterProtocols <AbstractPresenterProtocols>

- (void)changeWindowMode;
- (void)openFinder;
- (void)openSafari;
- (void)openFilmsView;
- (void)openNewsView;
- (void)openComicsView;
- (void)showSecondBar;
- (void)showTrashView;

@end
