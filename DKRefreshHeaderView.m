//
//  DKRefreshHeaderView.m
//  DKRefreshTest
//
//  Created by kaige on 2017/5/4.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "DKRefreshHeaderView.h"

@implementation DKRefreshHeaderView

+ (instancetype)refreshHeaderWithBlock:(void (^)())refreshBlock{
    return [[self alloc] initWithBlock:refreshBlock];
}
- (instancetype)initWithBlock:(void (^)())refreshBlock{
    self=[super init];
    if (self) {
        _refreshBlock=refreshBlock;
    }
    return self;
}
- (void)executeBlock{
    _refreshBlock();
}
@end
