//
//  GTMCalendarsServiceProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 7/20/20.
//  Copyright © 2020 Floware Inc. All rights reserved.
//

#ifndef GTMCalendarsServiceProtocols_h
#define GTMCalendarsServiceProtocols_h

#import "AbstractServiceProtocols.h"

@protocol GTMCalendarsServiceProtocols <AbstractServiceProtocols>

@property (nonatomic, strong) GTLRCalendar_CalendarList *calendarList;
@property (nonatomic, strong) GTLRServiceTicket *calendarListTicket;
@property (nonatomic, strong) NSError *calendarListFetchError;

- (void)setAuthorizer:(id<GTMFetcherAuthorizationProtocol>)authorizer;
- (void)fetchCalendarsWithCompletion:(void(^)(id calendarList, NSError *error))complete;

@end

#endif /* GTMCalendarsServiceProtocols_h */
