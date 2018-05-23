//
//  SecondViewController.h
//  TestLive
//
//  Created by pk on 2018/2/9.
//  Copyright © 2018年 pk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetClearImage)(UIImage * image);

typedef NS_OPTIONS(NSUInteger, CameraGetPictureType) {
    CameraGetPictureType_Licence = 1 << 0,
    CameraGetPictureType_IDCard = 1 << 1
};

@interface SecondViewController : UIViewController

@property(nonatomic,copy) GetClearImage getImageCallBack;

- (instancetype)initWithType:(CameraGetPictureType)getPictureType;

@end
