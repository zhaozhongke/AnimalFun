//
//  CatView.m
//  cat
//
//  Created by jack on 11-9-23.
//  Copyright (c) 2011 TactSky. All rights reserved.
//
#define CATSCALE (IsIpad?1.2f:.7f)

#define catOriginPoint (IsIpad?CGPointMake(200,200):CGPointMake(60,60))
#define ZOOM_VIEW_TAG 100

#import "ArticleView.h"

@implementation ArticleView
@synthesize  curPoint,targetView;

-(id)initWithImage:(UIImage *)image targetView:(UIView *)tView{
    if(self= [super initWithImage:image]){
        self.userInteractionEnabled=YES;
        self.targetView=tView;
        
        CGRect catRect=CGRectMake(catOriginPoint.x,catOriginPoint.y, image.size.width*CATSCALE, image.size.height*CATSCALE);
        self.frame=catRect;
        self.image=image;
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled=YES;
        // set the tag for the image view
        [self setTag:ZOOM_VIEW_TAG];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    curPoint=[[touches anyObject] locationInView:self];
   
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    
    
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - curPoint.x),
                                   self.center.y + (activePoint.y - curPoint.y));
    
//    printf("activePoint x %0.0f,y %0.0f;",newPoint.x,newPoint.y);
//    printf("newPoint x %0.0f,y %0.0f",newPoint.x,newPoint.y);
//    printf("\n");
    // Set new center location
    self.center = newPoint;
}

- (void)dealloc {
    [super dealloc];
}
@end
