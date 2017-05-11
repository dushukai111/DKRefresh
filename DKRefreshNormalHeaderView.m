//
//  DKRefreshNormalHeaderView.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "DKRefreshNormalHeaderView.h"
@interface DKRefreshNormalHeaderView()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIActivityIndicatorView *aiView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *lastRefreshTimeLabel;
@property (nonatomic,strong,readwrite) NSDate *lastRefreshTime;
@end
@implementation DKRefreshNormalHeaderView
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
        NSString *imagePath=[[[NSBundle mainBundle] pathForResource:@"DKRefresh" ofType:@"bundle"] stringByAppendingPathComponent:@"arrow"];
        UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
        CGSize imageSize=CGSizeMake(15, 20);
        if (image) {
            imageSize=image.size;
        }
        self.imgView=[[UIImageView alloc] init];
        self.imgView.image=image;
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
- (void)setNormalStatusText:(NSString *)normalStatusText{
    [super setNormalStatusText:normalStatusText];
    if (self.status==DKRefreshHeaderViewStatusWait) {
        self.statusLabel.text=normalStatusText;
    }
}
- (void)setPrepareRefreshStatusText:(NSString *)prepareRefreshStatusText{
    [super setPrepareRefreshStatusText:prepareRefreshStatusText];
    if (self.status==DKRefreshHeaderViewStatusPrepareRefresh) {
        self.statusLabel.text=prepareRefreshStatusText;
    }
}
- (void)setRefreshingStatusText:(NSString *)refreshingStatusText{
    [super setRefreshingStatusText:refreshingStatusText];
    if (self.status==DKRefreshHeaderViewStatusRefreshing) {
        self.statusLabel.text=refreshingStatusText;
    }
}
- (void)setStatus:(DKRefreshHeaderViewStatus)status{
    [super setStatus:status];
    if (self.status==DKRefreshHeaderViewStatusWait) {
        [self dealWithTimeLabel];
        self.imgView.hidden=NO;
        self.aiView.hidden=YES;
        [self.aiView stopAnimating];
        self.statusLabel.text=self.normalStatusText?self.normalStatusText:DKRefreshHeaderNormalStatusText;
        [UIView animateWithDuration:0.3 animations:^{
            self.imgView.transform=CGAffineTransformMakeRotation(0);
        }];
    }else if (self.status==DKRefreshHeaderViewStatusPrepareRefresh){
        self.imgView.hidden=NO;
        self.aiView.hidden=YES;
        [self.aiView stopAnimating];
        self.statusLabel.text=self.prepareRefreshStatusText?self.prepareRefreshStatusText:DKRefreshHeaderPrepareRefreshStatusText;
        [UIView animateWithDuration:0.3 animations:^{
            self.imgView.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }else if (self.status==DKRefreshHeaderViewStatusRefreshing){
        self.lastRefreshTime=[NSDate date];
        self.imgView.hidden=YES;
        self.aiView.hidden=NO;
        [self.aiView startAnimating];
        self.statusLabel.text=self.refreshingStatusText?self.refreshingStatusText:DKRefreshHeaderRefreshingStatusText;
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
