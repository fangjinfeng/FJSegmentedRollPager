//
//  FJContentPageBaseViewController.h
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJContentPageBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

// 当前 索引
@property (nonatomic, assign) NSInteger   currentIndex;
// tableView
@property (nonatomic, strong) UITableView *tableView;
// 参数
@property (nonatomic, strong) id viewControllerParam;

@end
