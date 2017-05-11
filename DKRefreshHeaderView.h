//
//  DKRefreshHeaderView.h
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DKRefreshHeaderNormalStatusText @"下拉刷新.."
#define DKRefreshHeaderPrepareRefreshStatusText @"释放刷新.."
#define DKRefreshHeaderRefreshingStatusText @"正在刷新.."
typedef NS_ENUM(NSInteger,DKRefreshHeaderViewStatus) {
    DKRefreshHeaderViewStatusWait,
    DKRefreshHeaderViewStatusRefreshing,
    DKRefreshHeaderViewStatusPrepareRefresh
};
@interface DKRefreshHeaderView : UIView{
    void(^_refreshBlock)();
}
@property (nonatomic,assign) DKRefreshHeaderViewStatus status;
@property (nonatomic,assign) CGPoint contentOffset;
@property (nonatomic,strong) NSString *normalStatusText;
@property (nonatomic,strong) NSString *prepareRefreshStatusText;
@property (nonatomic,strong) NSString *refreshingStatusText;
@property (nonatomic,strong) UIColor *statusTextColor;
@property (nonatomic,strong) UIColor *lastTimeTextColor;
@property (nonatomic,assign) BOOL lastRefreshTimeHidden;
@property (nonatomic,strong,readonly) NSDate *lastRefreshTime;
+ (instancetype)refreshHeaderWithBlock:(void(^)())refreshBlock;
- (instancetype)initWithBlock:(void (^)())refreshBlock;
- (void)executeBlock;
@end
