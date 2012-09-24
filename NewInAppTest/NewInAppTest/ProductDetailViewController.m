//
//  ProductDetailViewController.m
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController


- (void) requestProductInfo
{
    NSSet *productSet = [NSSet setWithObject:self.productId];
    self.storeKitManager.delegate_ = self;
    [self.storeKitManager requestProduct:productSet];    
}

#pragma mark - StoreKitUtilDelegate
// プロダクト情報リクエスト結果の通知
- (void)receiveProduct:(SKProduct *)aProduct {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 失敗
    if (!aProduct) {
        self.productInfo = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"商品エラー"
                                                        message:@"商品の情報取得に失敗しました"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.productInfo = aProduct;
    self.titleLbl.text = aProduct.localizedTitle;
    self.descriptionLbl.text = aProduct.localizedDescription;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:aProduct.priceLocale];
    self.priceLbl.text = [numberFormatter stringFromNumber:aProduct.price];
    
    self.buyBtn.enabled = YES;
    
}

// 購入成功
- (void)successPayment:(NSString *)aProductId receipt:(NSData *)aReceipt
{
    NSLog(@"%s", __PRETTY_FUNCTION__);    
}

// リストア成功通知（プロダクト毎）
- (void)restoreItem:(NSString *)aProductId receipt:(NSData *)aReceipt
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 購入キャンセル／エラー処理
- (void)failedPayment:(BOOL)isCancel
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.storeKitManager removeTransaction];
    
    // ネットワークエラー
    if (!isCancel) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                        message:@"購入に失敗した可能性があります\n再度お試しください。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)downloadFinished:contentsPath
{
    NSString* plistPath = [NSString stringWithFormat:@"%@/Contents/contents.plist", contentsPath];
    NSLog(@"plist:%@", plistPath);
    NSMutableDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSString* imageName = [dic objectForKey:@"contentImageName"];
    NSLog(@"image name:%@", imageName);
    
    self.productImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Contents/%@", contentsPath, imageName]];
    
    NSLog(@"description name:%@", [dic objectForKey:@"contentDescription"]);
    self.productDescriptionText.text = [dic objectForKey:@"contentDescription"];

}

#pragma mark - Closeボタンタップ
- (IBAction)tapBuyBtn:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // プロダクト購入処理
    [self.storeKitManager requestPurchase:self.productInfo];
}


#pragma mark - Closeボタンタップ
- (IBAction)tapCloseBtn:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"閉じます！");
    }];
}

#pragma mark - System
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];

    self.buyBtn.enabled = NO;
    self.storeKitManager = [[StoreKitManager alloc] init];
    NSLog(@"%@", self.productId);

    // プロダクト情報リクエスト
    [self performSelectorInBackground:@selector(requestProductInfo) withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
