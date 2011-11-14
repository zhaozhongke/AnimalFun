//
//  ViewController.h
//  cat
//
//  Created by jack on 11-9-17.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleViewController.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate>{
    
    IBOutlet UIButton* btCamera;
    IBOutlet UIButton* btPhotoAlbum;
    IBOutlet UIButton* btnMoreApps;
    
    UIImagePickerController *imagePicker;
    
    ArticleViewController *catViewController;
    
    UIPopoverController *popoverController;
}

@property (nonatomic,retain) UIImagePickerController *imagePicker;
@property (nonatomic,retain) ArticleViewController *catViewController;
-(IBAction)click:(UIButton *)sender;

-(IBAction)photoAlbum:(UIButton *)sender;
-(IBAction)moreApps:(UIButton *)sender;

@end
