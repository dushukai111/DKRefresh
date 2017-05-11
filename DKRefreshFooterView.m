//
//  DKRefreshFooterView.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "DKRefreshFooterView.h"
@interface DKRefreshFooterView()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIActivityIndicatorView *aiView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *noMoreDataLabel;
@end
@implementation DKRefreshFooterView{
    void (^refreshBlock)();
}

+ (instancetype)footerViewWithBlock:(void (^)())block{
    return [[self alloc] initWithBlock:block];
}
- (instancetype)initWithBlock:(void (^)())block{
    self=[super init];
    if (self) {
        refreshBlock=block;
        _status=DKRefreshFooterStatusNormal;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *contentView=[[UIView alloc] init];
        [self addSubview:contentView];
        contentView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        
        NSString *imagePath=[[[NSBundle mainBundle] pathForResource:@"DKRefresh" ofType:@"bundle"] stringByAppendingPathComponent:@"arrow"];
        UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
        CGSize imageSize=CGSizeMake(15, 20);
        if (image) {
            imageSize=image.size;
        }
        self.imgView=[[UIImageView alloc] init];
        self.imgView.image=image;
        self.imgView.transform=CGAffineTransformMakeRotation(M_PI);
        [contentView addSubview:self.imgView];
        self.imgView.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:imageSize.height/imageSize.width*15]];
        
        self.aiView=[[UIActivityIndicatorView alloc] init];
        self.aiView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        self.aiView.hidden=YES;
        [contentView addSubview:self.aiView];
        self.aiView.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.aiView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.aiView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        self.statusLabel=[[UILabel alloc] init];
        self.statusLabel.font=[UIFont systemFontOfSize:14.0];
        self.statusLabel.text=DKRefreshFooterNormalStatusText;
        [contentView addSubview:self.statusLabel];
        self.statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        self.noMoreDataLabel=[[UILabel alloc] init];
        self.noMoreDataLabel.font=[UIFont systemFontOfSize:14.0];
        self.noMoreDataLabel.text=DKRefreshFooterNoMoreDataStatusText;
        self.noMoreDataLabel.hidden=YES;
        [self addSubview:self.noMoreDataLabel];
        self.noMoreDataLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMoreDataLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noMoreDataLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
    }
    return self;
}
- (void)setStatus:(DKRefreshFooterStatus)status{
    _status=status;
    if (status==DKRefreshFooterStatusNormal) {
        [self.aiView stopAnimating];
        self.noMoreDataLabel.hidden=YES;
        self.statusLabel.hidden=NO;
        self.statusLabel.text=self.normalStatusText?self.normalStatusText:DKRefreshFooterNormalStatusText;
        self.imgView.hidden=NO;
        self.aiView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.imgView.transform=CGAffineTransformMakeRotation(M_PI);
        }];
        if (self.superview) {
            UIScrollView *scrollview=(UIScrollView*)self.superview;
            scrollview.contentInset=UIEdgeInsetsMake(scrollview.contentInset.top, 0, 0, 0);
        }
        
    }else if (status==DKRefreshFooterStatusPrepareLoad) {
        self.statusLabel.text=self.prepareStatusText?self.prepareStatusText:DKRefreshFooterPrepareStatusText;
        [UIView animateWithDuration:0.3 animations:^{
            self.imgView.transform=CGAffineTransformMakeRotation(0);
        }];
    }else if (status==DKRefreshFooterStatusLoading) {
        self.statusLabel.text=self.loadingStatusText?self.loadingStatusText:DKRefreshFooterLoadingStatusText;
        self.noMoreDataLabel.hidden=YES;
        self.imgView.hidden=YES;
        self.aiView.hidden=NO;
        [self.aiView startAnimating];
    }else if (status==DKRefreshFooterStatusNoMoreData) {
        self.statusLabel.text=self.noMoreDataStatusText?self.noMoreDataStatusText:DKRefreshFooterNoMoreDataStatusText;
        self.noMoreDataLabel.hidden=NO;
        self.aiView.hidden=YES;
        [self.aiView stopAnimating];
        self.statusLabel.hidden=YES;
        self.imgView.hidden=YES;
        if (self.superview) {
            extern CGFloat DKFooterHeight;
            UIScrollView *scrollview=(UIScrollView*)self.superview;
            scrollview.contentInset=UIEdgeInsetsMake(scrollview.contentInset.top, 0, DKFooterHeight, 0);
        }
    }
}
- (void)setNormalStatusText:(NSString *)normalStatusText{
    _normalStatusText=normalStatusText;
    if (self.status==DKRefreshFooterStatusNormal) {
        self.statusLabel.text=normalStatusText;
    }
}
- (void)setPrepareStatusText:(NSString *)prepareStatusText{
    _prepareStatusText=prepareStatusText;
    if (self.status==DKRefreshFooterStatusPrepareLoad) {
        self.statusLabel.text=prepareStatusText;
    }
}
- (void)setLoadingStatusText:(NSString *)loadingStatusText{
    _loadingStatusText=loadingStatusText;
    if (self.status==DKRefreshFooterStatusLoading) {
        self.statusLabel.text=loadingStatusText;
    }
}
- (void)setNoMoreDataStatusText:(NSString *)noMoreDataStatusText{
    _noMoreDataStatusText=noMoreDataStatusText;
    if (self.status==DKRefreshFooterStatusNoMoreData) {
        self.statusLabel.text=noMoreDataStatusText;
    }
}
- (void)setStatusTextColor:(UIColor *)statusTextColor{
    _statusTextColor=statusTextColor;
    self.statusLabel.textColor=statusTextColor;
}
- (void)setNoMoreDataTextColor:(UIColor *)noMoreDataTextColor{
    _noMoreDataTextColor=noMoreDataTextColor;
    self.noMoreDataLabel.textColor=noMoreDataTextColor;
}
- (void)executeBlock{
    refreshBlock();
}
@end
