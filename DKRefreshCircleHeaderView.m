//
//  DKCircleRefreshHeaderView.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/5.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "DKRefreshCircleHeaderView.h"
extern const CGFloat DKHeaderHeight;
@interface DKCircleView:UIView
@property (nonatomic,assign) CGFloat percent;
@end
@interface DKRefreshCircleHeaderView()
@property (nonatomic,strong) DKCircleView *circleView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *lastRefreshTimeLabel;
@property (nonatomic,strong,readwrite) NSDate *lastRefreshTime;
@end

@implementation DKRefreshCircleHeaderView
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
        
        self.circleView=[[DKCircleView alloc] init];
        [contentView addSubview:self.circleView];
        self.circleView.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
        
        self.statusLabel=[[UILabel alloc] init];
        self.statusLabel.font=[UIFont systemFontOfSize:14.0];
        self.statusLabel.text=DKRefreshHeaderNormalStatusText;
        [contentView addSubview:self.statusLabel];
        self.statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        self.lastRefreshTimeLabel=[[UILabel alloc] init];
        self.lastRefreshTimeLabel.textColor=self.lastTimeTextColor?self.lastTimeTextColor:[UIColor blackColor];
        self.lastRefreshTimeLabel.font=[UIFont systemFontOfSize:14.0];
        self.lastRefreshTimeLabel.hidden=YES;
        [contentView addSubview:self.lastRefreshTimeLabel];
        self.lastRefreshTimeLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.statusLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:2]];
        
    }
    return self;
}
- (void)setLastRefreshTimeHidden:(BOOL)lastRefreshTimeHidden{
    [super setLastRefreshTimeHidden:lastRefreshTimeHidden];
    [self hideOrShowLastRefreshTimeLabel];
    
}
- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if (self.status!=DKRefreshHeaderViewStatusRefreshing) {
        CGFloat percent=contentOffset.y/DKHeaderHeight;
        CGFloat circlePercent;
        if (percent>0) {
            circlePercent=0;
        }else if (percent>-1&&percent<0){
            circlePercent=-percent;
        }else{
            circlePercent=1;
        }
        self.circleView.percent=circlePercent;
    }
    
}
- (void)setStatus:(DKRefreshHeaderViewStatus)status{
    [super setStatus:status];
    if (self.status==DKRefreshHeaderViewStatusWait) {
        [self dealWithTimeLabel];
        self.statusLabel.text=self.normalStatusText?self.normalStatusText:DKRefreshHeaderNormalStatusText;
        [self.circleView.layer removeAllAnimations];
        self.circleView.percent=0;
        
    }else if (self.status==DKRefreshHeaderViewStatusPrepareRefresh){
        self.statusLabel.text=self.prepareRefreshStatusText?self.prepareRefreshStatusText:DKRefreshHeaderPrepareRefreshStatusText;
        
    }else if (self.status==DKRefreshHeaderViewStatusRefreshing){
        self.lastRefreshTime=[NSDate date];
        self.statusLabel.text=self.refreshingStatusText?self.refreshingStatusText:DKRefreshHeaderRefreshingStatusText;
        self.circleView.percent=0.8;
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration=0.6;
        animation.repeatCount=HUGE_VALF;
        animation.fromValue=[NSNumber numberWithFloat:0];
        animation.toValue=[NSNumber numberWithFloat:M_PI*2];
        [self.circleView.layer addAnimation:animation forKey:nil];
    }
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
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-2]];
                if (statusTextWidth<timeTextWidth) {
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
                }else{
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.lastRefreshTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.statusLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                    [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
                }
                
            }else{
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
                [self.statusLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
            }
            
        }
    }
    
    
}
- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor=circleColor;
    CAShapeLayer *shapeLayer=(CAShapeLayer*)self.circleView.layer;
    shapeLayer.strokeColor=circleColor.CGColor;
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

@implementation DKCircleView

+ (Class)layerClass{
    return [CAShapeLayer class];
}
- (instancetype)init{
    self=[super init];
    if (self) {
        UIBezierPath *path=[UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        CAShapeLayer *shapeLayer=(CAShapeLayer*)self.layer;
        shapeLayer.lineWidth=2.0;
        shapeLayer.strokeColor=[UIColor redColor].CGColor;
        shapeLayer.lineCap=kCALineCapRound;
        shapeLayer.path=path.CGPath;
        shapeLayer.strokeEnd=0.0;
        shapeLayer.fillColor=[UIColor whiteColor].CGColor;
    }
    return self;
}
- (void)setPercent:(CGFloat)percent{
    _percent=percent;
    CAShapeLayer *shapeLayer=(CAShapeLayer*)self.layer;
    shapeLayer.strokeEnd=percent;
}
@end
