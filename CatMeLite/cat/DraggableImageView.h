//
//  DraggableImageView.h
//  cat
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageDelegate.h"
#import "SHKConfig.h"

#define CATPURCHASEALERTVIEWTAG 10

@interface DraggableImageView : UIImageView
{
    UIView *targetView;
    id <DragImageDelegate> catDelegate;
}
@property (nonatomic,retain) UIView *targetView;

@property (assign) id <DragImageDelegate> catDelegate;

-(id)initWithImage:(UIImage *)image isPurchased:(BOOL)isPurchased tag:(int)tag;

@end
