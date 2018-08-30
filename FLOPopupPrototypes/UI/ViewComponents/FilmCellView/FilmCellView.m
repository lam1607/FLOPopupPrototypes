//
//  FilmCellView.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/30/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "FilmCellView.h"

@interface FilmCellView ()

@property (weak) IBOutlet NSView *vContainer;
@property (weak) IBOutlet NSImageView *imgView;
@property (weak) IBOutlet NSTextField *lblTitle;

@end

@implementation FilmCellView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setupUI];
}

#pragma mark -
#pragma mark - Initialize
#pragma mark -

#pragma mark -
#pragma mark - Setup UI
#pragma mark -
- (void)setupUI {
    self.vContainer.wantsLayer = YES;
    self.vContainer.layer.cornerRadius = [CORNER_RADIUSES[0] doubleValue];
    self.vContainer.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.imgView.wantsLayer = YES;
    self.imgView.layer.backgroundColor = [[NSColor colorUltraLightGray] CGColor];
    self.imgView.imageScaling = NSImageScaleProportionallyDown;
    self.imgView.layer.cornerRadius = [CORNER_RADIUSES[0] doubleValue];
    
    self.lblTitle.font = [NSFont systemFontOfSize:18.0f weight:NSFontWeightMedium];
    self.lblTitle.textColor = [NSColor colorBlue];
    self.lblTitle.maximumNumberOfLines = 0;
}

#pragma mark -
#pragma mark - Processes
#pragma mark -

@end
