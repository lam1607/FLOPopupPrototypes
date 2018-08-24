//
//  ComicService.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "ComicService.h"

@implementation ComicService

#pragma mark -
#pragma mark - BaseServiceProtocols implementation
#pragma mark -
- (void)fetchDataFromUrl:(NSURL *)url completion:(void (^)(NSData *data))complete {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (complete) {
            complete((data && !error) ? data : nil);
        }
    }];
    
    [task resume];
}

#pragma mark -
#pragma mark - ComicServiceProtocols implementation
#pragma mark -
- (NSArray<NSDictionary *> *)getMockupData {
    NSMutableArray *mockData = [[NSMutableArray alloc] init];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FILENAME_DATA_MOCKUP ofType:@"plist"]];
    NSString *dataKey = @"comics";
    
    if (![Utils isEmptyObject:[dataDict objectForKey:dataKey]] && [[dataDict objectForKey:dataKey] isKindOfClass:[NSArray class]]) {
        mockData = [[NSMutableArray alloc] initWithArray:[dataDict objectForKey:dataKey]];
    }
    
    return mockData;
}

@end
