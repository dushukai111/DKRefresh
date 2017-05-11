//
//  UIScrollView+DKRefresh.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "UIScrollView+DKRefresh.h"
#import <objc/runtime.h>
const CGFloat DKHeaderHeight=50.0;
const CGFloat DKFooterHeight=50.0;
const static char headerKey;
const static char footerKey;
@implementation UIScrollView (DKRefresh)
+ (void)load{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContentOffset:)), class_getInstanceMethod(self, @selector(dk_setContentOffset:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContentSize:)), class_getInstanceMethod(self, @selector(dk_setContentSize:)));
}
- (void)dk_setContentOffset:(CGPoint)contentOffset{
    [self dk_setContentOffset:contentOffset];
    
    [self dealWithContentOffset];
    [self.refreshHeaderView setContentOffset:contentOffset];
}
- (void)dk_setContentSize:(CGSize)size{
    [self dk_setContentSize:size];
    [self dealWithFooterView];
}
- (void)dealWithContentOffset{
    //处理headerView
    if (self.refreshHeaderView) {
        if(self.refreshHeaderView.status==DKRefreshHeaderViewStatusPrepareRefresh&&!self.dragging){
            self.refreshHeaderView.status=DKRefreshHeaderViewStatusRefreshing;
            self.contentInset=UIEdgeInsetsMake(DKHeaderHeight, 0, self.contentInset.bottom, 0);
            if (self.contentOffset.y>-DKHeaderHeight) {
                [self dk_setContentOffset:CGPointMake(0, -DKHeaderHeight)];
            }
            [self.refreshHeaderView executeBlock];
        }
        if (self.contentOffset.y<-DKHeaderHeight&&self.refreshHeaderView.status==DKRefreshHeaderViewStatusWait) {
            self.refreshHeaderView.status=DKRefreshHeaderViewStatusPrepareRefresh;
        }else if (self.contentOffset.y>=-DKHeaderHeight&&self.refreshHeaderView.status==DKRefreshHeaderViewStatusPrepareRefresh){
            self.refreshHeaderView.status=DKRefreshHeaderViewStatusWait;
        }
    }
    //处理footerView
    if (self.refreshFooterView) {
        if (self.refreshFooterView.autoLoading) {//自动刷新
            if (self.contentSize.height>=self.bounds.size.height){
                if (self.refreshFooterView.status==DKRefreshFooterStatusNormal&&self.contentOffset.y>=self.contentSize.height-self.bounds.size.height) {
                    self.refreshFooterView.status=DKRefreshFooterStatusLoading;
                    [self.refreshFooterView executeBlock];
                }
            }else{
                if(self.refreshFooterView.status==DKRefreshFooterStatusPrepareLoad&&!self.dragging){
                    self.refreshFooterView.status=DKRefreshFooterStatusLoading;
                    self.contentInset=UIEdgeInsetsMake(self.contentInset.top, 0, DKFooterHeight, 0);
                    if (self.contentOffset.y<self.contentSize.height-self.bounds.size.height+DKFooterHeight) {
                        [self dk_setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height+DKFooterHeight)];
                    }
                    
                    [self.refreshFooterView executeBlock];
                }
                if (self.contentOffset.y>DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusNormal) {
                    self.refreshFooterView.status=DKRefreshFooterStatusPrepareLoad;
                }else if(self.contentOffset.y<DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusPrepareLoad){
                    self.refreshFooterView.status=DKRefreshFooterStatusNormal;
                }
            }
        }else{
            if(self.refreshFooterView.status==DKRefreshFooterStatusPrepareLoad&&!self.dragging){
                self.refreshFooterView.status=DKRefreshFooterStatusLoading;
                self.contentInset=UIEdgeInsetsMake(self.contentInset.top, 0, DKFooterHeight, 0);
                if (self.contentOffset.y<self.contentSize.height-self.bounds.size.height+DKFooterHeight) {
                    [self dk_setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height+DKFooterHeight)];
                }
                
                [self.refreshFooterView executeBlock];
            }
            if (self.contentSize.height>self.bounds.size.height) {
                if (self.contentOffset.y>self.contentSize.height-self.bounds.size.height+DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusNormal) {
                    self.refreshFooterView.status=DKRefreshFooterStatusPrepareLoad;
                }else if(self.contentOffset.y<=self.contentSize.height-self.bounds.size.height+DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusPrepareLoad){
                    self.refreshFooterView.status=DKRefreshFooterStatusNormal;
                }
            }else{
                if (self.contentOffset.y>DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusNormal) {
                    self.refreshFooterView.status=DKRefreshFooterStatusPrepareLoad;
                }else if(self.contentOffset.y<DKFooterHeight&&self.refreshFooterView.status==DKRefreshFooterStatusPrepareLoad){
                    self.refreshFooterView.status=DKRefreshFooterStatusNormal;
                }
            }
        }
        
        
    }
    
}
- (void)dealWithFooterView{
    if (self.refreshFooterView) {
        if (self.refreshFooterView.autoLoading) {
            self.contentInset=UIEdgeInsetsMake(self.contentInset.top, 0, DKFooterHeight, 0);
        }
        
        for (NSLayoutConstraint *con in self.constraints) {
            if (con.firstItem==self.refreshFooterView&&con.firstAttribute==NSLayoutAttributeTop) {
                con.constant=self.contentSize.height;
                break;
            }
        }
    }
}
- (void)setRefreshHeaderView:(DKRefreshHeaderView *)refreshHeaderView{
    [self.refreshHeaderView removeFromSuperview];
    objc_setAssociatedObject(self, &headerKey, refreshHeaderView, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:refreshHeaderView];
    refreshHeaderView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshHeaderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshHeaderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshHeaderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshHeaderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DKHeaderHeight]];
}
- (DKRefreshHeaderView *)refreshHeaderView{
    DKRefreshHeaderView *headerView=objc_getAssociatedObject(self, &headerKey);
    return headerView;
}
- (void)setRefreshFooterView:(DKRefreshFooterView *)refreshFooterView{
    NSLog(@"%@",[NSValue valueWithCGSize:self.contentSize]);
    if (self.refreshFooterView!=refreshFooterView) {
        [self.refreshFooterView removeFromSuperview];
        objc_setAssociatedObject(self, &footerKey, refreshFooterView, OBJC_ASSOCIATION_RETAIN);
//        if (self.contentSize.height>self.bounds.size.height) {
//            
//        }
        [self addSubview:refreshFooterView];
        refreshFooterView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshFooterView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshFooterView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshFooterView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.contentSize.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:refreshFooterView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DKFooterHeight]];
    }
}
- (DKRefreshFooterView *)refreshFooterView{
    DKRefreshFooterView *footerView=objc_getAssociatedObject(self, &footerKey);
    return footerView;
}
- (void)endHeaderRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset=UIEdgeInsetsMake(0, 0, self.contentInset.bottom, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                    self.refreshHeaderView.status=DKRefreshHeaderViewStatusWait;
                });
                
            }
            
        }];
    });
    
}
- (void)endFooterRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshFooterView.status==DKRefreshFooterStatusLoading) {
            self.refreshFooterView.status=DKRefreshFooterStatusNormal;
            self.contentInset=UIEdgeInsetsMake(self.contentInset.top, 0, 0, 0);
        }
        
    });
    
}

@end
