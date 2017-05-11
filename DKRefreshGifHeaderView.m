//
//  DKRefreshGifHeaderView.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/9.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "DKRefreshGifHeaderView.h"
@interface DKRefreshGifHeaderView()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *lastRefreshTimeLabel;
@property (nonatomic,strong,readwrite) NSDate *lastRefreshTime;
@end
@implementation DKRefreshGifHeaderView
@synthesize lastRefreshTime=_lastRefreshTime;
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *contentView=[[UIView alloc] init];
        [self addSubview:contentView];
        contentView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        
        self.imgView=[[UIImageView alloc] init];
        [contentView addSubview:self.imgView];
        self.imgView.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
        
        
        self.statusLabel=[[UILabel alloc] init];
        self.statusLabel.font=[UIFont systemFontOfSize:15.0];
        self.statusLabel.text=DKRefreshHeaderNormalStatusText;
        [contentView addSubview:self.statusLabel];
        self.statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        self.lastRefreshTimeLabel=[[UILabel alloc] init];
        self.lastRefreshTimeLabel.font=[UIFont systemFontOfSize:14.0];
        self.lastRefreshTimeLabel.hidden=YES;
        [contentView addSubview:self.lastRefreshTimeLabel];
        self.lastRefreshTimeLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.statusLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:2]];
    }
    return self;
}
- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if (self.status!=DKRefreshHeaderViewStatusRefreshing) {
        extern const CGFloat DKHeaderHeight;
        if (self.images&&self.images.count>0&&contentOffset.y<0) {
            NSInteger switchUnit=DKHeaderHeight/self.images.count;//图片切换单位，下拉过程中不断变换图片
            NSInteger imageIndex=labs((NSInteger)contentOffset.y/switchUnit)%self.images.count;
            self.imgView.image=[self.images objectAtIndex:imageIndex];
        }
    }
    
}
- (void)setStatus:(DKRefreshHeaderViewStatus)status{
    [super setStatus:status];
    if (status==DKRefreshHeaderViewStatusWait) {
        [self dealWithTimeLabel];
        [self.imgView stopAnimating];
        self.statusLabel.text=DKRefreshHeaderNormalStatusText;;
    }else if(status==DKRefreshHeaderViewStatusRefreshing){
        self.lastRefreshTime=[NSDate date];
        [self.imgView startAnimating];
        self.statusLabel.text=DKRefreshHeaderRefreshingStatusText;
    }else if (status==DKRefreshHeaderViewStatusPrepareRefresh){
        [self.imgView stopAnimating];
        self.statusLabel.text=DKRefreshHeaderPrepareRefreshStatusText;
    }
}
- (void)setImages:(NSArray<UIImage *> *)images{
    _images=images;
    self.imgView.animationImages=images;
    if (images.count>0&&[images[0] isKindOfClass:[UIImage class]]) {
        self.imgView.image=images[0];
    }
    
}
- (void)setLastRefreshTimeHidden:(BOOL)lastRefreshTimeHidden{
    [super setLastRefreshTimeHidden:lastRefreshTimeHidden];
    [self hideOrShowLastRefreshTimeLabel];
    
}
- (void)dealWithTimeLabel{
    if (self.lastRefreshTime) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        
        NSInteger day1=[self.lastRefreshTime timeIntervalSince1970]/1000/3600/24;
        NSInteger day2=[[NSDate date] timeIntervalSince1970]/1000/3600/24;
        if (day2==day1) {
            [format setDateFormat:@"今天 HH:mm"];
        }else if(day2-day1==1){
            [format setDateFormat:@"昨天 HH:mm"];
        }else if(day2-day1==2){
            [format setDateFormat:@"前天 HH:mm"];
        }else{
            [format setDateFormat:@"MM月dd日 HH:mm"];
        }
        self.lastRefreshTimeLabel.text=[NSString stringWithFormat:@"上次更新:%@",[format stringFromDate:self.lastRefreshTime]];
        [self hideOrShowLastRefreshTimeLabel];
    }
}
- (void)hideOrShowLastRefreshTimeLabel{
    self.lastRefreshTimeLabel.hidden=self.lastRefreshTimeHidden;
    if (self.lastRefreshTime) {
        NSDictionary *attr=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat statusTextWidth=[self.statusLabel.text boundingRectWithSize:CGSizeMake(1000, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        CGFloat timeTextWidth=[self.lastRefreshTimeLabel.text boundingRectWithSize:CGSizeMake(1000, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        NSMutableArray *willRemovedConstraints=[NSMutableArray array];
        for(NSLayoutConstraint *con in self.statusLabel.superview.constraints){
            if (con.firstItem==self.statusLabel&&con.firstAttribute==NSLayoutAttributeCenterY) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.statusLabel&&con.firstAttribute==NSLayoutAttributeTrailing) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.lastRefreshTimeLabel&&con.firstAttribute==NSLayoutAttributeTrailing) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.statusLabel&&con.firstAttribute==NSLayoutAttributeBottom){
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.statusLabel&&con.firstAttribute==NSLayoutAttributeLeading) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.lastRefreshTimeLabel&&con.firstAttribute==NSLayoutAttributeLeading) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.statusLabel&&con.firstAttribute==NSLayoutAttributeCenterX) {
                [willRemovedConstraints addObject:con];
            }
            if (con.firstItem==self.lastRefreshTimeLabel&&con.firstAttribute==NSLayoutAttributeCenterX) {
                [willRemovedConstraints addObject:con];
            }
        }
        if (willRemovedConstraints.count>0) {
            for (NSLayoutConstraint *con in willRemovedConstraints) {
                [self.statusLabel.superview removeConstraint:con];
            }
            if (!self.lastRefreshTimeHidden) {
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-2]];
                if (statusTextWidth<timeTextWidth) {
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
                }else{
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.statusLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
                }
                
            }else{
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
            }
            
        }
    }
    
    
}
- (void)setStatusTextColor:(UIColor *)statusTextColor{
    [super setStatusTextColor:statusTextColor];
    self.statusLabel.textColor=statusTextColor;
}
- (void)setLastTimeTextColor:(UIColor *)lastTimeTextColor{
    [super setLastTimeTextColor:lastTimeTextColor];
    self.lastRefreshTimeLabel.textColor=lastTimeTextColor;
}
@end
