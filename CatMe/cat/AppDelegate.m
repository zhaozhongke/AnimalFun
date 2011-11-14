//
//  AppDelegate.m
//  article
//
//  Created by jack on 11-9-17.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"header_bar_bg.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation AppDelegate


@synthesize window = _window;
@synthesize nav;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    nav=[[UINavigationController alloc]init];
    UIImageView  *backImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header_bar_bg.png"]];
    backImageView.tag=100;
    
    [nav.navigationBar performSelectorInBackground:@selector(setBackgroundImage:) withObject:backImageView];
   
    
    ViewController *mainView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil]; 
    
    [nav pushViewController:mainView animated:NO];
    
    [self.window addSubview:nav.view];
    [self.window makeKeyAndVisible];
    
    [mainView release];
    [backImageView release];
    
    [Appirater appLaunched:YES];
//    [self performSelector:@selector(testOffline) withObject:nil afterDelay:1];
    return YES;
}
- (void)testOffline
{	
	[SHK flushOfflineQueue];
}


-(void)dealloc{
    [_window release];
    [nav release];
    [super release];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
