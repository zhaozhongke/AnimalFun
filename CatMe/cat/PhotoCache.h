//
//  PhotoCache.h
//  PhotoMaker
//
//  Created by user on 10/23/11.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCache : NSObject
{
    UIImage *storedImage;
}
@property (nonatomic,retain) UIImage *storedImage;

-(id)initWithImage:(UIImage *)image;

@end
