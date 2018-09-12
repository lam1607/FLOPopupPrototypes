//
//  News.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "AbstractData.h"

@interface News : AbstractData

@property (nonatomic, strong) NSString *content;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl;

@end
