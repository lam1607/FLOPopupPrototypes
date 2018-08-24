//
//  CustomNSOutlineView.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/23/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CustomNSOutlineView;

@protocol CustomNSOutlineViewDelegate <NSObject>

@optional
- (void)outlineView:(CustomNSOutlineView *)outlineView didSelectRow:(NSInteger)row;
- (void)outlineView:(CustomNSOutlineView *)outlineView didSelectRow:(NSInteger)row location:(NSPoint)point;

@end

@interface CustomNSOutlineView : NSOutlineView

@property (nonatomic, weak) id<CustomNSOutlineViewDelegate> pdelegate;

@end
