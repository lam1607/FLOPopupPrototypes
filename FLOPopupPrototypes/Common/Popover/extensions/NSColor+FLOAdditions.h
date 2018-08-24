//
//  NSColor+FLOAdditions.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (FLOAdditions)

- (instancetype)initWithHex:(NSString *)hex;

+ (NSColor *)colorBlue;
+ (NSColor *)colorLavender;
+ (NSColor *)colorViolet;
+ (NSColor *)colorTeal;
+ (NSColor *)colorOrange;
+ (NSColor *)colorMoss;
+ (NSColor *)colorDust;
+ (NSColor *)colorGray;
+ (NSColor *)colorUltraLightGray;
+ (NSColor *)colorBackground;

@end
