//
//  FilterImageView.m
//  cat
//
//  Created by jack on 11-9-22.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "FilterImageView.h"
#import "FilterViewController.h"
#import "ImageFilter.h"
#import "ActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define FILTERICONIMAGEHEIGHT ((IsIpad)? 128.0f:60.0f)
#define FilterIconLabelFontSize ((IsIpad)? 20.0f:12.0f)

@implementation FilterImageView

@synthesize filterDelegate,targetFilterView,targetFrameView,filterIconImageView,filterIconLabel;


-(id)initWithArgs:(CGRect)_frame image:(UIImage*)_image labelText:(NSString*)_labelText{
    if(self= [super initWithFrame:_frame]){
        self.userInteractionEnabled=YES;
        CGRect rect= self.bounds;
        
        rect.origin.y+=FILTERICONIMAGEHEIGHT;
        rect.size.height-=FILTERICONIMAGEHEIGHT;
        
        
        filterIconLabel=[[UILabel alloc]initWithFrame:rect];
        filterIconLabel.text=_labelText;
        filterIconLabel.textAlignment=UITextAlignmentCenter;
        filterIconLabel.backgroundColor=[UIColor clearColor];

        [filterIconLabel setTextColor:[UIColor colorWithRed:(232* 1.0)/255  green:(211* 1.0)/255 blue:(200* 1.0)/255 alpha: 1.0]];
        [filterIconLabel setFont:[UIFont boldSystemFontOfSize:FilterIconLabelFontSize]];
        rect=self.bounds;
        rect.size.height=FILTERICONIMAGEHEIGHT;
        
        filterIconImageView=[[UIImageView alloc]initWithFrame:rect];
        filterIconImageView.image=_image;
        filterIconImageView.layer.cornerRadius=6;
        filterIconImageView.layer.masksToBounds = YES;
        filterIconImageView.layer.opaque = NO;
        
        [self addSubview:filterIconImageView];
        [self addSubview:filterIconLabel];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    FilterImageView *filterView=(FilterImageView *)(((UITouch*)[touches anyObject]).view);
    
     NSInteger fiterTag=filterView.tag;
    
    FilterViewController *fvc=(FilterViewController *)(self.filterDelegate);
	if(fvc.filterTag!=fiterTag){
        if(isProcessingImage) return;
        
        //add filtericon filterSelectedView
        CGRect selectIconFrame=filterView.frame;
        
        CGFloat borderImageWidth=3.0f;
        
        fvc.filterSelectedView.frame=CGRectMake(selectIconFrame.origin.x-borderImageWidth, selectIconFrame.origin.y-borderImageWidth, kScrollFilterObjWidth+borderImageWidth*2, kScrollFilterObjWidth+borderImageWidth*2);  
        
        CGPoint center=CGPointMake(filterView.center.x, filterView.center.y-borderImageWidth*2);
//        fvc.filterSelectedView.center=center;
     
        [fvc.scrollView1 insertSubview:fvc.filterSelectedView belowSubview:filterView];
        
		//process filter frames
		targetFrameView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame%d",fiterTag]]];
		
        CGRect targetFrameViewFrame= fvc.filterFrame;
        
        
        CGFloat aspectRatio=fvc.filterImageView.image.size.height/fvc.filterImageView.image.size.width;
        
        CGRect imageRect= fvc.filterImageView.frame;
        CGFloat catoffset= (fvc.filterImageView.frame.size.height- imageRect.size.width*aspectRatio)/2.0f;
        
        targetFrameViewFrame.origin.y+=catoffset;
     
		targetFrameView.frame=fvc.filterFrame;
		targetFrameView.contentMode=UIViewContentModeScaleToFill;
		targetFrameView.alpha=1.0;
		targetFrameView.userInteractionEnabled=NO;
		
		[self.filterDelegate clearFilterView];
		
		fvc.filterFrameView=targetFrameView;
		
		[[fvc.filterImageView superview] addSubview:targetFrameView];
	
        // Get the Core Graphics Reference to the Image
        CGImageRef cgImage = [fvc.originalImageView.image CGImage];
        
        // Make a new image from the CG Reference
        UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
      
        fvc.filterImageView.image=copyOfImage;
        [copyOfImage release];
        
		[[fvc.filterImageView superview] bringSubviewToFront:fvc.filterFrameView];
        [[fvc.scrollView1 superview]bringSubviewToFront:fvc.scrollView1];
        
        //process image filter
        ActivityIndicator *alertView=[[[ActivityIndicator alloc]initWithTitle:nil] autorelease];
        
		[alertView startAnimatingInView:fvc.view];
        
		NSThread *imageProcessThread = [[NSThread alloc] initWithTarget:self selector:@selector(processImage:) object:alertView];
		[imageProcessThread start];
        
		[imageProcessThread release];
        fvc.filterTag=fiterTag;
     
	}
}

-(void)processImage :(ActivityIndicator *) alertView{
    @synchronized(self){
    isProcessingImage=YES;
    
	NSAutoreleasePool *alp=[[NSAutoreleasePool alloc]init];
    [NSThread sleepForTimeInterval:1];
	FilterViewController *fvc=(FilterViewController *)(self.filterDelegate);
	UIImageView *originalImageView= fvc.originalImageView;

        fvc.filterImageView.image=nil;
		switch (self.tag) {
			case 0:
				fvc.filterImageView.image=originalImageView.image;
				break;
			case 1:
                //Distinct
				fvc.filterImageView.image=[originalImageView.image adjust:-0.4 g:-0.2 b:0.1];
				break;
			case 2:
				fvc.filterImageView.image=[originalImageView.image saturate:0];
				break;
			case 3:
				fvc.filterImageView.image=[originalImageView.image saturate:1.6];
				break;
			case 4:
				fvc.filterImageView.image=[originalImageView.image saturate:2.0];
				break;
			case 5:
				fvc.filterImageView.image=[originalImageView.image lomoRED:1.6 withContrast:0.55];
				break;
			case 6:
				fvc.filterImageView.image=[originalImageView.image lomo:1.8 withContrast:0.85];
				break;
			case 7:
				fvc.filterImageView.image=[originalImageView.image lomo:1.7 withContrast:0.95];
				break;
			case 8:
				fvc.filterImageView.image=[originalImageView.image polaroidish];
				break;
			case 9:
                //cartton
				fvc.filterImageView.image=[originalImageView.image cartton];
				break;
			case 10:
                //sepia
				fvc.filterImageView.image=[originalImageView.image sepia];
				break;
			case 11:
                //Love
				fvc.filterImageView.image=[originalImageView.image adjust:0.0 g:0.0 b:0.0];
				break;
			case 12:
                //Dawn
				fvc.filterImageView.image=[originalImageView.image adjust:0.1 g:0.1 b:-0.1];
				break;
			case 13:
                //Cool
				fvc.filterImageView.image=[originalImageView.image adjust:-0.1 g:-0.2 b:-0.3];
				break;
			case 14:
                //Rose
				fvc.filterImageView.image=[originalImageView.image adjust:-0.1 g:-0.4 b:-0.1];
				break;
			case 15:
                //Timber
				fvc.filterImageView.image=[originalImageView.image adjust:-0.3 g:0.0 b:-0.2];
				break;
			case 16:
                //Maple
				fvc.filterImageView.image=[originalImageView.image adjust:-0.1 g:0.1 b:-0.4];
				break;
			case 17:
                //Vibrance
				fvc.filterImageView.image=[originalImageView.image adjust:0.5 g:0.1 b:0.2];
				break;
			case 18:
                //Focal
				fvc.filterImageView.image=[originalImageView.image adjust:0.0 g:0.3 b:0.1];
				break;
			case 19:
                //Aqua
				fvc.filterImageView.image=[originalImageView.image adjust:0.3 g:0.3 b:-0.2];
				break;
			case 20:
                //Story
				fvc.filterImageView.image=[originalImageView.image adjust:0.1 g:0.3 b:0.0];
				break;
			case 21:
                //Animals
				fvc.filterImageView.image=[originalImageView.image adjust:0.2 g:0.0 b:0.3];
				break;  
			case 22:
                //Striking
				fvc.filterImageView.image=[originalImageView.image adjust:0.3 g:0.7 b:1.1];
				break;
			case 23:
                //Accented
				fvc.filterImageView.image=[originalImageView.image adjust:-0.2 g:-0.2 b:-0.2];
				break;
			case 24:
                //Gritty
				fvc.filterImageView.image=[originalImageView.image adjust:0.2 g:0.2 b:0.2];
				break;
			case 25:
                //Winter
				fvc.filterImageView.image=[originalImageView.image adjust:0.5 g:0.5 b:0.5];
				break;
			default:
				break;
		}
    isProcessingImage=NO;
	[alertView stopAnimating];
	[alp release];
    }
}


- (void)dealloc {
	[filterDelegate release];
    [filterIconImageView release];
    [filterIconLabel release];
    [targetFrameView release];
    [targetFilterView release];
    [super dealloc];
}
@end
