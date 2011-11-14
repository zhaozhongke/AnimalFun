//
//  DraggableCoverView.m
//  cat
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "DraggableCoverView.h"
#import "CatView.h"
#import "WBImage.h"

#define CATSCALE 0.5f
#define SCROLLRECT CGRectMake(0, 0, 1380 , 1420)
#define SCROLLCONTENTSIZE CGSizeMake(1380, 1420)
#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@interface DraggableCoverView (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation DraggableCoverView


@synthesize catView,imageScale,catRect;

-(id)initWithImage:(UIImage *)image targetView:(UIView *)tView{
    
    if(self= [super initWithFrame:SCROLLRECT]){
        if(!image) return nil;
        
        self.userInteractionEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        
        self.contentMode=UIViewContentModeScaleAspectFill;
        self.contentSize=SCROLLCONTENTSIZE;
        self.delegate=self;
        
        catView=[[CatView alloc]initWithImage:image targetView:tView];
        
        self.catRect=CGRectMake(40,40, image.size.width*CATSCALE, image.size.height*CATSCALE);
        catView.frame=self.catRect;
        
        [self addSubview:catView];
        
        
        self.catView.image=image;
        self.catView.contentMode=UIViewContentModeScaleAspectFit;
        self.catView.userInteractionEnabled=YES;
            
        // set the tag for the image view
        [catView setTag:ZOOM_VIEW_TAG];
        
        // add gesture recognizers to the image view
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        [twoFingerTap setNumberOfTouchesRequired:2];
        
        [catView addGestureRecognizer:singleTap];
        [catView addGestureRecognizer:doubleTap];
        [catView addGestureRecognizer:twoFingerTap];
        
        [singleTap release];
        [doubleTap release];
        [twoFingerTap release];
        
        // calculate minimum scale to perfectly fit image width, and begin at that scale
        float minimumScale = [self frame].size.width  / [catView frame].size.width;
        
        
        
        [self setMinimumZoomScale:minimumScale];
        [self setZoomScale:minimumScale];
        self.minimumZoomScale=1;
        self.maximumZoomScale=5.5;
        
        UIRotationGestureRecognizer *rotationGesture = 
        [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(handleRotate:)];
        rotationGesture.delegate = self;
        [self addGestureRecognizer:rotationGesture];
        [self.catView addGestureRecognizer:rotationGesture];
        
        [rotationGesture release];
        
        self.imageScale=1.0f;
    }
    return self;
    
}
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan || 
       recognizer.state == UIGestureRecognizerStateChanged)
    {
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, 
                                                            recognizer.rotation);
        [recognizer setRotation:0];
    }
}
- (void)dealloc {
    [catView release];
    [super dealloc];
}
#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.catView;
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    [scrollView setZoomScale:scale animated:NO];
    self.imageScale=scale;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
//    // double tap zooms in
//    float newScale = [self zoomScale] * ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
//    [self zoomToRect:zoomRect animated:YES];
    
    self.catView.image =[self.catView.image rotate:UIImageOrientationUpMirrored];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [self zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]]    ;
    
    [self zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
