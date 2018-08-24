//
//  BaseViewController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewWillAppear {
    [super viewWillAppear];
}

#pragma mark -
#pragma mark - Formats
#pragma mark -
- (void)setBackgroundColor:(NSColor *)color forView:(NSView *)view {
    view.wantsLayer = YES;
    view.layer.backgroundColor = [color CGColor];
}

- (void)setBackgroundColor:(NSColor *)color cornerRadius:(CGFloat)radius forView:(NSView *)view {
    [self setBackgroundColor:color forView:view];
    view.layer.cornerRadius = radius;
}

- (void)setTitle:(NSString *)title attributes:(NSDictionary *)attributes forControl:(NSControl *)control {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    control.attributedStringValue = attributedString;
    
    if ([control isKindOfClass:[NSButton class]]) {
        ((NSButton *) control).attributedTitle = attributedString;
    }
}

@end
