//
//  ArticleView.h
//  cat
//
//  Created by jack on 11-9-23.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSConfig.h"

@interface ArticleView : UIImageView
{
    CGPoint curPoint;   
    UIView *targetView;
}
@property (assign) CGPoint curPoint;
@property (nonatomic,retain)UIView *targetView;

-(id)initWithImage:(UIImage *)image targetView:(UIView *)tView;

@end
