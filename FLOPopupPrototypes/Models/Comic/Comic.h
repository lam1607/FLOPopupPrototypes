//
//  Comic.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comic : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortDesc;
@property (nonatomic, strong) NSString *longDesc;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *pageUrl;

- (instancetype)initWithContent:(NSDictionary *)contentDict;
- (instancetype)initWithName:(NSString *)name shortDesc:(NSString *)shortDesc longDesc:(NSString *)longDesc
                    imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl;

- (void)setImage:(NSImage *)image;
- (NSImage *)getImage;

@end

