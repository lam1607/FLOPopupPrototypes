//
//  HomePresenter.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "HomePresenter.h"

#import "GTMCalendarsService.h"

@interface HomePresenter ()
{
    GTMAuthenticationInfo *_authenticationInfo;
}

@end

@implementation HomePresenter

#pragma mark - HomePresenterProtocols implementation

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
        
        this->_authenticationInfo = authenticationInfo;
        
        DLog(@"authenticationInfo: %@, error: %@", this->_authenticationInfo, error);
    }];
}

- (void)reauthenticateGoogle
{
    __weak typeof(self) wself = self;
    
    [GTMAuthentication refreshAccessTokenWithClientId:kGTMAuthClientID clientSecret:kGTMAuthClientSecret refreshToken:_authenticationInfo.refreshToken completion:^(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        if (authenticationInfo != nil)
        {
            this->_authenticationInfo = [GTMAuthentication updateAuthentication:this->_authenticationInfo byObject:authenticationInfo];
        }
        
        DLog(@"authenticationInfo: %@, error: %@", this->_authenticationInfo, error);
    }];
}

- (void)getGoogleTokenInfo
{
    __weak typeof(self) wself = self;
    
    [GTMAuthentication getTokenInfoWithID:_authenticationInfo.idToken completion:^(GTMAuthenticationInfo * _Nullable authenticationInfo, NSError * _Nullable error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        if (authenticationInfo != nil)
        {
        }
        
        DLog(@"authenticationInfo: %@, error: %@", this->_authenticationInfo, error);
    }];
}

- (void)fetchCalendars
{
    id<GTMCalendarsServiceProtocols> _calendarsService = [[GTMCalendarsService alloc] init];
    [_calendarsService setAuthorizer:_authenticationInfo];
    
    __weak typeof(self) wself = self;
    
    [_calendarsService fetchCalendarsWithCompletion:^(id calendarList, NSError *error) {
        if (wself == nil) return;
        
        __strong typeof(self) this = wself;
        
        DLog(@"calendars: %@, error: %@", ((GTLRCalendar_CalendarList *)calendarList).items, error);
    }];
}

@end
