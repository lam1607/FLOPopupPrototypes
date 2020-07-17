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
- (void)viewOpensFinder;
- (void)viewOpensSafari;
- (void)viewOpensFilmsView;
- (void)viewOpensNewsView;
- (void)viewOpensComicsView;
- (void)viewShowsSecondBar;
- (void)viewShowsTrashView;
- (void)viewShowsGoogleMenuAtView:(NSView *)sender;

@end

///
/// Presenter
@protocol HomePresenterProtocols <AbstractPresenterProtocols>

@property (nonatomic, strong) GTMAuthenticationInfo *authenticationInfo;

- (void)changeWindowMode;
- (void)openFinder;
- (void)openSafari;
- (void)openFilmsView;
- (void)openNewsView;
- (void)openComicsView;
- (void)showSecondBar;
- (void)showTrashView;

- (void)showGoogleMenuAtView:(NSView *)sender;

- (void)authorizeGoogle;
- (void)reauthenticateGoogle;
- (void)getGoogleTokenInfo;

@end
