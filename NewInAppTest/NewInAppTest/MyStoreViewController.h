//
//  MyStoreViewController.h
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStoreViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *productTable;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, weak) id target;

@end
