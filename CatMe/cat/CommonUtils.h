//
//  CommonUtils.h
//  Article
//
//  Created by jack on 11-9-21.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils:NSObject
+(UIButton *)buttonWithImageAndText:(UIImage *)buttonImage buttonText:(NSString *)buttonText target:(id)target action:(SEL)action;
+(UIImage *)addImage:(UIImage *)img withImage:(UIImage *)addedImage isCovered:(BOOL)isCovered;
@end
