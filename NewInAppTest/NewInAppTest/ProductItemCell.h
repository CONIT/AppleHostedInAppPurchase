//
//  ProductItemCell.h
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *productIdLbl;
@property (nonatomic, strong) IBOutlet UIButton *backImgBtn;

@end
