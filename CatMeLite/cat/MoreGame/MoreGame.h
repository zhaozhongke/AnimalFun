//
//  MoreGame.h
//  photosearch
//
//  Created by Ryan Chui on 11-10-14.
//  Copyright 2011 TactSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "Reachability.h"

@interface MyAppToolBar2 : UIToolbar{
}

@end

@protocol DownloadTakDelegate <NSObject>

-(void)downFinish:(NSData*)data operationId:(int)oId;

@end

@interface DownloadTask : NSObject{ 
    int _operationId; 
    NSString *_urlString;
    NSURLConnection *_connection;
    NSMutableData *_downloadData;
    id <DownloadTakDelegate> _delegate;
}
@property int operationId;
@property(assign) id <DownloadTakDelegate> delegate;
-(id)initWithUrl:(NSString*)urlString operationId:(int)oId;
@end

@interface MoreGame : UIViewController <DownloadTakDelegate>{
    NSArray *_data;
    Reachability *_hostReach;
    UIImage *_notConnect;
    UITableView *_tableView;
    UIView *_connectFailView;
    NSMutableArray *_taskArray;
    NSMutableArray *_imageArray;
    NSMutableArray *_aiVArray;
    UIActivityIndicatorView *_progressInd;
    
}
@property(nonatomic,retain) IBOutlet UIView *connectFailView;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UIToolbar *tbar;
@property(nonatomic,retain) IBOutlet UILabel *moreAppsLabel;
-(IBAction)clickCancel:(id)sender;
-(void)downStart;
-(bool)isHaveThisTaskInQueue:(int)oId;
-(void)configReachability;
-(void)updateInterfaceWithReachability:(Reachability *)curReach;
+ (NSArray *)fetchLibraryInformation;
+ (id)fetchJSONValueForURL:(NSURL *)url;
@end
