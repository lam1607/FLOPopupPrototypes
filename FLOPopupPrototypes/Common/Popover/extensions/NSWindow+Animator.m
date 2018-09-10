//
//  NSWindow+Animator.m
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 9/10/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import "NSWindow+Animator.h"

#import "FLOPopoverConstants.h"

@implementation NSWindow (Animator)

- (void)moveAnimatedFromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame {
    [self moveAnimatedFromFrame:fromFrame toFrame:toFrame duration:FLOPopoverAnimationTimeIntervalStandard source:nil];
}

- (void)moveAnimatedFromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame source:(id)source {
    [self moveAnimatedFromFrame:fromFrame toFrame:toFrame duration:FLOPopoverAnimationTimeIntervalStandard source:source];
}

- (void)moveAnimatedFromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame duration:(NSTimeInterval)duration source:(id)source {
    self.styleMask = NSWindowStyleMaskBorderless;
    self.movableByWindowBackground = YES;
    
    if (self.isVisible) {
        [self setFrame:toFrame display:NO];
        self.alphaValue = 0.0f;
    }
    
    NSString *fadeEffect = self.isVisible ? NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect;
    
    NSDictionary *effectAttr = [[NSDictionary alloc] initWithObjectsAndKeys: self, NSViewAnimationTargetKey,
                                [NSValue valueWithRect:fromFrame], NSViewAnimationStartFrameKey,
                                [NSValue valueWithRect:toFrame], NSViewAnimationEndFrameKey,
                                fadeEffect, NSViewAnimationEffectKey, nil];
    
    NSArray *effects = [[NSArray alloc] initWithObjects:effectAttr, nil];
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:effects];
    
    animation.animationBlockingMode = NSAnimationBlocking;
    animation.duration = duration;
    animation.delegate = source;
    [animation startAnimation];
}

@end
