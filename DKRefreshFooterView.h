//
//  DKRefreshFooterView.h
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DKRefreshFooterNormalStatusText @"上拉加载.."
#define DKRefreshFooterPrepareStatusText @"释放开始加载.."
#define DKRefreshFooterLoadingStatusText @"正在加载.."
#define DKRefreshFooterNoMoreDataStatusText @"无更多数据"
typedef NS_ENUM(NSInteger,DKRefreshFooterStatus){
    DKRefreshFooterStatusNormal,
    DKRefreshFooterStatusPrepareLoad,
    DKRefreshFooterStatusLoading,
    DKRefreshFooterStatusNoMoreData
};
@interface DKRefreshFooterView : UIView
@property (nonatomic,assign) DKRefreshFooterStatus status;
@property (nonatomic,copy) NSString *normalStatusText;
@property (nonatomic,copy) NSString *prepareStatusText;
@property (nonatomic,copy) NSString *loadingStatusText;
@property (nonatomic,copy) NSString *noMoreDataStatusText;
@property (nonatomic,strong) UIColor *statusTextColor;
@property (nonatomic,strong) UIColor *noMoreDataTextColor;
@property (nonatomic,assign) BOOL autoLoading;

+ (instancetype)footerViewWithBlock:(void(^)())block;
- (instancetype)initWithBlock:(void (^)())block;
- (void)executeBlock;
@end
