//
//  UINavigationBar+CustomImage.m
//  TestDemo
//
//  Created by jack on 11-9-23.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)
- (void) setBackgroundImage:(UIImageView*)imageView {
    if (!imageView) return;
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
}

- (void) setBarButtonItemsImage:(UIImage*)image {
}

- (void) clearBackgroundImage {
    NSArray *subviews = [self subviews];
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i]  isMemberOfClass:[UIImageView class]]) {
            [[subviews objectAtIndex:i] removeFromSuperview];
        }
    }    
}


@end