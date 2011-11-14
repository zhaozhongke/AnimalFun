//
//  MoreGame.m
//  photosearch
//
//  Created by Ryan Chui on 11-10-14.
//  Copyright 2011 TactSky. All rights reserved.
//

#import "MoreGame.h"

@implementation DownloadTask

@synthesize operationId = _operationId;
@synthesize delegate = _delegate;

-(id)initWithUrl:(NSString*)urlString operationId:(int)oId{
    if ((self = [super init])) {
        _operationId = oId;
        _connection = nil;
        _urlString = [urlString copy];
    }
    return self;
}
-(void)dealloc{
    [_urlString release];
    [_downloadData release];
    _downloadData= nil;
    [_connection release];
    _connection = nil;
    [super dealloc];
}

- (void)start{ 
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(_connection != nil){
        _downloadData = [[NSMutableData alloc] init];
    }else{
        NSLog(@"download task config fail");
    }
}

#pragma mark - Image Download

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //把每次得到的数据依次放到数组中，这里还可以自己做一些进度条相关的效果
    NSLog(@"downloading");
    [_downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    NSLog(@"download finish");
    NSData *data = [NSData dataWithData:_downloadData];
    [_delegate downFinish:data operationId:_operationId];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"download fail");
    [_delegate downFinish:nil operationId:_operationId];
    [_downloadData release];
    _downloadData= nil;
    
    [_connection release];
    _connection = nil;
}

@end


@implementation MyAppToolBar2

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    UIColor *color = [UIColor colorWithRed:0.547 green:0.344 blue:0.118 alpha:1.000]; //wood tan color
    UIImage *img  = [UIImage imageNamed: @"header_bar_bg.png"];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.tintColor = [UIColor colorWithPatternImage:img];
}

@end

@implementation MoreGame
@synthesize tableView = _tableView,connectFailView=_connectFailView,tbar=_tbar,moreAppsLabel=_moreAppsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

 


- (void)dealloc
{
    [_hostReach stopNotifier];
    [_hostReach release];
    for (int i = 0; i< _taskArray.count; i++) {
         DownloadTask *task = [_taskArray objectAtIndex:i];
         task.delegate = nil;
    }    
    [_taskArray release]; 
    [_aiVArray release];
    [_imageArray release];
    [_data release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

 
    //_data = [[MoreGame fetchLibraryInformation] retain];
    [self configReachability];
    _taskArray = [[NSMutableArray alloc] init];
    _aiVArray =  [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 15; i++) {
        UIActivityIndicatorView *ai =[[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        ai.center = CGPointMake(31, 31);
        [_aiVArray addObject:ai];
    }
    
    _progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _progressInd.frame = CGRectMake(self.view.center.x-20, self.view.center.y-20, 40, 40);
    
}

- (void)viewDidUnload
{   
    [_hostReach stopNotifier];
    [_hostReach release];    
    [_taskArray release];
    [_aiVArray release];
    [_imageArray release];
    [_data release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //NSLog(@"count %d",[_data count]);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[_data valueForKey:[[_data allKeys] objectAtIndex:section]] count];
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
   
    cell.indentationLevel = 6; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *content = [_data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [content objectForKey:@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    cell.textLabel.textColor=  [UIColor colorWithRed:(102* 1.0)/255  green:(79* 1.0)/255 blue:(64* 1.0)/255 alpha: 1.0];
//    cell.textLabel.frame=CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y-120, 120, 124);
    
    CGSize constSize = { 300.0f, 20000.0f };
	CGSize textSize = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constSize lineBreakMode:UILineBreakModeWordWrap];
	CGRect lblRect = CGRectMake(10.0f, 110, 300.0f, textSize.height+textSize.height/3 );
    cell.textLabel.frame=lblRect;
//    UILabel *labelToFit = [[UILabel alloc] initWithFrame:lblRect];
    
    cell.detailTextLabel.text = [content objectForKey:@"description"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.numberOfLines=3;

    NSString *urlString = [content objectForKey:@"imageUrl"];

    //如果有图片则添加，没有则下载
    if (indexPath.row < _imageArray.count) {
        UIImageView *image = [_imageArray objectAtIndex:indexPath.row];
        [cell addSubview:image];
    }else{
        //看有没有重复下载
        if (![self isHaveThisTaskInQueue:indexPath.row]) {
            //添加等待图片
            UIActivityIndicatorView *ai = [_aiVArray objectAtIndex:indexPath.row%15];
            [cell addSubview:ai];
            [ai startAnimating];

            DownloadTask *task = [[[DownloadTask alloc] initWithUrl:urlString operationId:indexPath.row] autorelease] ;
            task.delegate = self;
            [_taskArray addObject:task];
            [self downStart];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *content = [_data objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[content objectForKey:@"appUrl"]];
    [[UIApplication sharedApplication] openURL:url];
    
}

#pragma mark - View Button

//点击取消button
-(IBAction)clickCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Download Delegate

//开启下载队列
-(void)downStart{
    if (_taskArray.count == 1 ) {
        DownloadTask *task = [_taskArray objectAtIndex:0];
        [task start];
    }
}

//查看队列有没有当前任务
-(bool)isHaveThisTaskInQueue:(int)oId{
    for (int i= 0; i<_taskArray.count; i++) {
        DownloadTask *task = [_taskArray objectAtIndex:i];
        if (oId == task.operationId) {
            return YES;
        }
    }
    return NO;
}

//下载完成
-(void)downFinish:(NSData*)data operationId:(int)oId{
    if (data != nil) {
        UIActivityIndicatorView *ai = [_aiVArray objectAtIndex:oId];
        [ai stopAnimating];
        [ai removeFromSuperview];
    }else{
        NSDictionary *content = [_data objectAtIndex:oId];
        NSString *urlString = [content objectForKey:@"imageUrl"];
        DownloadTask *task = [[[DownloadTask alloc] initWithUrl:urlString operationId:oId] autorelease] ;
        task.delegate = self;
        [_taskArray addObject:task];
        [self downStart];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oId inSection:0];
    UITableViewCell *cell =  [_tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(3, 3, 57, 57);
    if (oId < _imageArray.count ) {
        [_imageArray replaceObjectAtIndex:oId withObject:imageView];
    }else{
        [_imageArray addObject:imageView];
        [cell addSubview:imageView];
    }

    [imageView release];
    //删除任务
    [_taskArray removeObjectAtIndex:0];
    if (_taskArray.count>0) {
        DownloadTask *task = [_taskArray objectAtIndex:0];
        [task start];
    }
    
}

-(void)downloadJSonData{
    NSAutoreleasePool *alp = [[NSAutoreleasePool alloc] init];
    _data = [[MoreGame fetchLibraryInformation] retain];
    [self performSelectorOnMainThread:@selector(downloadFinishJSonData) withObject:nil waitUntilDone:NO];
    [alp release];
}

-(void)downloadFinishJSonData{
    [_connectFailView removeFromSuperview];
    _tableView.frame = CGRectMake(0, 44, 320, 416);
    [self.view addSubview:_tableView];
    [_progressInd stopAnimating];
    [_progressInd removeFromSuperview];
}

//查看是否上网
#pragma mark - Reachability

-(void)configReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    [_hostReach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void)updateInterfaceWithReachability:(Reachability *)curReach{
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        [_tableView removeFromSuperview];
        _connectFailView.frame = CGRectMake(0, 44, 320, 416);
        [self.view addSubview:_connectFailView];
    }else{
        [self.view addSubview:_progressInd];
        [_progressInd release];
        [_progressInd startAnimating];
        [NSThread detachNewThreadSelector:@selector(downloadJSonData) toTarget:self withObject:nil];
    }
    
}

#pragma mark - SBJson

+ (NSArray *)fetchLibraryInformation
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.tactsky.com/ws/moreapps"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"fetching library data");
    
    return [self fetchJSONValueForURL:url];
    
}

+ (id)fetchJSONValueForURL:(NSURL *)url

{
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    id jsonValue = [jsonString JSONValue];
    
    [jsonString release];
    
    return jsonValue;
    
}


@end
