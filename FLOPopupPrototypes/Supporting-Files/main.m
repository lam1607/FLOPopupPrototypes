//
//  main.m
//  FLOPopupPrototypes
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 Floware. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[]) {
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    
    return NSApplicationMain(argc, argv);
}
