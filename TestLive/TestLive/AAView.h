//
//  AAView.h
//  TestLive
//
//  Created by pk on 2018/4/11.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "BaseView.h"

@protocol AAViewDelegate<BaseViewDelegate>

- (void)testAAViewDelegate;

@end


@interface AAView : BaseView

@end
