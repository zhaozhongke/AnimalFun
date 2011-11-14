//
//  CatViewController.m
//  cat
//
//  Created by jack on 11-9-18.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "CommonUtils.h"
#import "ArticleViewController.h"
#import "FilterViewController.h"
#import "DraggableImageView.h"
#import "Reachability.h"
#import "TSStoreManager.h"
#import <QuartzCore/QuartzCore.h>

#define   CATVIEWSPACING   (IsIpad ?20.0f :10.0f)
const CGFloat catScrollUpMargin	= 10.0;


@implementation ArticleViewController

@synthesize scrollView1,catView,isFirstAppearFlag,pc,catIconsArrays,bgImageView;
@synthesize imageView = _imageView;
@synthesize catIconBorderView;

#pragma mark - View lifecycle

-(id)init{
    if(self=[super init]){
        catIconsArrays=[[NSMutableArray alloc]initWithCapacity:TSTotalIcons+1];
        isScrollViewInit=NO;
        
        ai = [[ActivityIndicator alloc]initWithTitle:@"Connecting…"];
        
        CGFloat rootViewWidth=self.view.bounds.size.width;
        CGFloat rootViewHeight=self.view.bounds.size.height;
        CGRect rect=CGRectMake(0, 0, rootViewWidth, rootViewHeight-self.scrollView1.frame.size.height+CATVIEWSPACING);
        if(IsIpad){
            rect=CGRectMake(0, 0, 768, 800);
             scrollView1.frame=CGRectMake(0, 800, 768, 150);
        }
        _imageView=[[TouchCatView alloc]initWithFrame:rect];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        bgImageView= [[UIImageView alloc]initWithFrame:_imageView.frame];
        bgImageView.contentMode=self.imageView.contentMode;
        [_imageView addSubview:bgImageView];
     self.catIconBorderView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border_baikuang_b.png"]]autorelease];
    }
    return self;
}

-(id)initWithCache:(PhotoCache *)_pc{
    if(self=[super init]){
        catIconsArrays=[[NSMutableArray alloc]initWithCapacity:TSTotalIcons+1];
        isScrollViewInit=NO;
        [pc release];
        pc=[_pc retain];
        
        CGFloat rootViewWidth=self.view.bounds.size.width;
        CGFloat rootViewHeight=self.view.bounds.size.height;
        CGRect rect=CGRectMake(0, 0, rootViewWidth, rootViewHeight-self.scrollView1.frame.size.height+CATVIEWSPACING);
        _imageView=[[TouchCatView alloc]initWithFrame:rect];
        _imageView.backgroundColor=[UIColor redColor];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self; 
}
-(void)nextFn{
    FilterViewController *filterViewController=[[FilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil];
    [filterViewController initViews:self.imageView withBgImageView:self.bgImageView];
   
    [self.navigationController pushViewController:filterViewController animated:YES];
    
    [filterViewController release];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //set bar button items image
    UIImage *buttonImage = [UIImage imageNamed:@"header_bar_btn_normal.png"];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:[CommonUtils buttonWithImageAndText:buttonImage buttonText:@"Next" target:self action:@selector(nextFn)]];
    self.navigationItem.rightBarButtonItem=nextButton;   
    [nextButton release];
    
    UIBarButtonItem *backButton= [[UIBarButtonItem alloc] initWithCustomView:[CommonUtils buttonWithImageAndText:buttonImage buttonText:@"Back" target:self action:@selector(back)]];
    self.navigationItem.leftBarButtonItem=backButton;
    [backButton release];

    //set title
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, 120, 42);
    [label setText:[NSString stringWithFormat:@"%@",TSArticleTitle]];
    //added (tony)
    [label setTextColor:[UIColor colorWithRed:(102* 1.0)/255  green:(79* 1.0)/255 blue:(64* 1.0)/255 alpha: 1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    
    self.navigationItem.titleView = label;


}

-(void)addCat{
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
	[[self.navigationItem.rightBarButtonItem.customView superview] bringSubviewToFront:self.navigationItem.rightBarButtonItem.customView];
    
    [self.scrollView1.superview bringSubviewToFront:self.scrollView1];
    
    
    [self.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:self.navigationItem.leftBarButtonItem.customView];
    [[self.navigationItem.titleView superview] bringSubviewToFront:self.navigationItem.titleView];
    
    if(isFirstAppearFlag){
        ActivityIndicator *ais=[[[ActivityIndicator alloc]initWithTitle:@"loading..." ] autorelease];
 
        [ais startAnimatingInView:self.view];
        NSThread *imageProcess=   [[NSThread alloc]initWithTarget:self selector:@selector(imageLoading:) object:ais];
        [imageProcess start];
        [imageProcess release];
    }
    
}
-(void)imageLoading:(ActivityIndicator *) ais{
    NSAutoreleasePool *alp=[[NSAutoreleasePool alloc]init];
    [NSThread sleepForTimeInterval:0.3];
    [ais stopAnimating]; 
    
    bgImageView.image=pc.storedImage;

    isFirstAppearFlag=NO;
    [alp release];
}
-(void)scrollViewInit{
    // 1. setup the scrollview for multiple images and add it to the view controller
    
	[scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	scrollView1.clipsToBounds = YES;		
	scrollView1.scrollEnabled = YES;
    scrollView1.showsVerticalScrollIndicator=NO;
	
	scrollView1.pagingEnabled = NO;
    scrollView1.alwaysBounceVertical=NO;
	
    //set background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bottom_bar_bg.png"]];
    self.scrollView1.backgroundColor = background;
        
    [background release];
    
	// load all the images from our bundle and add them to the scroll view
    
    UIImageView *verticalLine=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"separator.png"]] autorelease];
    
	NSUInteger i;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isFeatureCatsPurchased=[userDefaults boolForKey:featureCatsId];
    
    
    for (i = 1; i <= TSTotalIcons; i++)
	{
        NSAutoreleasePool *alp=[[NSAutoreleasePool alloc]init];
        if(IsAppSupportIAP && i==(TSFreeIconCount+1)) {
            CGRect verticalLineFrame = verticalLine.frame;
            verticalLineFrame.origin.y+=15;
            verticalLineFrame.size.height = kScrollObjHeight;
            verticalLineFrame.size.width = 3;
            verticalLineFrame.origin.x=kScrollObjWidth*(i-1)+CATVIEWSPACING*i;
            verticalLine.frame=verticalLineFrame;
            [scrollView1 addSubview:verticalLine];
        }

        UIImage *image3 = [self.catIconsArrays objectAtIndex:i-1];
        
		DraggableImageView *dragImageView = [[DraggableImageView alloc] initWithImage:image3 isPurchased:isFeatureCatsPurchased tag:i];
		dragImageView.targetView=_imageView;
        dragImageView.catDelegate=self;

		CGRect rect = dragImageView.frame;
        
        rect.origin.x=kScrollObjWidth*(i-1)+CATVIEWSPACING*i+((IsAppSupportIAP && i>TSFreeIconCount)?(verticalLine.frame.size.width+CATVIEWSPACING):0);
        rect.origin.y+=15;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
        
		dragImageView.frame = rect;
        
        
		dragImageView.tag = i;	// tag our images for later use when we place them in serial fashion
		dragImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [scrollView1 addSubview:dragImageView];
		[dragImageView release];     
        [alp release];
	}
    [scrollView1 setContentSize:CGSizeMake((TSTotalIcons * kScrollObjWidth+(TSTotalIcons+1)*CATVIEWSPACING)+((IsAppSupportIAP && (TSTotalIcons>TSFreeIconCount))?(verticalLine.frame.size.width+CATVIEWSPACING):0), kScrollObjWidth+catScrollUpMargin)];
    isScrollViewInit=YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey.png"]];
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.view addSubview:_imageView];
    if(!isScrollViewInit){
        [self scrollViewInit];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    self.scrollView1=nil;
    
    self.imageView=nil;
    
    self.catView=nil;
 
    self.bgImageView=nil;
    
    self.catIconBorderView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [catView release];
    [scrollView1 release];
    [_imageView release];
    [pc release];
    [catIconsArrays removeAllObjects];
    [catIconsArrays release];
    [bgImageView release];
    [ai release];
    [catIconBorderView release];
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)clearCatView{
  [self.catView removeFromSuperview];
}
-(void)productCatsPurchased{
    [ai stopAnimating];
    NSLog(@"purchase success");
    UIAlertView *purchaseSucessAlert=[[[UIAlertView alloc] initWithTitle:@"Purchased!" 
                                                     message:[NSString stringWithFormat:@"You now have access to %d %@s!" ,TSTotalIcons,TSArticle]
                                                    delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    
    purchaseSucessAlert.tag=purchaseSucessAlertTag;
    [purchaseSucessAlert show];
    
}

-(void)failed{
    if([ai superview]){
        [ai stopAnimating];
    }
}

-(void)featureCatsProduct
{
	Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
	NetworkStatus status = [reach currentReachabilityStatus];
	
	switch (status) {
		case NotReachable:{
            [ai stopAnimating];
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
															message:@"Failed connect internet" 
														   delegate:self 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil] autorelease];
			[alert show];
            return;
		}
			break;
		default:
			break;
	}

    [TSStoreManager sharedManager].delegate=self;
	[[TSStoreManager sharedManager] buyFeatureCats];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==CATPURCHASEALERTVIEWTAG){
        if(buttonIndex==1){
            [ai startAnimatingInView:self.view];
            @synchronized(self.scrollView1){
                [self featureCatsProduct];
            }
        }else{
            alertView.hidden=YES;
        }
    }
    if(alertView.tag==purchaseSucessAlertTag){
        if(buttonIndex==0){
            [NSThread detachNewThreadSelector:@selector(unLockPaidIcons) toTarget:self withObject:nil];
        }
    }
}

// change the scorllview GUI after cats purchased
-(void)unLockPaidIcons{ 
    NSAutoreleasePool *alp=[[NSAutoreleasePool alloc]init];
    NSArray *subviews=self.scrollView1.subviews;
    
    for (UIImageView* view in subviews) {
        if ([view isKindOfClass: [DraggableImageView class]]) {
            view.image=nil;
            view.image=[self.catIconsArrays objectAtIndex:view.tag-1];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 1.0f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            
            [view.layer addAnimation:transition forKey:nil];

        }
    }
  
    [alp release];
}

// scrollview after flip ,item could not respond touchbegan message ..
- (void)flipAction:(UIView *)from to:(UIView *)to
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTransitionDuration];
    
	[UIView setAnimationTransition:([from superview] ?
                                    UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
                           forView:scrollView1 cache:YES];

    [from removeFromSuperview];
	[scrollView1 addSubview:to];
	[UIView commitAnimations];
    
}

-(void)didReceiveMemoryWarning{
//    [catView release];
//    [scrollView1 release];
//    [_imageView release];
//    [pc release];
//    [catIconsArrays removeAllObjects];
//    [catIconsArrays release];
//    [bgImageView release];
//    [ai release];
    
//    [super didReceiveMemoryWarning];
}

@end

