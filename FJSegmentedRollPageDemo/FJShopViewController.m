//
//  FJShopViewController.m
//  FJSegmentedRollPageDemo
//
//  Created by fjf on 2017/11/7.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "FJConfigModel.h"
#import "FJShopViewController.h"

@interface FJShopViewController ()

@end

@implementation FJShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewControllerModelArray];
}


// 配置 课程 列表  数组
- (void)configViewControllerModelArray {
    NSMutableArray *tmpArray = [NSMutableArray array];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺课程" viewControllerStr:@"FJSecondShopViewController"]];
    if (self.isBeyondScreenWidth) {
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺商品" viewControllerStr:@"FJFirstShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺推荐" viewControllerStr:@"FJSecondShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"VIP" viewControllerStr:@"FJFirstShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"大礼包" viewControllerStr:@"FJSecondShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺专栏" viewControllerStr:@"FJFirstShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺特色" viewControllerStr:@"FJSecondShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"免费" viewControllerStr:@"FJFirstShopViewController"]];
        [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"店铺主打" viewControllerStr:@"FJSecondShopViewController"]];
        
    }
   
    self.configModelArray = tmpArray;
}


@end
