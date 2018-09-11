//
//  NSWindow+Animator.h
//  FLOPopupPrototypes
//
//  Created by lamnguyen on 9/10/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Animator)

- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame;
- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame source:(id)source;
- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame duration:(NSTimeInterval)duration source:(id)source;

@end
