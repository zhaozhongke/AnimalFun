//
//  DraggableImageView.m
//  cat
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "DraggableImageView.h"
#import "ArticleViewController.h"
#import "TSStoreManager.h"
#import "TouchCatView.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>


@implementation DraggableImageView

@synthesize targetView,catDelegate;

-(id)initWithImage:(UIImage *)image isPurchased:(BOOL)isPurchased tag:(int)tag{
    if(self= [super initWithImage:image]){
        self.userInteractionEnabled=YES;
    }
    if(IsAppSupportIAP &&!isPurchased && tag>TSFreeIconCount){
        self.image=[CommonUtils addImage:self.image withImage:[UIImage imageNamed:@"cover.png"] isCovered:YES];
        self.image= [CommonUtils addImage:self.image withImage:[UIImage imageNamed:@"dollar.png"] isCovered:NO];
    }
    self.layer.cornerRadius=6;
    self.layer.masksToBounds = YES;
    self.layer.opaque = NO;
    return self;
}


-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.userInteractionEnabled=YES;
        self.layer.cornerRadius=6;
        self.layer.masksToBounds = YES;
        self.layer.opaque = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [super touchesBegan:touches withEvent:event];
    
    ArticleViewController *fvc=(ArticleViewController *)(self.catDelegate);
   
    DraggableImageView *div=(DraggableImageView *)(((UITouch*)[touches anyObject]).view);
      
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isFeatureCatsPurchased=[userDefaults boolForKey:featureCatsId];
  
    if(IsAppSupportIAP && isFeatureCatsPurchased==NO  && div.tag>TSFreeIconCount ){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"More Cats" message:
                                [NSString stringWithFormat:@"Do you want access to %d %@s?" ,TSTotalIcons,TSArticle] delegate:fvc cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        //UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"PhotoMaker" message:@"Do you want access to 100 cats?" delegate:fvc cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag=CATPURCHASEALERTVIEWTAG;
        [alertView autorelease];
        [alertView show];
        return;
    }else{
        //add filtericon filterSelectedView
        CGRect selectIconFrame=div.frame;
        
        CGFloat borderImageWidth=3.0f;
        
        fvc.catIconBorderView.frame=CGRectMake(selectIconFrame.origin.x-borderImageWidth, selectIconFrame.origin.y-borderImageWidth, kScrollObjWidth+borderImageWidth*2, kScrollObjWidth+borderImageWidth*2);  
      
        [fvc.scrollView1 insertSubview:fvc.catIconBorderView belowSubview:div];
    }

 
//    [fvc clearCatView];
    
    ArticleView *catView=[[ArticleView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cat%d",div.tag]] targetView:(UIView *)fvc.imageView ];
    
    fvc.imageView.catView=catView;
//    
//    fvc.catView=catView;
//    [fvc.imageView bringSubviewToFront:fvc.catView];
//  
//    
    [catView release];

//    [[fvc.scrollView1 superview] bringSubviewToFront:fvc.scrollView1];
    
}
- (void)dealloc {
    [targetView release];
    [super dealloc];
}
@end
