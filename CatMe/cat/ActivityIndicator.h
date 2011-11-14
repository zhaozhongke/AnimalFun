//
//  ActivityIndicator.h
//  PhotoMaker
//
//  Created by user on 10/23/11.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityIndicator : UIView
{
    id delegate;
    UIActivityIndicatorView *ai;
}   
@property (nonatomic,retain) UIActivityIndicatorView *ai;

-(id)initWithTitle:(NSString *) title;
-(void)startAnimatingInView:(UIView *)_view;
-(void)stopAnimating;
@end
