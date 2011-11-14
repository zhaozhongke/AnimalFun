//
//  CommonUtils.m
//  Article
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(UIButton *)buttonWithImageAndText:(UIImage *)buttonImage buttonText:(NSString *)buttonText target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    //added (tony)
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithRed:(102* 1.0)/255  green:(79* 1.0)/255 blue:(64* 1.0)/255 alpha: 1.0] forState:UIControlStateNormal];
    
    return [button autorelease];

}
+(UIImage *)addText:(UIImage *)img text:(NSString *)text1{
    int w = img.size.width;
    int h = img.size.height; 
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Arial", 22, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFillStrokeClip);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	
    
    //rotate text
    //    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
    CGContextShowTextAtPoint(context, 14, 4, text, strlen(text));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
  
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    UIImage *newimage=[UIImage imageWithCGImage:imageMasked];
    CFRelease(imageMasked);
    return newimage;
}
+(UIImage *)addImage:(UIImage *)img withImage:(UIImage *)addedImage isCovered:(BOOL)isCovered{
    int w = img.size.width;
    int h = img.size.height; 
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    if(isCovered){
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), addedImage.CGImage);
    }else{
        CGContextDrawImage(context, CGRectMake(68, 79, 28, 17), addedImage.CGImage);
    }

    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newimage=[UIImage imageWithCGImage:imageMasked];
    CFRelease(imageMasked);
    return newimage;
}


+ (void) showAllNavigationBarItems:(UIViewController *)nvc{

    [[nvc.navigationItem.rightBarButtonItem.customView superview] bringSubviewToFront:nvc.navigationItem.rightBarButtonItem.customView];
    
    [nvc.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:nvc.navigationItem.leftBarButtonItem.customView];
    
//    [nvc.navigationController.navigationBar sendSubviewToBack:backGroundImageView];
    
}

@end
