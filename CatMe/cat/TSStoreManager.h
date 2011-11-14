//
//  TSStoreManager.h
//
//***************************************
//*                                     *
//* TactSky In-App Purchase component   *
//*                                     *
//***************************************
//
//  Created by jack on 11-10-14.
//  Copyright (c) 2011 TactSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "TSStoreObserver.h"

@protocol TSStoreKitDelegate <NSObject>
@optional
- (void)productCatsPurchased;
- (void)productFiltersPurchased;
- (void)failed;
@end

BOOL featureCatsPurchased;
BOOL featureFiltersPurchased;

static NSString *featureCatsId = @"paidCatsIcons";
static NSString *featureFiltersId = @"test2";

@interface TSStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	TSStoreObserver *storeObserver;	

	id<TSStoreKitDelegate> delegate;
}

@property (nonatomic, retain) id<TSStoreKitDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) TSStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeatureCats; // expose product buying functions, do not expose
- (void) buyFeatureFilters; // your product ids. This will minimize changes when you change product ids later

// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;

-(void)paymentCanceled;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (TSStoreManager*)sharedManager;

+ (BOOL) featureCatsPurchased;
+ (BOOL) featureFiltersPurchased;

+(void) loadPurchases;
+(void) updatePurchases;

@end
