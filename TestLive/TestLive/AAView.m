//
//  AAView.m
//  TestLive
//
//  Created by pk on 2018/4/11.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "AAView.h"

@interface AAView(){
    
}

@end

@implementation AAView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickTestBtn{
    if (self.testDelegate && [self.testDelegate respondsToSelector:@selector(testAAViewDelegate)]) {
//        [self.testDelegate testAAViewDelegate];
    }
    
}

@end
