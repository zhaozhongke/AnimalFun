//
//  DraggableCoverView.h
//  cat
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatView.h"

@interface DraggableCoverView : UIScrollView <UIGestureRecognizerDelegate>
{
    CGPoint curPoint;
    CGPoint origPoint;
    CatView *catView;
    CGFloat imageScale;
    
    CGRect catRect;
}

@property (nonatomic,retain)UIImageView* catView;
@property (nonatomic,assign) CGRect catRect;
@property (nonatomic,assign)  CGFloat imageScale;

-(id)initWithImage:(UIImage *)image targetView:(UIView *)tView;

@end
