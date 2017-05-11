//
//  UIScrollView+DKRefresh.h
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKRefreshHeaderView.h"
#import "DKRefreshFooterView.h"

@interface UIScrollView (DKRefresh)
@property (nonatomic,strong) DKRefreshHeaderView *refreshHeaderView;
@property (nonatomic,strong) DKRefreshFooterView *refreshFooterView;
- (void)endHeaderRefreshing;
- (void)endFooterRefreshing;
@end
