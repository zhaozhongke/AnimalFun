//
//  UINavigationBar+CustomImage.h
//  TestDemo
//
//  Created by jack on 11-9-23.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar(CustomImage)
//- (void) setBackgroundImage:(UIImage*)image belowView:(UIButton *)belowView;
- (void) setBackgroundImage:(UIImageView*)imageView;
- (void) clearBackgroundImage;
- (void) removeIfImage:(id)sender;
- (void) showAllNavigationBarItems;
@end
