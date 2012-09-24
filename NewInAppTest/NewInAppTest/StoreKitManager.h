//
//  StoreKitUtil.h
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@protocol StoreKitManagerDelegate <NSObject>
@optional
- (void)successPayment:(NSString *)aProductId receipt:(NSData *)aReceipt;
- (void)failedPayment:(BOOL)isCancel;
- (void)receiveProduct:(SKProduct *)aProduct;
- (void)restoreItem:(NSString *)aProductId receipt:(NSData *)aReceipt;
- (void)downloadFinished:(NSString *)aPath;
- (void)finishedRestore;
- (void)failedRestore;
@end

@interface StoreKitManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, weak) id <StoreKitManagerDelegate> delegate_;

- (void)requestProduct:(NSSet *)aProductSet;
- (void)requestPurchase:(SKProduct *)aProduct;
- (void)requestRestore;
- (void)removeTransaction;

@end
