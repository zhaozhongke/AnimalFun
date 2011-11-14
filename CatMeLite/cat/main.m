//
//  main.m
//  cat
//
//  Created by jack on 11-9-17.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *autoreleasepool=[[NSAutoreleasePool alloc]init]; 
    int ret=UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    [autoreleasepool release];
    return ret;
}
