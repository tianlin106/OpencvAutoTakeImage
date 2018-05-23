//
//  BaseView.h
//  TestLive
//
//  Created by pk on 2018/4/11.
//  Copyright © 2018年 pk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseViewDelegate<NSObject>

- (void)testProtocol;

@end

@interface BaseView : UIView

@property (nonatomic,assign)id<BaseViewDelegate>testDelegate;

@property (nonatomic,strong)UIButton * button;

- (void)clickTestBtn;

@end
