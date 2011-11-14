//
//  SaveViewController.h
//  cat
//
//  Created by jack on 11-9-19.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANImageBitmapRep.h"
#import "Appirater.h"
#import "SHK.h"
#import "SHKSharer.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface MyAppToolBar : UIToolbar{
}
@end


@interface SaveViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    UIImageView *finalImageView;
    UIImageView *catFilterView;
    UIImageView *filterFrameView;
    
    UIImage *willSaveImage;
    UIToolbar *tbar;
    
    CGRect tbarFrame;
    BOOL isFinalImageSaved;
    
    CGRect filterFrame;
}

@property  (nonatomic,retain) UIImageView *finalImageView;
@property  (nonatomic,retain) UIImageView *catFilterView;
@property  (nonatomic,retain) UIImageView *filterFrameView;
@property  (assign) CGRect tbarFrame;
@property  (nonatomic) CGRect filterFrame;
@property  (nonatomic,retain) IBOutlet UIToolbar *tbar;
@property  (nonatomic,retain) UIImage *willSaveImage;

-(NSArray *)itemsOnToolbar;
@end
