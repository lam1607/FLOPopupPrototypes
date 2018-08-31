//
//  FilmRepository.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/31/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "FilmRepository.h"

#import "Film.h"
#import "FilmService.h"

@interface FilmRepository ()

@property (nonatomic, strong) FilmService *_service;

@end

@implementation FilmRepository

- (instancetype)init {
    if (self = [super init]) {
        self._service = [[FilmService alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark - FilmRepositoryProtocols implementation
#pragma mark -
- (NSArray<Film *> *)fetchFilms {
    NSMutableArray *films = [[NSMutableArray alloc] init];
    NSArray<NSDictionary *> *filmDicts = [self._service getMockupDataType:@"films"];
    
    [filmDicts enumerateObjectsUsingBlock:^(NSDictionary *contentDict, NSUInteger idx, BOOL *stop) {
        Film *item = [[Film alloc] initWithContent:contentDict];
        [films addObject:item];
    }];
    
    return films;
}

@end
