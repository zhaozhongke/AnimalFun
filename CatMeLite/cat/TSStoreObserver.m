//
//  TSStoreObserver.m
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

#import "TSStoreObserver.h"
#import "TSStoreManager.h"

@implementation TSStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
            
            case SKPaymentTransactionStatePurchasing:
                
                break;
			case SKPaymentTransactionStatePurchased:
				
                [self completeTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateFailed:
				
                [self failedTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateRestored:
				
                [self restoreTransaction:transaction];
				
            default:
				
                break;
		}			
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"The error description is:%@",[transaction.error description]);
    if (transaction.error.code != SKErrorPaymentCancelled)		
    {		
        if(transaction.error.code == SKErrorUnknown) {
            NSLog(@"Unknown Error (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorClientInvalid) {
            NSLog(@"Client invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorPaymentInvalid) {
            NSLog(@"Payment invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorPaymentNotAllowed) {
            NSLog(@"Payment not allowed (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
    }	
    
    
	[[TSStoreManager sharedManager] paymentCanceled];
   
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{		
    [[TSStoreManager sharedManager] provideContent: transaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{	
    [[TSStoreManager sharedManager] provideContent: transaction.originalTransaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}

@end
