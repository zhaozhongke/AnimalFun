//
//  SaveViewController.m
//  cat
//
//  Created by jack on 11-9-19.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "SaveViewController.h"
#import "CommonUtils.h"
#import "UIImage-Extensions.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>


#define TOOLBARITEMWIDTH ((IsIpad)? 140.0f:66.0f)
#define TOOLBARITEMBOTTOMMARGIN ((IsIpad)? 10:60.0f)
#define TOOLBARITEMTOPMMARGIN ((IsIpad)? 30.0f:14.0f)

@implementation MyAppToolBar

- (void)drawRect:(CGRect)rect {
    self.frame=CGRectMake(0,328,320,140);//scroll view frame
    if(IsIpad){
        self.frame=CGRectMake(0, 800, 768, 160);
    }
    UIImage *img  = [UIImage imageNamed: @"bottom_bar_bg.png"];
    [img drawInRect:CGRectMake(0,0, self.bounds.size.width , self.bounds.size.height)];
 
}

@end

@implementation SaveViewController

@synthesize finalImageView,catFilterView,filterFrameView,tbarFrame,willSaveImage,filterFrame;
@synthesize tbar;

- (void)dealloc {
    [finalImageView release];
    [catFilterView release];
    [filterFrameView release];
    [tbar release];
    [willSaveImage release];
    [super dealloc];
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.tbar];
}

-(NSArray *)itemsOnToolbar{

    
    CGFloat tbarHeight=self.tbarFrame.size.height;
    
    UIButton *saveButton=[[UIButton alloc]init];
    CGPoint origin=saveButton.frame.origin;
    
    saveButton.frame=CGRectMake(origin.x, origin.y, TOOLBARITEMWIDTH, tbarHeight);
    
    
    [saveButton setImage:[UIImage imageNamed:@"icon_album.png"] forState:UIControlStateNormal];
    [saveButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
   
    [saveButton addTarget:self action:@selector(saveFn:) forControlEvents:UIControlEventTouchUpInside];

    saveButton.imageEdgeInsets=UIEdgeInsetsMake(TOOLBARITEMTOPMMARGIN , 0, TOOLBARITEMBOTTOMMARGIN, 0);
   
    UIBarButtonItem*  saveBarButton=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    [saveButton release];
    
    
    UIButton *emailButton=[[UIButton alloc]init];
    origin=emailButton.frame.origin;
    
    emailButton.frame=CGRectMake(origin.x, origin.y, TOOLBARITEMWIDTH, tbarHeight);
    [emailButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [emailButton setImage:[UIImage imageNamed:@"icon_mail.png"] forState:UIControlStateNormal];
    
    [emailButton addTarget:self action:@selector(mailFn:) forControlEvents:UIControlEventTouchUpInside];
    
     emailButton.imageEdgeInsets=UIEdgeInsetsMake(TOOLBARITEMTOPMMARGIN , 0, TOOLBARITEMBOTTOMMARGIN, 0);
    UIBarButtonItem*  emailBarButton=[[UIBarButtonItem alloc]initWithCustomView:emailButton];
    
    [emailButton release];
    
    
    //facebook button item config
    UIButton *facebookButton=[[UIButton alloc]init];
    origin=facebookButton.frame.origin;
    
    facebookButton.frame=CGRectMake(origin.x, origin.y, TOOLBARITEMWIDTH, tbarHeight);
    [facebookButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [facebookButton setImage:[UIImage imageNamed:@"icon_fb.png"] forState:UIControlStateNormal];
    
    [facebookButton addTarget:self action:@selector(facebookFn) forControlEvents:UIControlEventTouchUpInside];
    facebookButton.imageEdgeInsets=UIEdgeInsetsMake(TOOLBARITEMTOPMMARGIN , 0,TOOLBARITEMBOTTOMMARGIN , 0);

    UIBarButtonItem*  fbBarButton=[[UIBarButtonItem alloc]initWithCustomView:facebookButton];
    
    
    [facebookButton release];
    
    //facebook button item config
    UIButton *twitterButton=[[UIButton alloc]init];
    origin=twitterButton.frame.origin;
    
    twitterButton.frame=CGRectMake(origin.x, origin.y, TOOLBARITEMWIDTH, tbarHeight);
    [twitterButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [twitterButton setImage:[UIImage imageNamed:@"icon_twitter.png"] forState:UIControlStateNormal];
    
    [twitterButton addTarget:self action:@selector(twitterFn) forControlEvents:UIControlEventTouchUpInside];
     twitterButton.imageEdgeInsets=UIEdgeInsetsMake(TOOLBARITEMTOPMMARGIN , 0, TOOLBARITEMBOTTOMMARGIN, 0);
    UIBarButtonItem*  twitterBarButton=[[UIBarButtonItem alloc]initWithCustomView:twitterButton];

    
    [twitterButton release];
    
    
    
    //center the toolbar items
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *array=[NSArray arrayWithObjects:flexibleSpace,emailBarButton,saveBarButton,fbBarButton,twitterBarButton,flexibleSpace ,nil];
    
    [flexibleSpace release];
    
    [saveBarButton release];
    [emailBarButton release];
    [fbBarButton release];
    [twitterBarButton release];

    return array ;
}



-(id)init{
    if(self=[super init]){
        isFinalImageSaved=NO;
        tbar=[[MyAppToolBar alloc]init];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}


#pragma mark - View lifecycle

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        [Appirater userDidSignificantEvent:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [[self.navigationItem.rightBarButtonItem.customView superview] bringSubviewToFront:self.navigationItem.rightBarButtonItem.customView];
    
    [self.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:self.navigationItem.leftBarButtonItem.customView];
    [self.navigationItem.leftBarButtonItem.customView.superview bringSubviewToFront:self.navigationItem.titleView];
    
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey.png"]];
    self.catFilterView.contentMode=UIViewContentModeScaleAspectFit;
    
    //set navigation bar 
    UIImage *buttonImage = [UIImage imageNamed:@"header_bar_btn_normal.png"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:[CommonUtils buttonWithImageAndText:buttonImage buttonText:@"Done" target:self action:@selector(doneFn)]];
    self.navigationItem.rightBarButtonItem=doneButton;   
    [doneButton release];
    
    UIBarButtonItem *backButton= [[UIBarButtonItem alloc] initWithCustomView:[CommonUtils buttonWithImageAndText:buttonImage buttonText:@"Back" target:self action:@selector(back)]];
    self.navigationItem.leftBarButtonItem=backButton;
    [backButton release];

    // add subviews
     self.finalImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.finalImageView];
    [self.view addSubview:self.filterFrameView];

    tbar.frame=self.tbarFrame;
    
//    tbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    if(IsIpad){
        tbar.frame=CGRectMake(0, 800, 768, 160);
    }
    
     NSArray *myToolbarItems=[self itemsOnToolbar];   
    [tbar bringSubviewToFront:tbar.subviews.lastObject];
    [tbar setItems:myToolbarItems];

    [self.view addSubview:tbar];

    //set title
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, 160, 42);
    [label setText:@"Save and Share"];
    //added (tony)
    [label setTextColor:[UIColor colorWithRed:(102* 1.0)/255  green:(79* 1.0)/255 blue:(64* 1.0)/255 alpha: 1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:18]];

    
    
    self.navigationItem.titleView = label;
 
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
// done
-(void)doneFn{
    if (!isFinalImageSaved) {
        UIActionSheet *alert=[[UIActionSheet alloc]initWithTitle:@"Do you want to save the editted photo to your photo album prior to starting again?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        alert.tag=100;
        [alert dismissWithClickedButtonIndex:2 animated:YES];
        [alert showInView:self.view];
        
        [alert release];
    }else{
          [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==100){
    switch (buttonIndex) {
        case 0:
            if(!isFinalImageSaved) [self mergeImages];
           UIImageWriteToSavedPhotosAlbum(self.willSaveImage, self,@selector(saveCallBack:didFinishSavingWithError:contextInfo:), NULL);
            [Appirater userDidSignificantEvent:YES];
            break;
        case 1:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    }
   
}

// goto rootviewcontrol if image saved successful

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
      if(buttonIndex==0) [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(alertView.tag==1011){
        SHKItem *item = [SHKItem image:willSaveImage title:[NSString stringWithFormat:@"I got the '%@' app from App Store and created this.",SHKMyAppName]];
        
        switch (buttonIndex) {
            case 1:
                [SHKTwitter shareItem:item];
                break;
            case 2:
                [SHKTwitter logout];
                [SHKTwitter shareItem:item];
                break;
            default:
                break;
        }
    }
}
-(void)saveFn:(UIButton *)sender{
    if(!isFinalImageSaved) [self mergeImages];
    UIImageWriteToSavedPhotosAlbum(self.willSaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);   
    [Appirater userDidSignificantEvent:YES];
}
- (void)saveCallBack:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }else{
        isFinalImageSaved=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Saved to Photo Album!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil  , nil];
        alert.tag=1;
        [alert show];
        [alert autorelease];
    }
}
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }else{
        isFinalImageSaved=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Saved to Photo Album!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil  , nil];
        alert.tag=2;
        
        [alert show];
        [alert autorelease];
    }
}

-(void)mergeImages{
    
    UIGraphicsBeginImageContextWithOptions(filterFrame.size, self.finalImageView.opaque, 2);
    
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
   
    CGFloat aspectRatio=finalImageView.image.size.height/finalImageView.image.size.width;
    CGFloat offset= (self.finalImageView.frame.size.height- finalImageView.frame.size.width*aspectRatio)/2.0f;
    
    CGContextTranslateCTM(resizedContext, 0, - offset);
    
	[self.finalImageView.layer renderInContext:resizedContext];
	[self.filterFrameView.image drawInRect:self.filterFrame]; 
    self.willSaveImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
}

-(void)mailFn:(UIButton *)sender{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.navigationBar.tintColor=[UIColor lightGrayColor];
    controller.mailComposeDelegate = self;
 
    [controller setSubject:@"Check out my photo!"];

    [controller setMessageBody:[NSString stringWithFormat:@"I got the '%@' app from App Store and created this.",SHKMyAppName] isHTML:NO];
    
    if(!self.willSaveImage){
        [self mergeImages];
    }
    NSData *imageData = UIImageJPEGRepresentation(self.willSaveImage, 1);
    
    [controller addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"catImage.jpg"];
    
    if (controller) [self presentModalViewController:controller animated:YES];
    
    
    [controller release];
}

-(void)facebookFn{
     //check network
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.facebook.com"];
	NetworkStatus status = [reach currentReachabilityStatus];
	
	switch (status) {
		case NotReachable:{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
                                                             message:@"Failed connect internet" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
			[alert show];
            return;
		}
			break;
		default:
			break;
	}
    
    if(!willSaveImage){
        [self mergeImages];
    }

    SHKItem *item = [SHKItem image:willSaveImage title:[NSString stringWithFormat:@"I got the '%@' app from App Store and created this.",SHKMyAppName]];

    [SHKFacebook shareItem:item];
    
    
}

-(void)twitterFn{
    //check network
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.twitter.com"];
	NetworkStatus status = [reach currentReachabilityStatus];
	
	switch (status) {
		case NotReachable:{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Alert" 
                                                             message:@"Failed connect internet" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
           
			[alert show];
            return;
		}
			break;
		default:
			break;
	}

    
    if(!willSaveImage){
        [self mergeImages];
    }
    
    SHKItem *item = [SHKItem image:willSaveImage title:[NSString stringWithFormat:@"I got the '%@' app from App Store and created this.",SHKMyAppName]];
    
    SHKTwitter *twitter=[[[SHKTwitter alloc]init] autorelease];
    if([twitter isAuthorized]){
        UIAlertView *changeTwitterAccountAlertView=[[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Share this photo with friends!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",@"Use another account", nil] autorelease];
        changeTwitterAccountAlertView.tag=1011;
        [changeTwitterAccountAlertView show];
    }else{
        [SHKTwitter logout];
        [SHKTwitter shareItem:item];
    }
    }


    
- (void)viewDidUnload
{
    self.finalImageView=nil;
    
    self.catFilterView=nil;

    self.willSaveImage=nil;
    
    self.tbar=nil;
    
    self.filterFrameView=nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [finalImageView release];
    [catFilterView release];
    [filterFrameView release];
    [tbar release];
    [willSaveImage release];
}
@end
