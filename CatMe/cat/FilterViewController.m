//
//  FilterViewController.m
//  cat
//
//  Created by jack on 11-9-19.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "FilterViewController.h"
#import "SaveViewController.h"
#import "DraggableImageView.h"
#import "FilterImageView.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "ArticleView.h"

@implementation FilterViewController


const NSUInteger filterNumImages		= 26;
const CGFloat  filterViewSpacing   =10.0;
const CGFloat filterScrollUpMargin	= 8.0;

@synthesize filterImageView,originalImageView;
@synthesize catFilterView;
@synthesize catPostion;
@synthesize scrollView1;
@synthesize filterFrameView;
@synthesize filterTag;
@synthesize filterFrame;
@synthesize filterSelectedView;

-(UIImage *)mergeImages:(UIImageView*) touchView withView:(UIImageView*)bgImageView{
    
    UIGraphicsBeginImageContextWithOptions(filterFrame.size, touchView.opaque, 2);
 
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();

    CGFloat aspectRatio=bgImageView.image.size.height/bgImageView.image.size.width;
    CGFloat offset= (self.filterImageView.frame.size.height- bgImageView.frame.size.width*aspectRatio)/2.0f;
    
    CGContextTranslateCTM(resizedContext, 0, - offset);
	[touchView.layer renderInContext:resizedContext];
    
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();  
    
    return  viewImage;
}

-(void)initViews:(UIView *)imageView withBgImageView:(UIImageView *)bgImageView {
   
    filterImageView=[[UIImageView alloc]initWithFrame:imageView.frame];
    filterImageView.contentMode=UIViewContentModeScaleAspectFit;
    catFilterView=[[UIImageView alloc]initWithFrame:imageView.frame];
    
    CGFloat aspectRatio=bgImageView.image.size.height/bgImageView.image.size.width;
    
    CGRect imageRect= self.filterImageView.frame;
    CGFloat offset= (self.filterImageView.frame.size.height- bgImageView.frame.size.width*aspectRatio)/2.0f;
    filterFrame=CGRectMake(imageRect.origin.x,imageRect.origin.y+offset,imageRect.size.width,imageRect.size.width*aspectRatio);
    filterFrameView=[[UIImageView alloc]initWithFrame:filterFrame];
    
    filterImageView.image=[self mergeImages:imageView withView:bgImageView];
    
    
    originalImageView=[[UIImageView alloc]initWithFrame:imageView.frame];
    originalImageView.image=filterImageView.image;
    
    
    originalImageView.contentMode=UIViewContentModeScaleAspectFit;
    catFilterView.contentMode=UIViewContentModeScaleAspectFit;
    filterFrameView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    //filterSelectedView init
    self.filterSelectedView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border_baikuang_b.png"]] autorelease];
    filterTag=-1;
	
  
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

-(void)forwardToSaveViewButtonFn{
    SaveViewController *svc=[[SaveViewController alloc]init];
    
    svc.catFilterView=self.catFilterView;
    svc.finalImageView=self.filterImageView;
    svc.filterFrameView=self.filterFrameView;
    svc.tbarFrame=self.scrollView1.frame;
    
    svc.filterFrame=self.filterFrame;
    
    [self.navigationController pushViewController:svc animated:YES];
    
    [svc release];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [[self.navigationItem.rightBarButtonItem.customView superview] bringSubviewToFront:self.navigationItem.rightBarButtonItem.customView];
    
    [self.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:self.navigationItem.leftBarButtonItem.customView];
    
    [self.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:self.navigationItem.titleView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [self.view addSubview:self.filterImageView];
    [self.view bringSubviewToFront:self.scrollView1];
    [self.view addSubview:self.filterFrameView];
    
    
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
	NSUInteger i;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"frames" ofType:@"plist"];
    NSArray *imageArray=[NSArray arrayWithContentsOfFile:plistPath];
    
    NSDictionary *dict=(NSDictionary *)[imageArray lastObject];//frames
    
	for (i = 0; i < filterNumImages; i++)
	{
		NSString *imageName = [NSString stringWithFormat:@"icon_filter%d.png", i];
		UIImage *image3 = [UIImage imageNamed:imageName];
        
        //        image3=[CommonUtils addText:image3 text:[dict valueForKey:[NSString stringWithFormat:@"frame%d",i]]];
        
        CGRect rect =CGRectZero;
        
        rect.origin.x=kScrollFilterObjWidth*i +filterViewSpacing*(i+1);
        rect.origin.y+=filterScrollUpMargin;
		rect.size.height = kScrollFilterObjHeight;
		rect.size.width = kScrollFilterObjWidth;
        
		FilterImageView *dragImageView = [[FilterImageView alloc] initWithArgs:rect image:image3 labelText:[dict valueForKey:[NSString stringWithFormat:@"frame%d",i]]];
        
        
		dragImageView.filterDelegate=self;
		dragImageView.frame = rect;
		dragImageView.tag = i;	// tag our images for later use when we place them in serial fashion
        //		dragImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        
        [scrollView1 addSubview:dragImageView];
		[dragImageView release];
	}
	
	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake((filterNumImages * kScrollFilterObjWidth+(filterNumImages+1)*filterViewSpacing), kScrollFilterObjWidth+filterScrollUpMargin)];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    self.filterFrameView=nil;
    self.originalImageView=nil;
    self.catFilterView=nil;
    self.filterFrameView=nil;
    self.scrollView1=nil;
    
//    [filterImageView release];
//    [catFilterView release];
//    [originalImageView release];
//    [filterFrameView release];
//    [scrollView1 release];
}

#pragma mark - View lifecycle

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey.png"]];
    UIImage *buttonImage = [UIImage imageNamed:@"header_bar_btn_normal.png"];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:[CommonUtils buttonWithImageAndText:buttonImage buttonText:@"Next" target:self action:@selector(forwardToSaveViewButtonFn)]];
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
    [label setText:@"Add Filter"];
    //added (tony)
    [label setTextColor:[UIColor colorWithRed:(102* 1.0)/255  green:(79* 1.0)/255 blue:(64* 1.0)/255 alpha: 1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    
    self.navigationItem.titleView = label;
    if(IsIpad){
        scrollView1.frame=CGRectMake(0, 800, 768, 160);
        filterImageView.frame=CGRectMake(0, 0, 768, 800);

    }
    self.view.autoresizesSubviews=NO;
    
}

- (void)viewDidUnload
{
    self.filterFrameView=nil;
    self.originalImageView=nil;
    self.catFilterView=nil;
    self.filterFrameView=nil;
    self.scrollView1=nil;
    self.filterSelectedView=nil;
    
    [super viewDidUnload];
}

-(void)dealloc{
    
    [filterImageView release];
    [catFilterView release];
    [originalImageView release];
    [filterFrameView release];
    [scrollView1 release];
    [filterSelectedView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)clearFilterView{
    //    [self.filterImageView removeFromSuperview];
    [self.filterFrameView removeFromSuperview];
    
    //    [[self.filterImageView superview]addSubview:self.originalImageView];
    //    [[self.filterImageView superview]bringSubviewToFront:self.originalImageView];
}

-(void)productFiltersPurchased{
    NSLog(@"cats filters purchased successfully");
    
}

@end
