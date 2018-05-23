//
//  TakeCameraViewController.m
//  TestLive
//
//  Created by pk on 2018/3/8.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "TakeCameraViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import "TTImageBlurryEvaluation.hpp"

@interface TakeCameraViewController ()<CvPhotoCameraDelegate>

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)CvPhotoCamera *photoCamera;

@property (nonatomic,strong)UIImageView *resultImageView;

@end

@implementation TakeCameraViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    self.photoCamera = [[CvPhotoCamera alloc] initWithParentView:self.imageView];
    
    self.photoCamera.delegate = self;
    
    self.photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    
    //    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
//    self.photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    
    //    self.videoCamera.defaultFPS = 100;
    
    [self.view addSubview:self.imageView];
    
    //设置摄像头的方向
    self.photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    CGFloat mw = mainSize.width;
    CGFloat mh = mainSize.height;
    UIButton * btn= [[UIButton alloc] initWithFrame:CGRectMake((mw - 60)/2, mh - 50, 60, 38)];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(takeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.resultImageView];
}

- (UIImageView *)resultImageView{
    if (_resultImageView == nil) {
        _resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
        _resultImageView.backgroundColor = [UIColor redColor];
        _resultImageView.layer.borderColor = [UIColor yellowColor].CGColor;
        _resultImageView.layer.borderWidth = 5.0;
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _resultImageView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.photoCamera start];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.photoCamera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)start{
    [self.photoCamera start];
}

- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image{
    NSLog(@"image = %@",image);
//    self.resultImageView.image = image;
    cv::Mat cvImage = [self cvMatFromUIIMage:image];
    [self qingxidujisuan:cvImage];
}

- (void)photoCameraCancel:(CvPhotoCamera*)photoCamera{
    NSLog(@"photoCameraCancelphotoCameraCancel");
}

- (void)takeBtnClick:(id)sender{
    [self.photoCamera takePicture];
}

- (void)qingxidujisuan:(cv::Mat)image{
    cv::Mat imageSobel;
    
    Laplacian(image, imageSobel, CV_16U);
    //Sobel(imageGrey, imageSobel, CV_16U, 1, 1);
    
    //图像的平均灰度
    double meanValue = 0.0;
    meanValue = mean(imageSobel)[0];
    
    //double to string
    std::stringstream meanValueStream;
    std::string meanValueString;
    meanValueStream << meanValue;
    meanValueStream >> meanValueString;
    meanValueString = "Articulation(Laplacian Method): " + meanValueString;
    putText(image, meanValueString, cv::Point(20, 50), CV_FONT_HERSHEY_COMPLEX, 0.8, cvScalar(255, 255, 25), 2);
//    imshow("Articulation", imageSobel);
//    cv::waitKey(0);
    
    self.resultImageView.image = [OpenCVExtension UIImageFromCVMat:image];
    return;
}

- (cv::Mat)cvMatFromUIIMage:(UIImage *)image
{
    @synchronized (image) {
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
        CGFloat cols = image.size.width;
        CGFloat rows = image.size.height;
        
        cv::Mat cvMat(rows, cols, CV_8UC4);
         CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,
                                                        cols,
                                                        rows,
                                                        8,
                                                        cvMat.step[0],
                                                        colorSpace,
                                                        kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
        CGContextRelease(contextRef);
        return cvMat;
    }
}

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
