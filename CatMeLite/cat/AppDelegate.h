//
//  AppDelegate.h
//  cat
//
//  Created by jack on 11-9-17.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appirater.h"
#import "SHK.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
     UINavigationController *nav;
}

@property (nonatomic,retain) UIWindow *window;
@property(nonatomic,retain) UINavigationController *nav;

@end
