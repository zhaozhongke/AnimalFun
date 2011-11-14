//
//  ImageUtil.h
//  ImageProcessing
//
//  Created by Evangel on 10-11-23.
//  Copyright 2010 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

@interface ImageUtil : NSObject 

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;

+ (UIImage*)blackWhite:(UIImage*)inImage;
+ (UIImage*)cartoon:(UIImage*)inImage;
+ (UIImage*)memory:(UIImage*)inImage;
+ (UIImage*)bopo:(UIImage*)inImage;
+(UIImage*)scanLine:(UIImage*)inImage;

+(UIImage*)makeSepiaScale:(UIImage*)image;
@end
