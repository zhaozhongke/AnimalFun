//
//  RotatableBitmapRep.h
//  ImageManip
//
//  Created by Alex Nichol on 7/12/11.
//  Copyright 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CroppableBitmapRep.h"


@interface RotatableBitmapRep : CroppableBitmapRep {
    
}

/**
 * Rotate the image bitmap around its center by a certain number of degrees.
 * @param degrees The degrees from 0 to 360.  This is not measured in radians.
 * @discussion This will resize the image if needed.
 */
- (void)rotate:(CGFloat)degrees;

/**
 * Create a new image by rotating this image bitmap around its center by a specified
 * number of degrees.
 * @param degrees The degrees (not in radians) by which the image should be rotated.
 * @discussion This will resize the image if needed.
 */
- (CGImageRef)imageByRotating:(CGFloat)degrees;

@end
