//
//  FilterViewController.h
//  cat
//
//  Created by jack on 11-9-19.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageDelegate.h"
#import "TSStoreManager.h"
#import "TSConfig.h"

#define  kScrollFilterObjHeight  ((IsIpad)? 150.0f:80.0f)
#define kScrollFilterObjWidth	 ((IsIpad)? 128.0f:60.0f)
@interface FilterViewController : UIViewController<DragImageDelegate,TSStoreKitDelegate>
{
    UIImageView *filterImageView;
    UIImageView *originalImageView;
    
    UIImageView *catFilterView;
    UIImageView *filterFrameView;
    
    CGPoint catPostion;
    
    int filterTag;
    
    IBOutlet UIScrollView *scrollView1;
    
    CGRect filterFrame;
    
    UIImageView *filterSelectedView;
	
}
@property  (nonatomic,retain) UIImageView *filterImageView;
@property  (nonatomic,retain) UIImageView *originalImageView;
@property  (nonatomic,retain) UIImageView *filterSelectedView;
@property  (nonatomic,retain) UIImageView *catFilterView;
@property  (nonatomic,retain) UIImageView *filterFrameView;
@property  (nonatomic) CGPoint catPostion;
@property  (nonatomic) CGRect filterFrame;
@property  (nonatomic,retain) UIScrollView *scrollView1;


@property  (assign) int filterTag;

-(NSMutableArray *)fetchIframesTypes;
-(void)initViews:(UIView *)imageView withBgImageView:(UIImageView *)bgImageView;
@end
