//
//  ProductDetailViewController.h
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKitManager.h"

@interface ProductDetailViewController : UIViewController<StoreKitManagerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLbl;
@property (nonatomic, strong) IBOutlet UILabel *priceLbl;
@property (nonatomic, strong) IBOutlet UIButton *buyBtn;
@property (nonatomic, strong) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) IBOutlet UITextView *productDescriptionText;
@property (nonatomic, strong) IBOutlet UIImageView *productImage;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) SKProduct *productInfo;
@property (nonatomic, strong) StoreKitManager *storeKitManager;

@end
