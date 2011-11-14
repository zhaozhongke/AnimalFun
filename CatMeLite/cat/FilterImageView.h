//
//  FilterImageView.h
//  cat
//
//  Created by jack on 11-9-22.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageDelegate.h"

static BOOL isProcessingImage=NO;

@interface FilterImageView : UIView
{
    id <DragImageDelegate> filterDelegate;
    UIImageView *targetFilterView;
    UIImageView *targetFrameView;
 
	
    IBOutlet UILabel *filterIconLabel; 
    IBOutlet UIImageView *filterIconImageView;
	
}

@property (nonatomic,retain) id <DragImageDelegate> filterDelegate;
@property (nonatomic,retain) UIImageView *targetFilterView;
@property (nonatomic,retain) UIImageView *targetFrameView;

@property (nonatomic,retain) UIImageView *filterIconImageView;
@property (nonatomic,retain) UILabel *filterIconLabel;
-(id)initWithArgs:(CGRect)_frame image:(UIImage*)_image labelText:(NSString*)_labelText;
@end
