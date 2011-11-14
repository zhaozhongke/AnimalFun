//
//  PhotoCache.m
//  PhotoMaker
//
//  Created by user on 10/23/11.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "PhotoCache.h"

@implementation PhotoCache
@synthesize storedImage;

-(id)initWithImage:(UIImage *)image{
    if(self=[super init]){
        self.storedImage=image;
    }
    
    return self;
}

- (void)dealloc {
    [storedImage release];
    [super dealloc];
}
@end
