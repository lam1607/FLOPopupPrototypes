//
//  Film.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/30/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "AbstractData.h"

@interface Film : AbstractData

@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSURL *trailerUrl;

- (instancetype)initWithName:(NSString *)name releaseDate:(NSString *)releaseDate synopsis:(NSString *)synopsis
                    imageUrl:(NSString *)imageUrl trailerUrl:(NSString *)trailerUrl;

@end
