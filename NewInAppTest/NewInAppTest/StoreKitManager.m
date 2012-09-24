//
//  StoreKitUtil.m
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import "StoreKitManager.h"


@interface StoreKitManager ()

@end

@implementation StoreKitManager

@synthesize delegate_ = delegate;


// プロダクト情報リクエスト
- (void)requestProduct:(NSSet *)aProductSet
{    
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, aProductSet.description);
    
    // リクエスト
    SKProductsRequest *skProductRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:aProductSet];
    skProductRequest.delegate = self;
    [skProductRequest start];
}

// プロダクト情報リクエスト受信
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (response == nil || [response.products count] == 0) {
        NSLog(@"Product Response is nil");
        if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(receiveProduct:)]) {
            [self.delegate_ receiveProduct:nil];
            return;
        }
    }
    
    // プロダクト情報取り出し
    SKProduct *product = nil;
    if (response.products.count == 1) {
        product = [response.products objectAtIndex:0];
    }
    
    // 結果通知
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(receiveProduct:)]) {
        [self.delegate_ receiveProduct:product];
    }
}

// プロダクト情報リクエスト完了
- (void)requestDidFinish:(SKRequest *)request
{
    request = nil;
}

// 購入リクエスト
- (void)requestPurchase:(SKProduct *)aProduct
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, aProduct.productIdentifier);
    
    // オブザーバ登録
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // リクエスト
    SKPayment *payment = [SKPayment paymentWithProduct:aProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// 復元リクエスト
- (void)requestRestore
{    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // オブザーバ登録
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // リストアのリクエスト
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// リクエストエラー
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError:%@", [error localizedDescription]);
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(failedPayment:)]) {
        [self.delegate_ failedPayment:NO];
    }
    request = nil;
}

// トランザクション破棄
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"paymentQueue:removedTransactions");
}

// 購入成功
- (BOOL)successPayment:(NSString *)aProductId receipt:(NSData *)aReceipt
{    
	NSLog(@"successPayment:%@", aProductId);
    
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(successPayment: receipt:)]) {
        [self.delegate_ successPayment:aProductId receipt:aReceipt];
    }
    return YES;
}

// 購入キャンセル／エラー処理
- (void)failedPayment:(SKPaymentTransaction *)transaction
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *msg = nil;
    switch ([transaction.error code]) {
        case SKErrorUnknown:
            msg = [NSString stringWithFormat:@"未知のエラーが発生しました[%d]", [transaction.error code]];
            break;
        case SKErrorClientInvalid:
            msg = [NSString stringWithFormat:@"不正なクライアントです[%d]", [transaction.error code]];
            break;
        case SKErrorPaymentCancelled:
            msg = [NSString stringWithFormat:@"購入がキャンセルされました[%d]", [transaction.error code]];
            break;
        case SKErrorPaymentInvalid:
            msg = [NSString stringWithFormat:@"不正な購入です[%d]", [transaction.error code]];
            break;
        case SKErrorPaymentNotAllowed:
            msg = [NSString stringWithFormat:@"購入が許可されていません[%d]", [transaction.error code]];
            break;
        default:
            msg = [NSString stringWithFormat:@"%@[%d]", 
                   transaction.error.localizedDescription, 
                   [transaction.error code]];
            break;
    }
    NSLog(@"%@", msg);
    
    // キャンセル（SKErrorUnknownは既に購入済みで再度無料で購入するというポップアップのキャンセル時に来るため）
    if ([transaction.error code] == SKErrorPaymentCancelled
        || [transaction.error code] == SKErrorUnknown) {
        if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(failedPayment:)]) {
            [self.delegate_ failedPayment:YES];
        }
    }
    // エラー
    else {
        if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(failedPayment:)]) {
            [self.delegate_ failedPayment:NO];
        }
    }
}

// リストア成功
- (void)restoreItem:(NSString *)aProductId receipt:(NSData *)aReceipt
{
    NSLog(@"%s:%@", __PRETTY_FUNCTION__, aProductId);
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(restoreItem: receipt:)]) {
        [self.delegate_ restoreItem:aProductId receipt:aReceipt];
    }
}

// リストア終了
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(finishedRestore)]) {
        [self.delegate_ finishedRestore];
    }
}

// リストアエラー
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Payment Restore Transaction Error: %@", [error localizedDescription]);
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(failedRestore)]) {
        [self.delegate_ failedRestore];
    }
}

// ダウンロード終了
- (void)downloadFinished:(NSString *)aPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(downloadFinished:)]) {
        [self.delegate_ downloadFinished:aPath];
    }
}

// 購入処理オブザーバ
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"paymentQueue:updatedTransactions");
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"transactionState[0:Purchasing,1:Purchased,2:failed,3:restore]:%d",transaction.transactionState);
        switch (transaction.transactionState) {
                
                // 購入成功
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"Payment Transaction Purchased: %@", transaction.transactionIdentifier);
                
                [self successPayment:transaction.payment.productIdentifier receipt:transaction.transactionReceipt];
                
                if (transaction.downloads && transaction.downloads.count > 0) {
                    // コンテンツのダウンロード有り
                    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
                }
                else {
                    [queue finishTransaction:transaction];
                }
                break;
            }
                // 購入失敗（キャンセル含む）
            case SKPaymentTransactionStateFailed: {
                NSLog(@"Payment Transaction Failed: %@: %@", transaction.transactionIdentifier, transaction.error);
                [self failedPayment:transaction];
                [queue finishTransaction:transaction];
                break;
            }
                // 購入履歴復元
            case SKPaymentTransactionStateRestored: {
                NSLog(@"Payment Transaction Restored: %@", transaction.transactionIdentifier);
                if (transaction.downloads && transaction.downloads.count > 0) {
                    // コンテンツのダウンロード有り
                    [self restoreItem:transaction.payment.productIdentifier receipt:transaction.transactionReceipt];
                    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
                }
                else {
                    [queue finishTransaction:transaction];
                }
                break;
            }
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"paymentQueue:updatedDownloads");
    for (SKDownload *downloadItem in downloads) {
        switch (downloadItem.downloadState) {
            case SKDownloadStateWaiting: {
                NSLog(@"Download is inactive, waiting to be downloaded");
                break;
            }

            case SKDownloadStateActive: {
                NSLog(@"Download is actively downloading");
                NSLog(@"Download progress:%f", downloadItem.progress);
                NSLog(@"Download timeRemaining:%f", downloadItem.timeRemaining);
                break;
                
            }
                
            case SKDownloadStatePaused: {
                NSLog(@"Download was paused by the user");
                break;
                
            }
                
            case SKDownloadStateFinished: {
                NSLog(@"Download is finished, content is available");
                NSLog(@"Path:%@", [downloadItem.contentURL absoluteString]);

                // ダウンロード完了を通知
                [self downloadFinished:[downloadItem.contentURL path]];
                
                [queue finishTransaction:downloadItem.transaction];
                break;
            }
                
            case SKDownloadStateFailed: {
                NSLog(@"Download failed");
                NSLog(@"error:%@", [downloadItem.error localizedDescription]);
                break;
            }
                
            case SKDownloadStateCancelled: {
                NSLog(@"Download was cancelled");
                
                break;
            }
        }
    }
    
}

- (id)init
{
	self = [super init];
	if (!self) {
		return nil;
	}
    
	return self;
}

- (void)removeTransaction
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
