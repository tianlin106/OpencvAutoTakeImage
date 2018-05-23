//
//  BaseView.m
//  TestLive
//
//  Created by pk on 2018/4/11.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        [self.button setTitle:@"测试代理响应" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(clickTestBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    }
    return self;
}

- (void)clickTestBtn{
    if (self.testDelegate && [self.testDelegate respondsToSelector:@selector(testProtocol)]) {
        [self.testDelegate testProtocol];
    }
}


@end
