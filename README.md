# FJSegmentedRollPager

#简书链接: ![FJSegmentedRollPager 介绍](http://www.jianshu.com/p/b29d1f5bd69c)

# 效果图:

![滚动栏.gif](http://upload-images.jianshu.io/upload_images/2252551-bf5ad6725da7fd87.gif?imageMogr2/auto-orient/strip)

![FJSegmentedRollPager.gif](https://github.com/fangjinfeng/FJSegmentedRollPager/blob/master/FJSegmentedRollPageDemo/Snapshots/FJSegmentedRollPager.gif)

**需求:**
- 分类栏和搜索框作为一个整体，视作页面的头部，同时每个分类下面对应一个分类页面

- 分类栏下面的页面可左右滚动，同时分类栏定位到当前滚动的分类，同理点击分类栏上的分类，分类栏下面的分类也滚动到对应位置。

- 滚动分类栏下面的分类页面：向上滚动，页面头部向上滚直到搜索框遮住，卡住分类栏；向下滚动，将页面头部移动逐渐显示出搜索框和分类栏直至显示完全。

# 一. 思路
- 将分类栏和搜索框作为一个头部整体叫做``FJNavigationHederView``，其中分类栏用``UICollectionView``来写,叫做``FJSegmentdTitleTagSectionView``。

- 分类栏对应的分类页面也用``UICollectionView``来写,叫做``FJSegmentedPageDetailContentView``，而``UICollectionViewCell``则对应每个分类页面是一个单独的``FJContentPageBaseViewController``。

- 将``FJNavigationHederView``和``FJSegmentedPageDetailContentView``放置在分类基类``FJBaseCourseClassifyViewController``页面里面。

- 将分类页面``FJContentPageBaseViewController``的``tableView``的``contentInset``设置偏移距离为头部高度，同时将``tableView``的frame向上偏移搜索栏高度。

- 当滚动分类页面``FJContentPageBaseViewController``的``tableView``发出通知，通知分类基类``FJBaseCourseClassifyViewController``当前移动的距离，分类基类``FJBaseCourseClassifyViewController``根据当前移动的距离，判断移动的放下同时也通过改变``FJNavigationHederView``的transform来进行头部的移动和卡位。

- 左右方向的滚动则通过``FJSegmentdTitleTagSectionView``和``FJSegmentedPageDetailContentView``内部的UICollectionView的代理来进行判断以达到同步。

# 二. 实现

### **FJBaseCourseClassifyViewController**

最外围的视图层包含:


    // navigation view
    @property (nonatomic, strong) FJNavigationHederView *navigationHederView;

    // detail contentView
    @property (nonatomic, strong) FJSegmentedPageDetailContentView *detailContentView;

导航栏头部和分类页面。

该界面主要处理分类页面``FJContentPageBaseViewController``的``tableView``的滚动通知以及头部的分类栏和分类页面滚动之后对应到统一的分类下面。

**1. 分类页面``FJContentPageBaseViewController``的``tableView``的滚动通知处理**

    #pragma mark --- noti method


    // 偏移 通知
    - (void)scrollViewDidOffset:(NSNotification *)noti {
        if ([noti.name isEqualToString:kFJCourseClassifySubScrollViewDidScrollNoti]) {
            UIScrollView *scrollView = (UIScrollView *)noti.object;
            [self subScrollViewDidScroll:scrollView];
        }
    }


    - (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
        CGFloat bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
        if (scrollView.contentOffset.y > -kFJCourseNavigationHeaderViewHeight && bottomOffset > 0) {
            CGFloat offsetY = scrollView.contentOffset.y - _originalOffsetY;
            [self moveNavigationBarAndStatusBarByOffsetY:offsetY];
        }
        _originalOffsetY = scrollView.contentOffset.y;
    }

收到分类页面``FJContentPageBaseViewController``的``tableView``的滚动通知后判断当前分类页面是否可以进行滚动，如果可以依据之前滚动位置的值，判断出当前滚动的方向然后调用``moveNavigationBarAndStatusBarByOffsetY:``方法去判断头部的变化。

>备注: 具体参考[UINavigationBar和UITabBar 上滚渐变显示 下拉渐变隐藏](http://www.jianshu.com/p/435b49da4c95)

**2. 分类栏和分类页面滚动和点击事件处理**

    #pragma mark --- custom delegate

    /******************************* FJSegmentdTitleTagSectionViewDelegate ******************************/

    - (void)titleSectionView:(FJSegmentdTitleTagSectionView *)titleSectionView clickIndex:(NSInteger)index {
         self.detailContentView.selectedIndex = index;
    }  


    /******************************* FJDetailContentViewDelegate ******************************/
    - (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView selectedIndex:(NSInteger)selectedIndex {
    
        self.navigationHederView.tagSecionView.selectedIndex = selectedIndex;
    }

    // 是否 偏移 顶部 导航栏
    - (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView isOffsetNavigationHeaderView:(BOOL)isoffSet {
        [self showNavigationBarAndStatusBar];
    }

    // 获取 导航栏 移动 距离
    - (CGFloat)navigationTransformTyWithDetailContentView:(FJSegmentedPageDetailContentView *)detailContentView {
        return self.navigationHederView.transform.ty;
    }

通过代理来同步分类栏和分页页面两个``UICollectionView``的同步问题。

同时这里也解决一个问题: 就是当导航栏卡住了分类栏(搜索栏已经隐藏)，这时如果进行滚动切换到另一个类别下面就必须判断当前类别是否可以滚动，如果可以不可以滚动，将导航栏全部显示，如果可以滚动，判断当前 ``tableView``位置，如果``tableView``已经向上移动，则不需要移动位置，如果没有向上移动，则需要将 ``tableView``的``contentOffset``向上移动。

**3. 状态栏点击回到顶部通知**

    // 点击 返回 到 顶部view
    - (UIView *)scrollToTopTapView {
        if (!_scrollToTopTapView) {
            _scrollToTopTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0f)];
            _scrollToTopTapView.userInteractionEnabled = YES;
            [_scrollToTopTapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postScrollToTopViewNoti)]];
            _scrollToTopTapView.backgroundColor = [UIColor clearColor];
        }
        return _scrollToTopTapView;
    }

    /**
     用KVC取statusBar
     @return statusBar
     */
    - (UIView *)statusBar {    
        return [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    }

    - (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [[self statusBar] addSubview:self.scrollToTopTapView];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

    - (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
        [self.scrollToTopTapView removeFromSuperview];
    }

因为分类类别``tableView``不在最外层的视图上，所以类别``tableView``的``scrollToTop``属性就没法起作用，因此需要自己添加视图和点击事件以及发送相关通知给类别``tableView``。

###  **FJContentPageBaseViewController**

分类类别页面主要负责展示当前分类信息，设置tableView的偏移同时将滚动信息通知给``FJBaseCourseClassifyViewController``，接收返回顶部通知。

**1. tableView的设置**

    // tableView
    - (UITableView *)tableView {
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kFJNavigationHederViewContentOffset, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.scrollsToTop = YES;
            _tableView.showsVerticalScrollIndicator = NO;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.backgroundColor = kFJTableViewBackgroundColor;
            _tableView.contentInset = UIEdgeInsetsMake(kFJCourseNavigationHeaderViewHeight, 0, 0, 0);
        }
        return _tableView;
    }

``tableView`` 设置``frame``和``contentInset``的偏移量，同时兼容``iOS11``系统。这里偏移量的设置主要是为了让滚动过程中导航头部和分类内容页保持一致效果。

**2. 滚动消息通知**

    /************************ UIScrollViewDelegate **********************/

    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{

        if (self.isStopPostScrollNoti == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewDidScrollNoti object:scrollView];
        }
    }

这里的``isStopPostScrollNoti``是为了判断：如果是当导航栏卡住了分类栏(搜索栏已经隐藏)，这时进行滚动切换到另一个类别引起的当前``tableView``滚动就不需要发送通知。

**3. 点击状态栏回到顶部通知**

    #pragma mark --- noti method

    // 滚动 到 顶部
    - (void)tableViewScrollToTop:(NSNotification *)noti {
        if ([noti.name isEqualToString:kFJCourseClassifySubScrollViewScrollToTopNoti]) {
            NSString *selectedIndex = (NSString *)noti.object;
            if ([selectedIndex isKindOfClass:[NSString class]]) {
                if ([selectedIndex integerValue] == self.currentIndex) {
                    [self scrollToTopAnimated:YES];
                }
            }
        }
    }

接到状态栏的点击事件通知后，返回判断当前类别索引是否和自己的匹配，然后``tableView``返回顶部。

### **FJSegmentdTitleTagSectionView**

分类栏最主要利用``UICollectionView``展示分类信息，同时处理和分类内容页面的同步问题。

这里最主要的难点就是处理当分类类别不超过屏幕宽度则进行宽度平分，超过屏幕宽度则设置左右间距和中间间距的问题，同时保持指示条的准确。

    // 是否 超过 屏幕宽度 限制
    - (void)beyondWidthLimitWithTitleArray:(NSArray *)titleArray {
        self.isBeyondLimitWidth = NO;
        CGFloat tmpWidth = kFJSegmentdTitleTagSectionViewCellSpacing;
        for (NSString *tmpTitle in titleArray) {
            tmpWidth += [self titleWidthWithTitle:tmpTitle];
            tmpWidth += kFJSegmentdTitleTagSectionViewCellSpacing;
        }
    
        if (tmpWidth > self.frame.size.width) {
            self.isBeyondLimitWidth = YES;
        }
    }
判断是否超过屏幕宽度，根据判断结果，设置左右边距和``UICollectionViewCell``的间距

    - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
    {
        CGFloat edgeSpacing = 0;
        if (self.isBeyondLimitWidth) {
            edgeSpacing = kFJSegmentdTitleTagSectionViewHorizontalEdgeSpacing;
        }
        return UIEdgeInsetsMake(0, edgeSpacing, 0, edgeSpacing);
    }


    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        CGSize tmpSize = CGSizeZero;
        if (self.isBeyondLimitWidth == NO) {
            tmpSize = CGSizeMake(self.frame.size.width / self.tagTitleArray.count, self.frame.size.height);
        }
        else {
            NSString *titleStr = self.tagTitleArray[indexPath.row];
            CGFloat titleWidth = [titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFJSegmentedTitleFontSize} context:nil].size.width;
            tmpSize = CGSizeMake(titleWidth, self.frame.size.height);
        }
        return tmpSize;
    }
  
保证``indicatorView``指示器位置的准确:

    // 更新 指示view  宽度
    - (void)updateIndicatorWidthWithSelectedIndex:(NSInteger)selectedIndex {
        NSString *tagTitle = [self.tagTitleArray objectAtIndex:selectedIndex];
    
        CGFloat titleWidth = [tagTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFJSegmentedTitleFontSize} context:nil].size.width;
    
        self.indicatorWidth = titleWidth + 5;
        self.indicatorView.width = self.indicatorWidth;
    
        if (self.isBeyondLimitWidth) {
            //获取cell
            UICollectionViewCell *cell = [self.tagCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
            //获取cell在当前collection的位置
            CGRect cellInCollection = [self.tagCollectionView convertRect:cell.frame toView:self.tagCollectionView];
        
            //获取cell在当前屏幕的位置
            CGRect cellInSuperview = [self.tagCollectionView convertRect:cellInCollection toView:self];
        
            CGFloat indicatorViewX = cellInSuperview.origin.x- 2.5;
            if (indicatorViewX < 0) {
                indicatorViewX = kFJSegmentdTitleTagSectionViewHorizontalEdgeSpacing - 2.5;
            }
            self.indicatorView.x = indicatorViewX;
        }
        else {
            CGFloat cellWidth = self.frame.size.width / self.tagTitleArray.count;
            self.indicatorView.x = cellWidth * selectedIndex + cellWidth/2.0 - self.indicatorView.frame.size.width/2.0;
        }
    }

### **FJSegmentedPageDetailContentView**
分类内容视图最主要利用UICollectionView展示类别内容信息，同时处理和分类头部同步以及导航头部是否进行偏移问题。

导航头部偏移问题就是上文提到的:当导航栏卡住了分类栏(搜索栏已经隐藏)，这时如果进行滚动切换到另一个类别下面就必须判断当前类别是否可以滚动，如果可以不可以滚动，将导航栏全部显示，如果可以滚动，判断当前 tableView位置，如果tableView已经向上移动，则不需要移动位置，如果没有向上移动，则需要将 tableView的contentOffset向上移动。


    - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        if(self.delegate && [self.delegate respondsToSelector:@selector(detailContentView:scrollView:)]){
            [self.delegate detailContentView:self scrollView:scrollView];
        }
        NSInteger index = (NSInteger)roundf(scrollView.contentOffset.x / self.pageCollectionView.frame.size.width);
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailContentView:selectedIndex:)]) {
            [self.delegate detailContentView:self selectedIndex:index];
            if (self.viewControllerArray.count > 0) {
               FJContentPageBaseViewController *baseViewController = self.viewControllerArray[index];
            
                if (baseViewController.tableView.contentOffset.y < -kFJNavigationSearchViewHeight) {
                    CGFloat tranformTy = [self.delegate navigationTransformTyWithDetailContentView:self];
                    if (baseViewController.tableView.contentSize.height > baseViewController.tableView.height && tranformTy < 0) {
                    
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewOffsetNoti object: [NSNumber numberWithBool:YES]];
                        CGPoint contentOffset = baseViewController.tableView.contentOffset;
                        contentOffset.y = -kFJCourseNavigationHeaderViewHeight - tranformTy;
                        baseViewController.tableView.contentOffset = contentOffset;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewOffsetNoti object: [NSNumber numberWithBool:NO]];
                    }
                    else {
                        [self setIsOffsetNavigationHeaderViewDelegateWithIsOffset:NO];
                    }
                }
            }
        }
    }

# 三. demo 

demo效果图:

![FJSegmentedRollPager.gif](http://upload-images.jianshu.io/upload_images/2252551-a4a82c4cb7f40a3d.gif?imageMogr2/auto-orient/strip)

>github 下载地址: [FJSegmentedRollPager](https://github.com/fangjinfeng/FJSegmentedRollPager)

demo 相关属性都可以在``FJCourseClassifyDefine.h``文件里面进行更改！
