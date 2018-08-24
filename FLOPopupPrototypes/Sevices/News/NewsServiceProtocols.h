//
//  NewsServiceProtocols.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseServiceProtocols.h"

@protocol NewsServiceProtocols <BaseServiceProtocols>

- (NSArray<NSDictionary *> *)getMockupData;

@end
