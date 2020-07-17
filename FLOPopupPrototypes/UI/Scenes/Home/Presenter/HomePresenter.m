//
//  HomePresenter.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "HomePresenter.h"

@implementation HomePresenter

#pragma mark - HomePresenterProtocols implementation

@synthesize authenticationInfo = _authenticationInfo;

- (void)changeWindowMode
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewDidSelectWindowModeChanging];
    }
}

- (void)openFinder
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewOpensFinder];
    }
}

- (void)openSafari
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewOpensSafari];
    }
}

- (void)openFilmsView
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewOpensFilmsView];
    }
}

- (void)openNewsView
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewOpensNewsView];
    }
}

- (void)openComicsView
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewOpensComicsView];
    }
}

- (void)showSecondBar
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewShowsSecondBar];
    }
}

- (void)showTrashView
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewShowsTrashView];
    }
}

- (void)showGoogleMenuAtView:(NSView *)sender
{
    if ([self.view conformsToProtocol:@protocol(HomeViewProtocols)])
    {
        [(id<HomeViewProtocols>)self.view viewShowsGoogleMenuAtView:sender];
    }
}

- (void)authorizeGoogle
{
    __weak typeof(self) wself = self;
    
    [GTMAuthentication authorizeWithClientId:kGTMAuthClientID clientSecret:kGTMAuthClientSecret completion:^(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        this.authenticationInfo = authenticationInfo;
        
        DLog(@"authenticationInfo: %@, error: %@", this.authenticationInfo, error);
    }];
}

- (void)reauthenticateGoogle
{
    __weak typeof(self) wself = self;
    
    [GTMAuthentication refreshAccessTokenWithClientId:kGTMAuthClientID clientSecret:kGTMAuthClientSecret refreshToken:self.authenticationInfo.refreshToken completion:^(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        if (authenticationInfo != nil)
        {
            [this.authenticationInfo updateByObject:authenticationInfo];
        }
        
        DLog(@"authenticationInfo: %@, error: %@", this.authenticationInfo, error);
    }];
}

- (void)getGoogleTokenInfo
{
    __weak typeof(self) wself = self;
    
    [GTMAuthentication getTokenInfoWithID:self.authenticationInfo.idToken completion:^(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        if (authenticationInfo != nil)
        {
            [this.authenticationInfo updateByObject:authenticationInfo];
        }
        
        DLog(@"authenticationInfo: %@, error: %@", this.authenticationInfo, error);
    }];
}

@end
