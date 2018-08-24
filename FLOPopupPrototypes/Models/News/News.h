//
//  News.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/24/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *pageUrl;

- (instancetype)initWithContent:(NSDictionary *)contentDict;
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl;

- (void)setImage:(NSImage *)image;
- (NSImage *)getImage;

@end
