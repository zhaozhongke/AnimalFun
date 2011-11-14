////  TSStoreManager.m////***************************************//*                                     *//* TactSky In-App Purchase component   *//*                                     *//***************************************////  Created by jack on 11-10-14.//  Copyright (c) 2011 TactSky. All rights reserved.//#import "TSStoreManager.h" @implementation TSStoreManager@synthesize purchasableObjects;@synthesize storeObserver;@synthesize delegate;static TSStoreManager* _sharedStoreManager; // self- (void)dealloc {		[_sharedStoreManager release];	[storeObserver release];	[super dealloc];}+ (BOOL) featureCatsPurchased {		return featureCatsPurchased;}+ (BOOL) featureFiltersPurchased {		return featureFiltersPurchased;}+ (TSStoreManager*)sharedManager{	@synchronized(self) {		        if (_sharedStoreManager == nil) {			            _sharedStoreManager=[[self alloc] init]; // assignment not done here			_sharedStoreManager.purchasableObjects = [[[NSMutableArray alloc] init] autorelease];						[_sharedStoreManager requestProductData];						[TSStoreManager loadPurchases];			_sharedStoreManager.storeObserver = [[[TSStoreObserver alloc] init] autorelease];			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];        }    }    return _sharedStoreManager;}#pragma mark Singleton Methods+ (id)allocWithZone:(NSZone *)zone{	    @synchronized(self) {		        if (_sharedStoreManager == nil) {			            _sharedStoreManager = [super allocWithZone:zone];			            return _sharedStoreManager;  // assignment and return on first allocation        }    }	    return nil; //on subsequent allocation attempts return nil	}- (id)copyWithZone:(NSZone *)zone{    return self;	}- (id)retain{	    return self;	}- (unsigned)retainCount{    return UINT_MAX;  //denotes an object that cannot be released}- (void)release{    //do nothing}- (id)autorelease{    return self;	}- (void) requestProductData{	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 								 [NSSet setWithObjects: featureCatsId, featureFiltersId, nil]]; // add any other product here	request.delegate = self;	[request start];    [request autorelease];    }- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{	[purchasableObjects addObjectsFromArray:response.products];	// populate your UI Controls here	for(int i=0;i<[purchasableObjects count];i++)	{				SKProduct *product = [purchasableObjects objectAtIndex:i];		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],			  [[product price] doubleValue], [product productIdentifier]);	}	//	[request autorelease];}- (void) buyFeatureCats{	[self buyFeature:featureCatsId];}- (void) buyFeature:(NSString*) featureId{	if ([SKPaymentQueue canMakePayments])	{	        SKMutablePayment *mutablePayment = [[[SKMutablePayment alloc]init ]autorelease];        mutablePayment.productIdentifier=featureId;        		[[SKPaymentQueue defaultQueue] addPayment:mutablePayment];                NSLog(@"add payment to SKPaymentQueue, buying ... ");        	}	else	{		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You are not authorized to purchase from AppStore"													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];		[alert show];	}}- (void) buyFeatureFilters{	[self buyFeature:featureFiltersId];}-(void)paymentCanceled{	if([delegate respondsToSelector:@selector(failed)])		[delegate failed];}- (void) failedTransaction: (SKPaymentTransaction *)transaction{	if([delegate respondsToSelector:@selector(failed)])		[delegate failed];		NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];	[alert show];}-(void) provideContent: (NSString*) productIdentifier{	if([productIdentifier isEqualToString:featureCatsId])	{		featureCatsPurchased = YES;		if([delegate respondsToSelector:@selector(productCatsPurchased)])			[delegate productCatsPurchased];	}	if([productIdentifier isEqualToString:featureFiltersId])	{		featureFiltersPurchased = YES;		if([delegate respondsToSelector:@selector(productFiltersPurchased)])			[delegate productFiltersPurchased];	}		[TSStoreManager updatePurchases];}+(void) loadPurchases {	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];		featureCatsPurchased = [userDefaults boolForKey:featureCatsId]; 	featureFiltersPurchased = [userDefaults boolForKey:featureFiltersId]; 	}+(void) updatePurchases{	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	[userDefaults setBool:featureCatsPurchased forKey:featureCatsId];	[userDefaults setBool:featureFiltersPurchased forKey:featureFiltersId];}@end