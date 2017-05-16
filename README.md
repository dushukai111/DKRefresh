# DKRefresh
DKRefresh中支持下拉刷新和上拉加载两种功能，下拉刷新包含三种动画展示方式，分别为箭头动画、gif动画、圆圈旋转动画，上拉加载有两种形式，一种是上拉加载，一种是自动加载。
## 下拉刷新
下拉刷新包含三种方式，第一种是普通的箭头动画，第二种是gif动画，第三种是圆圈旋转动画，下面分别介绍。
#### 普通刷新
        DKRefreshNormalHeaderView *headerView=[DKRefreshNormalHeaderView refreshHeaderWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }];
        //下拉前的状态显示文字，默认值为“下拉刷新..”
        headerView.normalStatusText=@"下拉刷新..";
        //准备刷新时状态文字，默认值为“释放刷新..”
        headerView.prepareRefreshStatusText=@"释放刷新..";
        //正在刷新状态文字，默认值为“正在刷新..”
        headerView.refreshingStatusText=@"正在刷新..";
        //刷新状态label文字颜色，默认为黑色
        headerView.statusTextColor=[UIColor blackColor];
        //是否显示最后刷新时间，默认显示
        headerView.lastRefreshTimeHidden=NO;
        //最后刷新时间label文字颜色，默认为黑色
        headerView.lastTimeTextColor=[UIColor grayColor];
        self.tableView.refreshHeaderView=headerView;

效果图<br>
![image](https://github.com/dushukai111/publicResources/blob/master/DKRefresh_images/refresh_arrow.gif)<br>
#### gif刷新
        DKRefreshGifHeaderView *headerView=[DKRefreshGifHeaderView refreshHeaderWithBlock:^{
            NSLog(@"========");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }];
        headerView.lastRefreshTimeHidden=NO;
        headerView.images=array; //UIImage数组
        self.tableView.refreshHeaderView=headerView;
<br>效果图<br>
![image](https://github.com/dushukai111/publicResources/blob/master/DKRefresh_images/refresh_gif.gif)<br>
#### 小圆圈刷新
        DKRefreshCircleHeaderView *headerView=[DKRefreshCircleHeaderView refreshHeaderWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }];
        headerView.lastRefreshTimeHidden=NO;
        self.tableView.refreshHeaderView=headerView;
<br>效果图<br>
![image](https://github.com/dushukai111/publicResources/blob/master/DKRefresh_images/refresh_circle.gif)<br>
#### 结束刷新
[self.tableView endHeaderRefreshing];
## 上拉加载
#### 普通加载
    DKRefreshFooterView *footerView=[DKRefreshFooterView footerViewWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
        });
    }];
    self.tableView.refreshFooterView=footerView;
<br>效果图<br>
![image](https://github.com/dushukai111/publicResources/blob/master/DKRefresh_images/load_normal.gif)<br>

#### 自动加载
    DKRefreshFooterView *footerView=[DKRefreshFooterView footerViewWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];
    footerView.autoLoading=YES;
    self.tableView.refreshFooterView=footerView;
<br>效果图<br>
![image](https://github.com/dushukai111/publicResources/blob/master/DKRefresh_images/load_auto.gif)<br>

#### 无更多数据
    footerView.status=DKRefreshFooterStatusNoMoreData;
    或者
    self.tableView.refreshFooterView.status=DKRefreshFooterStatusNoMoreData;
#### 结束加载
    [self.tableView endFooterRefreshing];
#### 无更多数据状态转换为准备加载状态
    self.tableView.refreshFooterView.status=DKRefreshFooterStatusNormal;
