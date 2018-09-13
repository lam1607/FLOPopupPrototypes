//
//  HomeViewController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "HomeViewController.h"

#import "FLOPopoverWindowController.h"

#import "FilmsViewController.h"
#import "NewsViewController.h"
#import "DataViewController.h"

#import "FLOPopover.h"

@interface HomeViewController ()

@property (weak) IBOutlet NSView *vMenu;
@property (weak) IBOutlet NSView *vChangeMode;
@property (weak) IBOutlet NSButton *btnChangeMode;
@property (weak) IBOutlet NSView *vShowWindowPopup;
@property (weak) IBOutlet NSButton *btnShowWindowPopup;
@property (weak) IBOutlet NSView *vShowViewPopup;
@property (weak) IBOutlet NSButton *btnShowViewPopup;
@property (weak) IBOutlet NSView *vShowDataMix;
@property (weak) IBOutlet NSButton *btnShowDataMix;

@property (nonatomic, strong) HomePresenter *_homePresenter;

@property (nonatomic, strong) FLOPopover *_popoverFilms;
@property (nonatomic, strong) FLOPopover *_popoverNews;
@property (nonatomic, strong) FLOPopover *_popoverData;

@property (nonatomic, strong) FilmsViewController *filmsViewController;
@property (nonatomic, strong) NewsViewController *newsViewController;
@property (nonatomic, strong) DataViewController *dataViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self initialize];
    [self setupUI];
}

- (void)viewWillAppear {
    [super viewWillAppear];
}

#pragma mark -
#pragma mark - Initialize
#pragma mark -
- (void)initialize {
    self._homePresenter = [[HomePresenter alloc] init];
    [self._homePresenter attachView:self];
}

#pragma mark -
#pragma mark - Setup UI
#pragma mark -
- (void)setupUI {
    [self setBackgroundColor:[NSColor colorGray] forView:self.vMenu];
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:14.0f weight:NSFontWeightRegular], NSFontAttributeName,
                                     [NSColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self setBackgroundColor:[NSColor colorDust] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.vChangeMode];
    [self setTitle:@"Change window mode" attributes:titleAttributes forControl:self.btnChangeMode];
    
    [self setBackgroundColor:[NSColor colorTeal] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.vShowWindowPopup];
    [self setTitle:@"Show window popup" attributes:titleAttributes forControl:self.btnShowWindowPopup];
    
    [self setBackgroundColor:[NSColor colorLavender] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.vShowViewPopup];
    [self setTitle:@"Show view popup" attributes:titleAttributes forControl:self.btnShowViewPopup];
    
    [self setBackgroundColor:[NSColor colorViolet] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.vShowDataMix];
    [self setTitle:@"Show data mix" attributes:titleAttributes forControl:self.btnShowDataMix];
}

#pragma mark -
#pragma mark - Processes
#pragma mark -
- (void)changeWindowMode {
    [[FLOPopoverWindow sharedInstance] setWindowMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:FLO_NOTIFICATION_WINDOW_DID_CHANGE_MODE object:nil userInfo:nil];
}

- (void)showPopover:(FLOPopover *)aPopover edgeType:(FLOPopoverEdgeType)edgeType atSender:(NSView *)sender {
    __block FLOPopover *_aPopover = aPopover;
    
    NSView *positioningView = ((sender.superview != nil) ? sender.superview : sender);
    NSRect positioningRect = positioningView.bounds;
    
    [_aPopover showRelativeToRect:positioningRect ofView:positioningView edgeType:edgeType];
}

- (void)showWindowPopupAtSender:(NSView *)sender {
    NSRect visibleRect = [self.view visibleRect];
    CGFloat menuHeight = self.vMenu.frame.size.height;
    CGFloat width = 0.8f * (visibleRect.size.width - 100.0f);
    CGFloat height = visibleRect.size.height - menuHeight;
    NSRect contentViewRect = NSMakeRect(0.0f, 0.0f, width, height);
    
    if (self._popoverFilms == nil) {
        self.filmsViewController = [[FilmsViewController alloc] initWithNibName:NSStringFromClass([FilmsViewController class]) bundle:nil];
        [self.filmsViewController.view setFrame:contentViewRect];
        
        self._popoverFilms = [[FLOPopover alloc] initWithContentViewController:self.filmsViewController popoverType:FLOWindowPopover];
    }
    
    //    self._popoverFilms.alwaysOnTop = YES;
    //    self._popoverFilms.shouldShowArrow = YES;
    self._popoverFilms.animated = YES;
    //    self._popoverFilms.closesWhenPopoverResignsKey = YES;
    //    self._popoverFilms.closesWhenApplicationBecomesInactive = YES;
    //    self._popoverFilms.popoverMovable = YES;
    
    //    if (NSEqualRects(self.filmsViewController.view.frame, contentViewRect) == NO) {
    //        [self.filmsViewController.view setFrame:contentViewRect];
    //    }
    
    [self._popoverFilms setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationLeftToRight];
    [self showPopover:self._popoverFilms edgeType:FLOPopoverEdgeTypeHorizontalBelowLeftEdge atSender:sender];
}

- (void)showViewPopupAtSender:(NSView *)sender {
    NSRect visibleRect = [self.view visibleRect];
    CGFloat menuHeight = self.vMenu.frame.size.height;
    CGFloat width = 500.0f;
    CGFloat height = visibleRect.size.height - menuHeight;
    NSRect contentViewRect = NSMakeRect(0.0f, 0.0f, width, height);
    
    if (self._popoverNews == nil) {
        self.newsViewController = [[NewsViewController alloc] initWithNibName:NSStringFromClass([NewsViewController class]) bundle:nil];
        [self.newsViewController.view setFrame:contentViewRect];
        
        self._popoverNews = [[FLOPopover alloc] initWithContentViewController:self.newsViewController popoverType:FLOViewPopover];
    }
    
    //    self._popoverNews.alwaysOnTop = YES;
    //    self._popoverNews.shouldShowArrow = YES;
    self._popoverNews.animated = YES;
    //    self._popoverNews.closesWhenPopoverResignsKey = YES;
    //    self._popoverNews.closesWhenApplicationBecomesInactive = YES;
    //    self._popoverNews.popoverMovable = YES;
    
    //    if (NSEqualRects(self.newsViewController.view.frame, contentViewRect) == NO) {
    //        [self.newsViewController.view setFrame:contentViewRect];
    //    }
    
    [self._popoverNews setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationLeftToRight];
    [self showPopover:self._popoverNews edgeType:FLOPopoverEdgeTypeHorizontalBelowLeftEdge atSender:sender];
}

- (void)showDataMixAtSender:(NSView *)sender {
    NSRect visibleRect = [self.view visibleRect];
    CGFloat menuHeight = self.vMenu.frame.size.height;
    CGFloat width = 0.5f * (visibleRect.size.width - 100.0f);
    CGFloat height = visibleRect.size.height - menuHeight;
    NSRect contentViewRect = NSMakeRect(0.0f, 0.0f, width, height);
    
    if (self._popoverData == nil) {
        self.dataViewController = [[DataViewController alloc] initWithNibName:NSStringFromClass([DataViewController class]) bundle:nil];
        [self.dataViewController.view setFrame:contentViewRect];
        
        self._popoverData = [[FLOPopover alloc] initWithContentViewController:self.dataViewController popoverType:FLOWindowPopover];
    }
    
    self._popoverData.alwaysOnTop = YES;
    //    self._popoverData.shouldShowArrow = YES;
    self._popoverData.animated = YES;
    //    self._popoverData.closesWhenPopoverResignsKey = YES;
    //    self._popoverData.closesWhenApplicationBecomesInactive = YES;
    self._popoverData.popoverMovable = YES;
    //    self._popoverData.popoverShouldDetach = YES;
    
    //    if (NSEqualRects(self.dataViewController.view.frame, contentViewRect) == NO) {
    //        [self.dataViewController.view setFrame:contentViewRect];
    //    }
    
    [self._popoverData setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationRightToLeft];
    [self showPopover:self._popoverData edgeType:FLOPopoverEdgeTypeHorizontalBelowRightEdge atSender:sender];
}

#pragma mark -
#pragma mark - Actions
#pragma mark -
- (IBAction)btnChangeMode_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"changeMode", @"object": sender}];
}

- (IBAction)btnShowWindowPopup_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"windowPopup", @"object": sender}];
}

- (IBAction)btnShowViewPopup_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"viewPopup", @"object": sender}];
}

- (IBAction)btnShowDataMix_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"mix", @"object": sender}];
}

#pragma mark -
#pragma mark - HomeViewProtocols implementation
#pragma mark -
- (void)showPopoverAtSender:(NSDictionary *)senderInfo {
    NSString *keyType = @"type";
    NSString *keyObject = @"object";
    
    if ([senderInfo objectForKey:keyObject] && [[senderInfo objectForKey:keyObject] isKindOfClass:[NSView class]]) {
        NSView *sender = (NSView *) [senderInfo objectForKey:keyObject];
        
        if ([[senderInfo objectForKey:keyType] isEqualToString:@"changeMode"]) {
            [self changeWindowMode];
        } else if ([[senderInfo objectForKey:keyType] isEqualToString:@"windowPopup"]) {
            [self showWindowPopupAtSender:sender];
        } else if ([[senderInfo objectForKey:keyType] isEqualToString:@"viewPopup"]) {
            [self showViewPopupAtSender:sender];
        } else if ([[senderInfo objectForKey:keyType] isEqualToString:@"mix"]) {
            [self showDataMixAtSender:sender];
        }
    }
}

@end
