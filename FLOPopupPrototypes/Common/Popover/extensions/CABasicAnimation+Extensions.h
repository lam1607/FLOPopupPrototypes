//
//  CAAnimation+Extensions.h
//  entitlement-apps-ws-concept
//
//  Created by Truong Quang Hung on 12/21/16.
//  Copyright © 2016 Truong Quang Hung. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (Extensions)
+ (CAAnimation *)transformAxisXAnimationWithDuration:(NSTimeInterval)aDuration
                              forLayerBeginningOnTop:(BOOL)beginsOnTop
                                         scaleFactor:(CGFloat)scaleFactor
                                          fromTransX:(CGFloat)fromTransX
                                            toTransX:(CGFloat)toTransX
                                         fromOpacity:(CGFloat)fromOpacity
                                           toOpacity:(CGFloat)toOpacity;
+ (CAAnimation *)transformAxisYAnimationWithDuration:(NSTimeInterval)aDuration
                              forLayerBeginningOnTop:(BOOL)beginsOnTop
                                         scaleFactor:(CGFloat)scaleFactor
                                          fromTransY:(CGFloat)fromTransY
                                            toTransY:(CGFloat)toTransY
                                         fromOpacity:(CGFloat)fromOpacity
                                           toOpacity:(CGFloat)toOpacity;
+ (CAAnimation *)resizeAnimationWithDuration:(NSTimeInterval)aDuration fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame fromOpacity:(CGFloat)fromOpacity toOpacity:(CGFloat)toOpacity;

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)duration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor;
+ (CAAnimation *)disappearAxisXAnimationWithDuration:(NSTimeInterval)aDuration
                              forLayerBeginningOnTop:(BOOL)beginsOnTop
                                         scaleFactor:(CGFloat)scaleFactor
                                        translationX:(CGFloat)transX;
+ (CAAnimation *)disappearAxisYAnimationWithDuration:(NSTimeInterval)aDuration
                              forLayerBeginningOnTop:(BOOL)beginsOnTop
                                         scaleFactor:(CGFloat)scaleFactor
                                        translationY:(CGFloat)transY;
#pragma mark rotate anim
+ (void)rotateAnimationForKey:(NSString *)animKey withDuration:(NSTimeInterval)aDuration forButton:(NSButton *)rotateBtn;
@end
