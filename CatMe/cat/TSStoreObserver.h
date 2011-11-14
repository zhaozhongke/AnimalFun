//
//  TSStoreObserver.h
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

@interface TSStoreObserver : NSObject<SKPaymentTransactionObserver> {

	
}
	
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

@end
