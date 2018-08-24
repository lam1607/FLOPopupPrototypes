//
//  HomeViewController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "HomeViewController.h"

#import "NewsViewController.h"
#import "DataViewController.h"

#import "FLOPopover.h"

@interface HomeViewController ()

@property (weak) IBOutlet NSView *vMenu;
@property (weak) IBOutlet NSView *vShowWindowPopup;
@property (weak) IBOutlet NSButton *btnShowWindowPopup;
@property (weak) IBOutlet NSView *vShowViewPopup;
@property (weak) IBOutlet NSButton *btnShowViewPopup;
@property (weak) IBOutlet NSView *vShowDataMix;
@property (weak) IBOutlet NSButton *btnShowDataMix;

@property (nonatomic, strong) HomePresenter *_homePresenter;

@property (nonatomic, strong) FLOPopover *_popoverNews;
@property (nonatomic, strong) FLOPopover *_popoverData;

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
- (void)showPopover:(FLOPopover *)aPopover preferredEdge:(NSRectEdge)preferredEdge atSender:(NSView *)sender {
    __block FLOPopover *_aPopover = aPopover;
    
    NSView *positioningView = ((sender.superview != nil) ? sender.superview : sender);
    NSRect positioningRect = positioningView.bounds;
    
    [_aPopover showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
}

//    NSRectEdgeMinX = CGRectMinXEdge,
//    NSRectEdgeMinY = CGRectMinYEdge,
//    NSRectEdgeMaxX = CGRectMaxXEdge,
//    NSRectEdgeMaxY = CGRectMaxYEdge,

- (void)showWindowPopupAtSender:(NSView *)sender {
    DLog(@"showWindowPopupAtSender %@", sender);
}

- (void)showViewPopupAtSender:(NSView *)sender {
    if (!self._popoverNews) {
        NewsViewController *viewcontroller = [[NewsViewController alloc] initWithNibName:NSStringFromClass([NewsViewController class]) bundle:nil];
        NSRect viewframe = [self.view visibleRect];
        CGFloat menuHeight = self.vMenu.frame.size.height;
        CGFloat width = 500.0f;
        CGFloat height = viewframe.size.height - menuHeight;
        [viewcontroller.view setFrame:NSMakeRect(0.0f, 0.0f, width, height)];
        
        self._popoverNews = [[FLOPopover alloc] initWithContentViewController:viewcontroller popoverType:FLOViewPopover];
    }
    
    self._popoverNews.closesWhenPopoverResignsKey = YES;
    //    self._popoverNews.closesWhenApplicationBecomesInactive = YES;
    self._popoverNews.showArrow = YES;
    
    [self showPopover:self._popoverNews preferredEdge:NSRectEdgeMinY atSender:sender];
}

- (void)showDataMixAtSender:(NSView *)sender {
    if (!self._popoverData) {
        DataViewController *viewcontroller = [[DataViewController alloc] initWithNibName:NSStringFromClass([DataViewController class]) bundle:nil];
        NSRect viewframe = [self.view visibleRect];
        CGFloat menuHeight = self.vMenu.frame.size.height;
        CGFloat width = 300.0f;
        CGFloat height = viewframe.size.height - menuHeight;
        [viewcontroller.view setFrame:NSMakeRect(0.0f, 0.0f, width, height)];
        
        self._popoverData = [[FLOPopover alloc] initWithContentViewController:viewcontroller popoverType:FLOWindowPopover];
    }
    
    //    self._popoverData.closesWhenPopoverResignsKey = YES;
    //    self._popoverData.closesWhenApplicationBecomesInactive = YES;
    //    self._popoverData.showArrow = YES;
    
    [self showPopover:self._popoverData preferredEdge:NSRectEdgeMaxX atSender:sender];
}

#pragma mark -
#pragma mark - Actions
#pragma mark -
- (IBAction)btnShowWindowPopup_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"main", @"object": sender}];
}

- (IBAction)btnShowViewPopup_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"settings", @"object": sender}];
}

- (IBAction)btnShowDataMix_clicked:(NSButton *)sender {
    [self._homePresenter doSelectSender:@{@"type": @"data", @"object": sender}];
}

#pragma mark -
#pragma mark - HomeViewProtocols implementation
#pragma mark -
- (void)showViewAtSender:(NSDictionary *)senderInfo {
    NSString *keyType = @"type";
    NSString *keyObject = @"object";
    
    if ([senderInfo objectForKey:keyObject] && [[senderInfo objectForKey:keyObject] isKindOfClass:[NSView class]]) {
        NSView *sender = (NSView *) [senderInfo objectForKey:keyObject];
        
        if ([[senderInfo objectForKey:keyType] isEqualToString:@"main"]) {
            [self showWindowPopupAtSender:sender];
        } else if ([[senderInfo objectForKey:keyType] isEqualToString:@"settings"]) {
            [self showViewPopupAtSender:sender];
        } else if ([[senderInfo objectForKey:keyType] isEqualToString:@"data"]) {
            [self showDataMixAtSender:sender];
        }
    }
}

@end
