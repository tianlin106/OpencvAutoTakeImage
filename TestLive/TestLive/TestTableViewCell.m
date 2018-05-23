//
//  TestTableViewCell.m
//  TestLive
//
//  Created by pk on 2018/4/16.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.contentView.backgroundColor = [UIColor redColor];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
