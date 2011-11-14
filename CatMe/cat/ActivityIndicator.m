//
//  ActivityIndicator.m
//  PhotoMaker
//
//  Created by user on 10/23/11.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "ActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "TSConfig.h"

#define activityIndicatorFrame (IsIpad ? CGRectMake(0, 0, 200, 200): CGRectMake(0, 0, 108, 108))
#define activityIndicatorCenter (IsIpad ? CGPointMake(384, 394): CGPointMake(160, 165))
#define activityIndicatorIconHeight (IsIpad ? 56.0f: 32.0f)
#define offset (IsIpad? 42.0f: 20.0f)
#define labelFontSize (IsIpad? 25.0f: 15.0f)

@implementation ActivityIndicator

@synthesize  ai;

-(id)initWithTitle:(NSString *) title{
    ai=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   
    CGRect    _frame=activityIndicatorFrame;
    
    if(self=[super initWithFrame:_frame]){
        
        CGRect frame= ai.frame;
        frame.origin=CGPointMake((_frame.size.width-frame.size.width)/2, offset);
        ai.frame=frame;
        
        self.center=activityIndicatorCenter;
        self.layer.cornerRadius=12;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.7]];
        
        UILabel *processingText=[[UILabel alloc]init ];
        CGRect frame2= processingText.frame;
        frame2.size=CGSizeMake(_frame.size.width, activityIndicatorIconHeight);
        frame2.origin.y=self.frame.size.height-self.ai.frame.size.height-(IsIpad?offset:0);
        
        processingText.frame=frame2;
        [processingText setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
        [processingText setText:title ?title: @"Processing…"];
        [processingText setTextColor:[UIColor whiteColor]];
        [processingText setFont:[UIFont boldSystemFontOfSize:labelFontSize]];
        [processingText setTextAlignment:UITextAlignmentCenter];
        
        [self addSubview:ai];
        [self addSubview:processingText];
        [self bringSubviewToFront:processingText];
        
        [processingText release];
    }
    
    return self;
}

- (void)dealloc {
    [ai release];
    [super dealloc];
}
-(void)startAnimatingInView:(UIView *)_view{
    [_view addSubview:self];
    [self.ai startAnimating];
}
-(void)stopAnimating{
    [self.ai stopAnimating];
    [self removeFromSuperview];
}

@end
