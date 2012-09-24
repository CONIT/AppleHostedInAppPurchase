//
//  MyStoreViewController.m
//  NewInAppTest
//
//  Created by Jun ichikawa on 12/09/20.
//  Copyright (c) 2012年 Jun ichikawa. All rights reserved.
//

#import "MyStoreViewController.h"
#import "ProductItemCell.h"
#import "ProductDetailViewController.h"

@interface MyStoreViewController ()

@end

@implementation MyStoreViewController


#pragma mark - 画面遷移前イベント
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)aBtn
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showPruductSegue"]) {
        ProductDetailViewController *productDetail = [segue destinationViewController];
        productDetail.productId = ((ProductItemCell*)aBtn).productIdLbl.text;
        if( productDetail.productId == nil )
            return;
        self.target = productDetail;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"product count:%d", self.productArray.count);
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // プロダクト情報セル
    static NSString *CellIdentifier = @"productitemCell";
    NSInteger row = indexPath.row;
    NSMutableDictionary *dic = [self.productArray objectAtIndex:row];
    if (!dic) {
        NSLog(@"error: プロダクト情報取得失敗: %d", row);
        return [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    ProductItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    // タイトル
    cell.titleLbl.text = [dic objectForKey:@"title"];
    // プロダクトID
    cell.productIdLbl.text = [dic objectForKey:@"productId"];
    
    return cell;

}

#pragma mark - テーブル再描画
- (void)reloadTable
{
    [self.productTable reloadData];
}

#pragma mark - プロダクト一覧表示
- (void)showProductList
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"InAppProducts" ofType:@"plist"];
    NSLog(@"path:%@", plistPath);
    self.productArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    // テーブル再描画
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // プロダクトリストの表示
    [self performSelectorInBackground:@selector(showProductList) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
