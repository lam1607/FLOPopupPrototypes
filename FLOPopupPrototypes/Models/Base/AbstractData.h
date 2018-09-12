//
//  AbstractData.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/30/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *pageUrl;

- (instancetype)initWithContent:(NSDictionary *)contentDict;
- (instancetype)initWithName:(NSString *)name imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl;
- (instancetype)initWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl pageUrl:(NSString *)pageUrl;

- (void)setImage:(NSImage *)image;
- (NSImage *)getImage;

@end
