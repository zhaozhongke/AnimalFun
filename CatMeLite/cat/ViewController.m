//
//  ViewController.m
//  cat
//
//  Created by jack on 11-9-17.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import "ViewController.h"
#import "ArticleViewController.h"
#import "PhotoCache.h"
#import "MoreGame.h"

@implementation ViewController

@synthesize imagePicker,catViewController;

- (void)didReceiveMemoryWarning
{
//    [self.imagePicker dismissModalViewControllerAnimated:NO];
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(IBAction)click:(UIButton *)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
    }else{
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    if (IsIpad) {// ipad version
        
        [popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }else{
        
        [self presentModalViewController:self.imagePicker animated:YES];
    }
    
    
   
}



-(IBAction)photoAlbum:(UIButton *)sender{    
    self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    if (IsIpad) {// ipad version      
        [popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }else{
        
        [self presentModalViewController:self.imagePicker animated:YES];
    }
    
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [imagePicker dismissModalViewControllerAnimated:NO];
    [popoverController dismissPopoverAnimated:YES];

    UIImage *image =[info valueForKey:UIImagePickerControllerEditedImage];
    
    PhotoCache *pc=[[PhotoCache alloc]initWithImage:image]; 
    if(!catViewController){
        [self performSelectorOnMainThread:@selector(loadCatIcons) withObject:nil waitUntilDone:NO];
    }

    catViewController.isFirstAppearFlag=YES;
    catViewController.pc.storedImage=nil;
    catViewController.pc=pc;
    [self.navigationController pushViewController:catViewController animated:YES];
    
    [pc release];

 
}

 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissModalViewControllerAnimated:YES];
    [popoverController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(loadCatIcons) withObject:nil];
    
    //set home page background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-hp.png"]];
   
    self.view.backgroundColor = background;
    [background release];

    //set button high-lighted image
    UIImage *btnImage=[UIImage imageNamed:@"button-highlighted.png"] ;
    
    [btCamera setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    [btPhotoAlbum setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    [btnMoreApps setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    
    imagePicker=[[UIImagePickerController alloc]init];
    
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    imagePicker.navigationBar.tintColor=[UIColor lightGrayColor];
   
    if (IsIpad)
        popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];   
}
    

- (void)viewDidUnload
{
    btCamera=nil;
    btPhotoAlbum=nil;
    btnMoreApps=nil;
    if (IsIpad) popoverController=nil;

    [super viewDidUnload];
}
-(void)dealloc{
    if (IsIpad) [popoverController release];
    [btCamera release];
    [btPhotoAlbum release];
    [btnMoreApps release];
    
    [imagePicker release];
    [catViewController release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.catViewController){
//        self.catViewController.imageView.image=nil;
    }
    [super viewDidAppear:animated];
}

-(void)loadCatIcons{
    NSAutoreleasePool *alp=[[NSAutoreleasePool alloc]init];
    
    self.catViewController=[[ArticleViewController alloc]init];
    
    for(int i=0;i<TSTotalIcons;i++){
         NSString *imageName = [NSString stringWithFormat:@"icon_cat%d.png", i+1];
        UIImage *image3 = [UIImage imageNamed:imageName];
        [self.catViewController.catIconsArrays addObject:image3];
       
    }
     [alp release];
  
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

  return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}
-(IBAction)moreApps:(UIButton *)sender{
    MoreGame *mg=[[MoreGame alloc]initWithNibName:@"MoreGame" bundle:nil];
    [self presentModalViewController:mg animated:YES];
    [mg release];
}
@end
