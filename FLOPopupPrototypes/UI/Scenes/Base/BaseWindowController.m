//
//  BaseWindowController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/21/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "BaseWindowController.h"

@interface BaseWindowController ()

@end

@implementation BaseWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self setupUI];
}

#pragma mark -
#pragma mark - Setup UI
#pragma mark -
- (void)setupUI {
    NSRect visibleFrame = [self.window.screen visibleFrame];
    CGFloat width = 0.5f * visibleFrame.size.width;
    CGFloat height = 0.69f * visibleFrame.size.height;
    CGFloat x = (visibleFrame.size.width - width) / 2;
    CGFloat y = (visibleFrame.size.height + visibleFrame.origin.y - height) / 2;
    NSRect viewFrame = NSMakeRect(x, y, width, height);
    
    [self.window setFrame:viewFrame display:YES];
    [self.window setMinSize:NSMakeSize(0.5f * visibleFrame.size.width, 0.5f * visibleFrame.size.height)];
}

@end
