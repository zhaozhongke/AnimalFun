//
//  DragImageDelegate.h
//  cat
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DragImageDelegate <NSObject>
@optional
-(void)setCurrentCatView:(UIScrollView *)catView;
@optional
-(void)clearCatView;
@optional
-(void)setCurrentFilterFrame:(UIImageView *)filterView;
@optional
-(void)clearFilterView;
@end
