//
//  HomeViewController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 8/20/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "HomeViewController.h"

#import "AbstractWindowController.h"

#import "FilmsViewController.h"
#import "NewsViewController.h"
#import "ComicsViewController.h"
#import "TechnologiesViewController.h"
#import "TrashViewController.h"

#import "DragDroppableView.h"

#import "AppDelegate.h"

#import "AppleScript.h"

#import "HomePresenter.h"

@interface HomeViewController () <FLOPopoverDelegate, DragDropTrackingDelegate>
{
    id<HomePresenterProtocols> _presenter;
    
    FLOPopover *_popoverFilms;
    FLOPopover *_popoverNews;
    FLOPopover *_popoverComics;
    
    FilmsViewController *_filmsController;
    NewsViewController *_newsController;
    TechnologiesViewController *_technologiesController;
    ComicsViewController *_comicsController;
    TrashViewController *_trashController;
}

/// IBOutlet
///
@property (weak) IBOutlet NSView *viewMenu;

@property (weak) IBOutlet NSView *viewContainerMode;
@property (weak) IBOutlet NSButton *btnChangeMode;
@property (weak) IBOutlet NSView *viewContainerFinder;
@property (weak) IBOutlet NSButton *btnOpenFinder;
@property (weak) IBOutlet NSView *viewContainerSafari;
@property (weak) IBOutlet NSButton *btnOpenSafari;

@property (weak) IBOutlet NSView *viewContainerFilms;
@property (weak) IBOutlet NSButton *btnOpenFilms;
@property (weak) IBOutlet NSView *viewContainerNews;
@property (weak) IBOutlet NSButton *btnOpenNews;
@property (weak) IBOutlet NSView *viewContainerSecondBar;
@property (weak) IBOutlet NSButton *btnShowSecondBar;
@property (weak) IBOutlet NSView *viewContainerComics;
@property (weak) IBOutlet NSButton *btnOpenComics;

@property (weak) IBOutlet NSView *viewSecondBar;
@property (weak) IBOutlet NSLayoutConstraint *constraintVSecondBarHeight;

@property (weak) IBOutlet DragDroppableView *viewContainerTrashIcon;
@property (weak) IBOutlet NSImageView *imgTrashIcon;
@property (weak) IBOutlet NSButton *btnTrashIcon;


@property (weak) IBOutlet NSView *viewContainerTrash;

/// @property
///

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    
    [self objectsInitialize];
    [self setupUI];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
}

#pragma mark - Initialize

- (void)objectsInitialize
{
    _presenter = [[HomePresenter alloc] init];
    [_presenter attachView:self];
    
    
}

#pragma mark - Setup UI

- (void)setupUI
{
    self.constraintVSecondBarHeight.constant = 0.0;
    
    [self setupTrashView];
    [self setTrashViewHidden:YES];
}

- (void)setupTrashView
{
    [Utils setBackgroundColor:[NSColor _backgroundColor] forView:self.viewContainerTrash];
    
    if (_trashController == nil)
    {
        _trashController = [[TrashViewController alloc] initWithNibName:NSStringFromClass([TrashViewController class]) bundle:nil];
    }
    
    if (![_trashController.view isDescendantOf:self.viewContainerTrash])
    {
        [self addView:_trashController.view toParent:self.viewContainerTrash];
    }
}

- (void)refreshUIColors
{
    if ([self.view.effectiveAppearance.name isEqualToString:[NSAppearance currentAppearance].name])
    {
        [super refreshUIColors];
        
#ifdef kFlowarePopover_UseAssetColors
        [Utils setBackgroundColor:[NSColor _backgroundColor] forView:self.viewMenu];
        
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerMode];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerFinder];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerSafari];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerFilms];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerNews];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerSecondBar];
        [Utils setBackgroundColor:[NSColor _grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerComics];
        
        [Utils setTitle:@"Films popup" color:[NSColor _textWhiteColor] forControl:self.btnOpenFilms];
        [Utils setTitle:@"News popup" color:[NSColor _textWhiteColor] forControl:self.btnOpenNews];
        [Utils setTitle:@"Show second bar" color:[NSColor _textWhiteColor] forControl:self.btnShowSecondBar];
        [Utils setTitle:@"Comics popup" color:[NSColor _textWhiteColor] forControl:self.btnOpenComics];
        
        [Utils setBackgroundColor:[NSColor _backgroundColor] forView:self.viewSecondBar];
#else
        [Utils setBackgroundColor:[NSColor backgroundColor] forView:self.viewMenu];
        
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerMode];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerFinder];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerSafari];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerFilms];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerNews];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerSecondBar];
        [Utils setBackgroundColor:[NSColor grayColor] cornerRadius:[CORNER_RADIUSES[0] doubleValue] forView:self.viewContainerComics];
        
        [Utils setTitle:@"Films popup" color:[NSColor textWhiteColor] forControl:self.btnOpenFilms];
        [Utils setTitle:@"News popup" color:[NSColor textWhiteColor] forControl:self.btnOpenNews];
        [Utils setTitle:@"Show second bar" color:[NSColor textWhiteColor] forControl:self.btnShowSecondBar];
        [Utils setTitle:@"Comics popup" color:[NSColor textWhiteColor] forControl:self.btnOpenComics];
        
        [Utils setBackgroundColor:[NSColor backgroundColor] forView:self.viewSecondBar];
#endif
    }
}

#pragma mark - Local methods

- (void)changeWindowMode
{
    Settings *settings = [Settings sharedInstance];
    
    [settings changeMode:[settings nextMode]];
}

- (void)openEntitlementApplicationWithIdentifier:(NSString *)appIdentifier
{
    NSURL *appUrl = [NSURL fileURLWithPath:[[EntitlementsManager sharedInstance] getAppPathWithIdentifier:appIdentifier]];
    
    if (![[NSWorkspace sharedWorkspace] launchApplicationAtURL:appUrl options:NSWorkspaceLaunchDefault configuration:[NSDictionary dictionary] error:NULL]) {
        // If the application cannot be launched, then re-launch it by script
        NSString *appName = [[EntitlementsManager sharedInstance] getAppNameWithIdentifier:appIdentifier];
        script_openApp(appName, YES);
    }
    
    [[EntitlementsManager sharedInstance] activateWithBundleIdentifier:appIdentifier];
}

- (void)observeComicsViewContentSizeChange
{
    if (_comicsController)
    {
        __weak typeof(self) wself = self;
        
        _comicsController.didContentSizeChange = ^(NSSize newSize) {
            [wself handleComicsViewContentSizeChanging:newSize];
        };
    }
}

- (void)handleComicsViewContentSizeChanging:(NSSize)newSize
{
    if (_comicsController)
    {
        NSRect visibleRect = [self.view visibleRect];
        CGFloat menuHeight = self.viewMenu.frame.size.height;
        CGFloat secondBarHeight = self.constraintVSecondBarHeight.constant;
        CGFloat verticalMargin = 10.0;
        CGFloat availableHeight = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin;
        CGFloat contentViewWidth = 350.0;
        CGFloat contentViewHeight = (newSize.height > availableHeight) ? availableHeight : newSize.height;
        NSRect contentViewRect = _comicsController.view.frame;
        
        contentViewRect = NSMakeRect(contentViewRect.origin.x, contentViewRect.origin.y, contentViewWidth, contentViewHeight);
        
        [_popoverComics setPopoverContentViewSize:contentViewRect.size];
    }
}

- (void)handleShowSecondBar
{
    if (_comicsController)
    {
        CGFloat secondBarHeight = self.constraintVSecondBarHeight.constant;
        
        if (secondBarHeight < 40.0)
        {
            secondBarHeight = 40.0;
        }
        else
        {
            secondBarHeight = 0.0;
        }
        
        self.constraintVSecondBarHeight.constant = secondBarHeight;
        
        [self.viewSecondBar setNeedsUpdateConstraints:YES];
        [self.viewSecondBar updateConstraints];
        [self.viewSecondBar updateConstraintsForSubtreeIfNeeded];
        [self.viewSecondBar layoutSubtreeIfNeeded];
        
        NSRect visibleRect = [self.view visibleRect];
        CGFloat menuHeight = self.viewMenu.frame.size.height;
        CGFloat verticalMargin = 10.0;
        CGFloat availableHeight = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin;
        CGFloat contentHeight = [_comicsController getContentSizeHeight];
        CGFloat contentViewWidth = 350.0;
        CGFloat contentViewHeight = (contentHeight > availableHeight) ? availableHeight : contentHeight;
        NSRect contentViewRect = NSMakeRect(0.0, 0.0, contentViewWidth, contentViewHeight);
        
        CGFloat positioningRectX = visibleRect.size.width - contentViewRect.size.width - verticalMargin / 2;
        CGFloat positioningRectY = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin / 2;
        NSRect positioningRect = [self.view.window convertRectToScreen:NSMakeRect(positioningRectX, positioningRectY, 0.0, 0.0)];
        
        [_popoverComics setPopoverContentViewSize:contentViewRect.size positioningRect:positioningRect];
    }
}

- (void)setLevelForPopover:(FLOPopover *)popover
{
    [popover setPopoverLevel:[[WindowManager sharedInstance] levelForTag:popover.tag]];
}

- (void)showRelativeToRectOfViewWithPopover:(FLOPopover *)popover edgeType:(FLOPopoverEdgeType)edgeType atView:(NSView *)sender
{
    NSRect rect = (sender.superview != nil) ? sender.superview.bounds : sender.bounds;
    
    if (popover.delegate == nil)
    {
        popover.delegate = self;
    }
    
    [self setLevelForPopover:popover];
    [popover showRelativeToRect:rect ofView:sender edgeType:edgeType];
}

- (void)showRelativeToViewWithRect:(NSRect)rect byPopover:(FLOPopover *)popover sender:(NSView *)sender
{
    if (popover.delegate == nil)
    {
        popover.delegate = self;
    }
    
    [self setLevelForPopover:popover];
    [popover showRelativeToView:sender withRect:rect];
}

- (void)showFilmsPopupAtView:(NSView *)sender
{
    if ([_popoverFilms isShown])
    {
        [_popoverFilms close];
        return;
    }
    
    NSRect visibleRect = [self.view visibleRect];
    CGFloat menuHeight = self.viewMenu.frame.size.height;
    CGFloat verticalMargin = 10.0;
    CGFloat width = 0.5 * visibleRect.size.width;
    CGFloat height = visibleRect.size.height - menuHeight - verticalMargin;
    NSRect contentViewRect = NSMakeRect(0.0, 0.0, width, height);
    
    if (_popoverFilms == nil)
    {
        _filmsController = [[FilmsViewController alloc] initWithNibName:NSStringFromClass([FilmsViewController class]) bundle:nil];
        [_filmsController.view setFrame:contentViewRect];
        
        _popoverFilms = [[FLOPopover alloc] initWithContentViewController:_filmsController type:FLOViewPopover];
    }
    
    _popoverFilms.animated = YES;
    _popoverFilms.closesWhenPopoverResignsKey = YES;
    //    _popoverFilms.closesWhenApplicationBecomesInactive = YES;
    _popoverFilms.becomesKeyOnMouseOver = YES;
    _popoverFilms.isMovable = YES;
    _popoverFilms.isDetachable = YES;
    
    _popoverFilms.tag = WindowLevelGroupTagFloat;
    
    //    [_popoverFilms setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationLeftToRight];
    [_popoverFilms setAnimationBehaviour:FLOPopoverAnimationBehaviorTransform type:FLOPopoverAnimationScale];
    
    [self showRelativeToRectOfViewWithPopover:_popoverFilms edgeType:FLOPopoverEdgeTypeBelowLeftEdge atView:sender];
}

- (void)showNewsPopupAtView:(NSView *)sender
{
    if ([_popoverNews isShown])
    {
        [_popoverNews close];
        return;
    }
    
    NSRect visibleRect = [self.view visibleRect];
    CGFloat menuHeight = self.viewMenu.frame.size.height;
    CGFloat verticalMargin = 10.0;
    CGFloat width = 0.5 * visibleRect.size.width;
    CGFloat height = visibleRect.size.height - menuHeight - verticalMargin;
    NSRect contentViewRect = NSMakeRect(0.0, 0.0, width, height);
    
    if (_popoverNews == nil)
    {
        _newsController = [[NewsViewController alloc] initWithNibName:NSStringFromClass([NewsViewController class]) bundle:nil];
        [_newsController.view setFrame:contentViewRect];
        
        _popoverNews = [[FLOPopover alloc] initWithContentViewController:_newsController];
    }
    
    _popoverNews.animated = YES;
    //    _popoverNews.closesWhenPopoverResignsKey = YES;
    //    _popoverNews.closesWhenApplicationBecomesInactive = YES;
    //    _popoverNews.closesAfterTimeInterval = 3.0;
    //    _popoverNews.disableTimeIntervalOnMoving = YES;
    _popoverNews.becomesKeyOnMouseOver = YES;
    _popoverNews.isMovable = YES;
    _popoverNews.isDetachable = YES;
    
    _popoverNews.tag = WindowLevelGroupTagFloat;
    
    [_popoverNews setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationLeftToRight];
    
    [self showRelativeToRectOfViewWithPopover:_popoverNews edgeType:FLOPopoverEdgeTypeBelowLeftEdge atView:sender];
}

- (void)showComicsPopupAtView:(NSView *)sender option:(NSInteger)option
{
    if ([_popoverComics isShown])
    {
        [_popoverComics close];
        return;
    }
    
    if (option == 1)
    {
        NSRect visibleRect = [self.view visibleRect];
        CGFloat menuHeight = self.viewMenu.frame.size.height;
        CGFloat secondBarHeight = self.constraintVSecondBarHeight.constant;
        CGFloat verticalMargin = 10.0;
        CGFloat contentViewWidth = 350.0;
        CGFloat minHeight = 429.0;
        CGFloat availableHeight = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin;
        CGFloat contentHeight = [_comicsController getContentSizeHeight];
        CGFloat contentViewHeight = (contentHeight > availableHeight) ? availableHeight : ((contentHeight >= minHeight) ? contentHeight : minHeight);
        NSRect contentViewRect = NSMakeRect(0.0, 0.0, contentViewWidth, contentViewHeight);
        
        if (_popoverComics == nil)
        {
            _comicsController = [[ComicsViewController alloc] initWithNibName:NSStringFromClass([ComicsViewController class]) bundle:nil];
            [_comicsController.view setFrame:contentViewRect];
            
            //            _popoverComics = [[FLOPopover alloc] initWithContentViewController:_comicsController];
            //            _popoverComics = [[FLOPopover alloc] initWithContentViewController:_comicsController type:FLOViewPopover];
            _popoverComics = [[FLOPopover alloc] initWithContentView:_comicsController.view];
            //            _popoverComics = [[FLOPopover alloc] initWithContentView:_comicsController.view type:FLOViewPopover];
        }
        
        _popoverComics.animated = YES;
        //        _popoverComics.animatedForwarding = YES;
        //        _popoverComics.animatedByMovingFrame = YES;
        _popoverComics.shouldChangeSizeWhenApplicationResizes = YES;
        //        _popoverComics.closesWhenPopoverResignsKey = YES;
        //        _popoverComics.closesWhenApplicationBecomesInactive = YES;
        _popoverComics.isMovable = YES;
        _popoverComics.isDetachable = YES;
        
        CGFloat positioningRectX = visibleRect.size.width - contentViewRect.size.width - verticalMargin / 2;
        CGFloat positioningRectY = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin / 2;
        NSRect positioningRect = [sender.window convertRectToScreen:NSMakeRect(positioningRectX, positioningRectY, 0.0, 0.0)];
        
        _popoverComics.tag = WindowLevelGroupTagSetting;
        
        [_popoverComics setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationRightToLeft animatedInAppFrame:YES];
        
        // MUST call the didContentSizeChange block before popover makes displaying.
        // To update the content view frame before capturing image for animation.
        [self observeComicsViewContentSizeChange];
        
        [self showRelativeToViewWithRect:positioningRect byPopover:_popoverComics sender:sender];
    }
    else
    {
        NSRect visibleRect = [self.view visibleRect];
        CGFloat menuHeight = self.viewMenu.frame.size.height;
        CGFloat secondBarHeight = self.constraintVSecondBarHeight.constant;
        CGFloat verticalMargin = 10.0;
        CGFloat width = 350.0;
        CGFloat height = visibleRect.size.height - menuHeight - secondBarHeight - verticalMargin;
        NSRect contentViewRect = NSMakeRect(0.0, 0.0, width, height);
        
        if (_popoverComics == nil)
        {
            _technologiesController = [[TechnologiesViewController alloc] initWithNibName:NSStringFromClass([TechnologiesViewController class]) bundle:nil];
            [_technologiesController.view setFrame:contentViewRect];
            
            _popoverComics = [[FLOPopover alloc] initWithContentViewController:_technologiesController];
        }
        
        _popoverComics.shouldShowArrow = YES;
        _popoverComics.animated = YES;
        _popoverComics.shouldChangeSizeWhenApplicationResizes = NO;
        //        _popoverComics.closesWhenPopoverResignsKey = YES;
        //        _popoverComics.closesWhenApplicationBecomesInactive = YES;
        _popoverComics.isMovable = YES;
        _popoverComics.isDetachable = YES;
        _popoverComics.staysInContainer = YES;
        
        _popoverComics.tag = WindowLevelGroupTagSetting;
        
        [_popoverComics setAnimationBehaviour:FLOPopoverAnimationBehaviorTransition type:FLOPopoverAnimationLeftToRight];
        
        [self showRelativeToRectOfViewWithPopover:_popoverComics edgeType:FLOPopoverEdgeTypeForwardTopEdge atView:sender];
    }
}

- (void)setTrashViewHidden:(BOOL)isHidden
{
    [self.viewContainerTrash setHidden:isHidden];
}

#pragma mark - Actions

- (IBAction)btnChangeMode_clicked:(NSButton *)sender
{
    [_presenter changeWindowMode];
}

- (IBAction)btnOpenFinder_clicked:(NSButton *)sender
{
    [_presenter openFinder];
}

- (IBAction)btnOpenSafari_clicked:(NSButton *)sender
{
    [_presenter openSafari];
}

- (IBAction)btnOpenFilms_clicked:(NSButton *)sender
{
    [_presenter openFilmsView];
}

- (IBAction)btnOpenNews_clicked:(NSButton *)sender
{
    [_presenter openNewsView];
}

- (IBAction)btnShowSecondBar_clicked:(NSButton *)sender
{
    [_presenter showSecondBar];
}

- (IBAction)btnOpenComics_clicked:(NSButton *)sender
{
    [_presenter openComicsView];
}

- (IBAction)btnTrashIcon_clicked:(NSButton *)sender
{
    [_presenter showTrashView];
}

#pragma mark - FLOPopoverDelegate

- (void)floPopoverWillShow:(FLOPopover *)popover
{
}

- (void)floPopoverDidShow:(FLOPopover *)popover
{
}

- (void)floPopoverWillClose:(FLOPopover *)popover
{
}

- (void)floPopoverDidClose:(FLOPopover *)popover
{
    // @warning: MUST set the popover to nil for completely deallocating the content view or content view controller, when popover closed.
    if (popover == _popoverFilms)
    {
        _popoverFilms = nil;
    }
    else if (popover == _popoverNews)
    {
        _popoverNews = nil;
    }
    else if (popover == _popoverComics)
    {
        _popoverComics = nil;
    }
}

#pragma mark - HomeViewProtocols implementation

- (void)viewDidSelectWindowModeChanging
{
    [self changeWindowMode];
}

- (void)viewShouldOpenFinder
{
    [self openEntitlementApplicationWithIdentifier:kFlowarePopover_BundleIdentifier_Finder];
}

- (void)viewShouldOpenSafari
{
    [self openEntitlementApplicationWithIdentifier:kFlowarePopover_BundleIdentifier_Safari];
}

- (void)viewShouldOpenFilmsView
{
    [self showFilmsPopupAtView:self.btnOpenFilms];
}

- (void)viewShouldOpenNewsView
{
    [self showNewsPopupAtView:self.btnOpenNews];
}

- (void)viewShouldOpenComicsView
{
    [self showComicsPopupAtView:self.btnOpenComics option:0];
}

- (void)viewShouldShowSecondBar
{
    [self handleShowSecondBar];
}

- (void)viewShouldShowTrashView
{
    [self setTrashViewHidden:!self.viewContainerTrash.isHidden];
}

@end
