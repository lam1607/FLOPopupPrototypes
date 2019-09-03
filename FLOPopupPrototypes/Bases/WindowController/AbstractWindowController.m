//
//  AbstractWindowController.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 1/3/19.
//  Copyright © 2019 Floware Inc. All rights reserved.
//

#import "AbstractWindowController.h"

#import "AppDelegate.h"

#import "AppleScript.h"

@interface AbstractWindowController ()
{
    NSRect _normalFrame;
    CGFloat _titleBarHeight;
}

/// @property
///

@end

static AbstractWindowController *_sharedInstance = nil;

@implementation AbstractWindowController

#pragma mark - Singleton

+ (AbstractWindowController *)sharedInstance
{
    return _sharedInstance;
}

#pragma mark - Window lifecycle

- (void)awakeFromNib
{
    _sharedInstance = self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self setupUI];
    [self registerEventMonitor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter/Setter

- (NSRect)normalFrame
{
    return _normalFrame;
}

- (CGFloat)titleBarHeight
{
    return _titleBarHeight;
}

- (void)setTitleBarHeight
{
    _titleBarHeight = NSHeight([self window].frame) - NSHeight([[self window] contentView].frame);
}

#pragma mark - Setup UI

- (void)setupUI
{
    NSRect visibleFrame = [[[self window] screen] visibleFrame];
    CGFloat width = 0.5 * visibleFrame.size.width;
    CGFloat height = 0.6 * visibleFrame.size.height;
    CGFloat x = (visibleFrame.size.width - width) / 2;
    CGFloat y = (visibleFrame.size.height + visibleFrame.origin.y - height) / 2;
    NSRect viewFrame = NSMakeRect(x, y, width, height);
    
    [[self window] setFrame:viewFrame display:YES];
    [[self window] setMinSize:NSMakeSize(680.0, 484.0)];
}

#pragma mark - Local methods

- (void)activate
{
    [self.window makeKeyAndOrderFront:nil];
}

- (void)changeToDesktopMode
{
    [[self window] setTitleVisibility:NSWindowTitleHidden];
    [[self window] setStyleMask:NSWindowStyleMaskBorderless];
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] setLevel:[[WindowManager sharedInstance] levelForTag:WindowLevelGroupTagDesktop]];
    [[self window] setFrame:[[[self window] screen] visibleFrame] display:YES animate:YES];
}

- (void)changeToNormalMode
{
    [[self window] setTitleVisibility:NSWindowTitleVisible];
    [[self window] setStyleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable)];
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] setLevel:[[WindowManager sharedInstance] levelForTag:WindowLevelGroupTagNormal]];
    [[self window] setFrame:self.normalFrame display:YES animate:YES];
}

- (void)showChildWindowsOnActivate
{
    for (NSWindow *childWindow in self.window.childWindows)
    {
        NSWindowLevel level = [[WindowManager sharedInstance] levelForTag:WindowLevelGroupTagFloat];
        
        if ([childWindow isKindOfClass:[FLOPopoverWindow class]])
        {
            level = [[WindowManager sharedInstance] levelForTag:((FLOPopoverWindow *)childWindow).tag];
        }
        
        [childWindow setLevel:level];
        [[childWindow attachedSheet] setLevel:(childWindow.level + 1)];
    }
}

- (void)hideChildWindowsOnDeactivate
{
    if ([[NSApplication sharedApplication] isHidden] || [[NSApplication sharedApplication] isHidden]) return;
    
    BOOL shouldChildWindowsFloat = [WindowManager sharedInstance].shouldChildWindowsFloat;
    NSWindowLevel levelNormal = [[WindowManager sharedInstance] levelForTag:WindowLevelGroupTagNormal];
    
    for (NSWindow *childWindow in [[self window] childWindows])
    {
        if (childWindow.level != levelNormal)
        {
            [childWindow setLevel:levelNormal];
            // Should keep the line below, to make sure that the child window will 'sink' successfully.
            // Otherwise, the child window still floats even the level is NSNormalWindowLevel.
            [childWindow orderFront:[self window]];
        }
    }
    
    // If we want some child windows float on other active application. Do it here
    if (shouldChildWindowsFloat)
    {
    }
}

- (void)hideOtherAppsExceptThoseInside
{
    script_hideAllAppsExcept(kFlowarePopover_BundleIdentifier_Finder, kFlowarePopover_BundleIdentifier_Safari);
}

#pragma mark - Event handles

- (void)windowDidChangeMode:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:kFlowarePopover_WindowDidChangeModeNotification])
    {
        FLOWindowMode oldMode = [[[notification userInfo] objectForKey:@"original"] integerValue];
        
        if (oldMode == FLOWindowModeNormal)
        {
            _normalFrame = self.window.frame;
        }
        
        if ([[Settings sharedInstance] isDesktopMode])
        {
            [self changeToDesktopMode];
            script_hideAllApps();
        }
        else
        {
            [self changeToNormalMode];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"effectiveAppearance"] && [[change objectForKey:@"new"] isKindOfClass:[NSAppearance class]])
    {
        [NSAppearance setCurrentAppearance:[change objectForKey:@"new"]];
    }
}

#pragma mark - Event monitor

- (void)registerEventMonitor
{
    [self registerWindowChangeModeEvent];
    [self registerApplicationAppearanceNotification];
}

- (void)registerWindowChangeModeEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeMode:) name:kFlowarePopover_WindowDidChangeModeNotification object:nil];
}

- (void)removeWindowChangeModeEvent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFlowarePopover_WindowDidChangeModeNotification object:nil];
}

- (void)registerApplicationAppearanceNotification
{
    [[[self window] contentView] addObserver:self forKeyPath:@"effectiveAppearance"
                                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                     context:NULL];
}

- (void)unregisterApplicationAppearanceNotification
{
    [[[self window] contentView] removeObserver:self forKeyPath:@"effectiveAppearance"];
}

@end
