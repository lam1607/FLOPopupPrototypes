//
//  FLOGraphicsContext.m
//  Flo
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 LCL. All rights reserved.
//

#import "FLOGraphicsContext.h"

#pragma mark Graphics context creation
CGContextRef FLOCreateGraphicsContext(CGSize size, CGColorSpaceRef colorSpace) {
    size_t width = size.width;
    size_t height = size.height;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = 4 * width;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst;
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    return ctx;
}

@implementation FLOGraphicsContext
+ (NSImage *)imageRepresentationOnRect:(NSRect)rect representationWindow:(NSWindow *)representationWindow {
    // Grab the image representation of the window, without the shadows.
    CGImageRef windowImageRef = CGWindowListCreateImage(rect, kCGWindowListOptionIncludingWindow, (CGWindowID)representationWindow.windowNumber, kCGWindowImageBoundsIgnoreFraming);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(windowImageRef);
    CGSize imageSize = CGSizeMake(rect.size.width, rect.size.height);
    CGContextRef ctx = FLOCreateGraphicsContext(imageSize, colorSpace);
    
    // Draw the window image into the newly-created context.
    CGContextDrawImage(ctx, (CGRect){ .size = imageSize }, windowImageRef);
    
    CGImageRef copiedWindowImageRef = CGBitmapContextCreateImage(ctx);
    NSImage *image = [[NSImage alloc] initWithCGImage:copiedWindowImageRef size:imageSize];
    
    CGContextRelease(ctx);
    CGImageRelease(windowImageRef);
    CGImageRelease(copiedWindowImageRef);
    
    return image;
}

+ (NSImage *)screenShotView:(NSView *)aView forRect:(NSRect)aRect inWindow:(NSWindow *)aWindow {
    NSImage *imageShot;
    // screenshot osx desktop
    NSRect desktopScreen = [[NSScreen mainScreen] frame];
    NSRect windowRect = aWindow.frame;
    NSRect aViewRectInWindow = [aWindow.contentView convertRect:aView.frame toView:nil];
    CGFloat x = windowRect.origin.x + aViewRectInWindow.origin.x + aRect.origin.x;
    CGFloat y = desktopScreen.size.height - (aRect.size.height + windowRect.origin.y + aViewRectInWindow.origin.y + aRect.origin.y);
    CGFloat width = aRect.size.width;
    CGFloat height = aRect.size.height;
    
    NSRect shotRect = NSMakeRect(x, y, width, height);
    
    
    CGImageRef cgImage = CGWindowListCreateImage(shotRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    imageShot = [[NSImage alloc] init];
    [imageShot addRepresentation:rep];
    [imageShot setSize:aRect.size];
    
    return imageShot;
}

+ (NSImage *)desktopScreenShotOnFrame:(NSRect)onFrame {
    NSImage *shotImage;
    NSRect desktopScreen = [[NSScreen mainScreen] frame];
    NSRect shotRect = NSMakeRect(onFrame.origin.x, desktopScreen.size.height - (onFrame.size.height + onFrame.origin.y), onFrame.size.width, onFrame.size.height);
    CGImageRef cgImage = CGWindowListCreateImage(shotRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    shotImage = [[NSImage alloc] init];
    [shotImage addRepresentation:rep];
    [shotImage setSize:onFrame.size];
    
    return shotImage;
}

@end
