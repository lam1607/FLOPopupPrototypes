//
//  GTMCalendarsService.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 7/20/20.
//  Copyright © 2020 Floware Inc. All rights reserved.
//

#import "GTMCalendarsService.h"

@implementation GTMCalendarsService

@synthesize calendarList = _calendarList;
@synthesize calendarListTicket = _calendarListTicket;
@synthesize calendarListFetchError = _calendarListFetchError;

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init])
    {
    }
    
    return self;
}

#pragma mark - Getter/Setter

- (GTLRCalendarService *)calendarService
{
    static GTLRCalendarService *service = nil;
    
    if (!service)
    {
        service = [[GTLRCalendarService alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service.retryEnabled = YES;
    }
    
    return service;
}

#pragma mark - GTMCalendarsServiceProtocols implementation

- (void)setAuthorizer:(id<GTMFetcherAuthorizationProtocol>)authorizer
{
    if ((authorizer != nil) && [authorizer conformsToProtocol:@protocol(GTMFetcherAuthorizationProtocol)])
    {
        self.calendarService.authorizer = authorizer;
    }
}

- (void)fetchCalendarsWithCompletion:(void(^)(id calendarList, NSError *error))complete
{
    self.calendarList = nil;
    self.calendarListFetchError = nil;
    
    GTLRCalendarService *service = self.calendarService;
    GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];
    
    self.calendarListTicket = [service executeQuery:query completionHandler:^(GTLRServiceTicket *callbackTicket, id calendarList, NSError *callbackError) {
        // Callback
        self.calendarList = calendarList;
        self.calendarListFetchError = callbackError;
        self.calendarListTicket = nil;
        
        if (complete != nil)
        {
            complete(calendarList, callbackError);
        }
    }];
}

@end
