//
//  CatViewController.h
//  cat
//
//  Created by jack on 11-9-18.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageDelegate.h"
#import "DraggableImageView.h"
#import "TSStoreManager.h"
#import "PhotoCache.h"
#import "ActivityIndicator.h"
#import "SHKConfig.h"
#import "TouchCatView.h"

#define kTransitionDuration     1.75
#define purchaseSucessAlertTag  908
#define kScrollObjHeight        ((IsIpad)? 128.0f:60.0f)
#define kScrollObjWidth         ((IsIpad)? 128.0f:60.0f)

@interface ArticleViewController : UIViewController<UIScrollViewDelegate,DragImageDelegate,UIGestureRecognizerDelegate,TSStoreKitDelegate,UIAlertViewDelegate>{
    
    TouchCatView *_imageView;
    IBOutlet UIScrollView *scrollView1;
    
    PhotoCache *pc;
    BOOL isFirstAppearFlag;
    BOOL isScrollViewInit;
    
    NSMutableArray *catIconsArrays;
    ActivityIndicator *ai;
    
    UIImageView *bgImageView;
    
    UIImageView *catIconBorderView;
}

@property   (nonatomic,retain) UIScrollView *scrollView1;
@property   (nonatomic,retain) TouchCatView *imageView;
@property   (nonatomic,retain) UIImageView *catView;
@property   (nonatomic,retain) UIImageView *catIconBorderView;

@property   (nonatomic,retain) UIImageView *bgImageView;

@property   (nonatomic,assign) BOOL isFirstAppearFlag;;
@property   (nonatomic,retain) PhotoCache *pc;
@property   (nonatomic,retain) NSMutableArray *catIconsArrays;

-(id)initWithCache:(PhotoCache *)_pc;

@end
