//
//  ViewController.m
//  FJSegmentedRollPageDemo
//
//  Created by fjf on 2017/9/29.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "FJConfigModel.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self configViewControllerModelArray];
}


// 配置 课程 列表  数组
- (void)configViewControllerModelArray {
    NSMutableArray *tmpArray = [NSMutableArray array];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列课程" viewControllerStr:@"FJSecondShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列课程" viewControllerStr:@"FJSecondShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列课程" viewControllerStr:@"FJSecondShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列课程" viewControllerStr:@"FJSecondShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列简介" viewControllerStr:@"FJFirstShopViewController"]];
    [tmpArray addObject:[[FJConfigModel alloc] initWithTitleStr:@"系列课程" viewControllerStr:@"FJSecondShopViewController"]];
    self.configModelArray = tmpArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
