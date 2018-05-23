//
//  SecondViewController.m
//  TestLive
//
//  Created by pk on 2018/2/9.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "SecondViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <opencv2/imgproc/imgproc_c.h>
#import "TTImageBlurryEvaluation.hpp"
#import <opencv2/imgcodecs/ios.h>
#import "UIImage+Rotate.h"

@interface SecondViewController ()<CvVideoCameraDelegate>{
    
    cv::Mat keepMatImg;
    UITextField * TF;
    BOOL isNeedToCut;
    float IdeltaCount;
}

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)CvVideoCamera *videoCamera;

@property (nonatomic,strong)UIImageView *resultImageView;

@property (nonatomic,strong)UILabel * fuzzyText;
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;
@property (nonatomic,strong) UIImage * keepImageAlive;

@end

@implementation SecondViewController

- (instancetype)initWithType:(CameraGetPictureType)getPictureType{
    self = [super init];
    if (self) {
        switch (getPictureType) {
            case CameraGetPictureType_Licence:
            {
                isNeedToCut = NO;
                IdeltaCount = 150.0;
            }
                break;
            case CameraGetPictureType_IDCard:
            {
                isNeedToCut = YES;
                IdeltaCount = 70;
            }
                break;
                
            default:{
                isNeedToCut = NO;
                IdeltaCount = 150.0;
            }
                break;
        }
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)createVideo {
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    
    self.videoCamera.delegate = self;
    
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    
//        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    //设置摄像头的方向
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    
//    self.videoCamera.imageWidth = (int)self.imageView.bounds.size.width;
//    self.videoCamera.imageHeight = (int)self.imageView.bounds.size.height;

//    [self.videoCamera adjustLayoutToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    [self createVideo];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    
    
    
//    self.videoCamera.defaultFPS = 100;
    
   
    
    CGFloat wth = [[UIScreen mainScreen] bounds].size.width;
    self.fuzzyText = [[UILabel alloc] initWithFrame:CGRectMake(0, 100,wth , 30)];
    self.fuzzyText.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:self.fuzzyText];
    [self.view bringSubviewToFront:self.repeatBtn];
    
    CGFloat mianW = UIScreen.mainScreen.bounds.size.width;
    CGFloat w = mianW ,h = mianW/130*82;
    TF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    TF.layer.borderColor = [UIColor whiteColor].CGColor;
    TF.layer.borderWidth = 1.0;
    TF.enabled = NO;
    [self.view addSubview:TF];
    TF.center = self.view.center;
    
    [self.view addSubview:self.resultImageView];
    self.resultImageView.center = TF.center;
    self.resultImageView.hidden = YES;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        
//        CGFloat w = 82*3.5,h = 130*3.5;
        CGFloat mianW = UIScreen.mainScreen.bounds.size.width;
        CGFloat w = mianW ,h = mianW/130*82;
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
       
    }
    return _imageView;
}

- (UIImageView *)resultImageView{
    if (_resultImageView == nil) {
        _resultImageView = [[UIImageView alloc] initWithFrame:TF.frame];
//        _resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 200, 200)];
        _resultImageView.backgroundColor = [UIColor clearColor];
        _resultImageView.layer.borderColor = [UIColor yellowColor].CGColor;
        _resultImageView.layer.borderWidth = 5.0;
    }
    return _resultImageView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.videoCamera start];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoCamera stop];
    if (self.getImageCallBack) {

//        NSLog(@"图片的实际角度 = %d",self.keepImageAlive.imageOrientation);
//        UIImage * image = [self.keepImageAlive rotate:UIImageOrientationLeft];
//        self.getImageCallBack(image);
        self.getImageCallBack(self.keepImageAlive);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerAction:(id)sender {
    
    [self createVideo];
    [self.videoCamera start];
    self.resultImageView.image = nil;
    self.resultImageView.hidden = YES;
}

- (void)processImage:(cv::Mat &)image
{
    cv::Mat outCopyImg;
    image.copyTo(outCopyImg);
    cv::cvtColor(outCopyImg, outCopyImg, CV_BGR2RGB);
    
    if ([self whetherTheImageBlurry:image]) {
        [self.videoCamera stop];
        keepMatImg = outCopyImg;
        
        if (isNeedToCut == YES) {
            CGFloat mianW = UIScreen.mainScreen.bounds.size.width;
            CGFloat  NH = mianW * 1920 / 1080;
            cv::Rect rect(0,(1920 - NH)/2,1080,NH);
            cv::Mat image_roi = outCopyImg(rect);
            self.keepImageAlive = MatToUIImage(image_roi);
        }else{
            self.keepImageAlive = MatToUIImage(outCopyImg);
        }
        
        NSLog(@"keepImageAlive.size = %@",NSStringFromCGSize(self.keepImageAlive.size));
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.keepImageAlive) {
                self.fuzzyText.text = @"清晰";
                self.resultImageView.image = self.keepImageAlive;
                self.resultImageView.hidden = NO;
            }
        });
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.fuzzyText.text = @"模糊";
        });
    }

}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
}


- (void)dealloc{
//    __weak typeof(self) weakSelf = self;
//    NSLog(@" %@ ",self);
//    NSLog(@" %@ ",weakSelf);
//    typeof(self);
//    NSLog(@"%@",typeof(self));
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

- (BOOL)whetherTheImageBlurry:(cv::Mat)mat{
    
    unsigned char *data;
    int height,width,step;
    
    int Iij;
    
    double Iave = 0, Idelta = 0;
    
//    cv::Mat mat = [OpenCVExtension cvMatFromUIImage:image];
    
    if(!mat.empty()){
        cv::Mat gray;
        cv::Mat outGray;
        // 将图像转换为灰度显示
        cv::cvtColor(mat,gray,CV_RGB2GRAY);
        
        cv::Laplacian(gray, outGray, gray.depth());
        
        //        cv::convertScaleAbs( outGray, outGray );
        
        IplImage ipl_image(outGray);
        
        data   = (uchar*)ipl_image.imageData;
        height = ipl_image.height;
        width  = ipl_image.width;
        step   = ipl_image.widthStep;
        
        for(int i=0;i<height;i++)
        {
            for(int j=0;j<width;j++)
            {
                Iij    = (int) data
                [i*width+j];
                Idelta    = Idelta + (Iij-Iave)*(Iij-Iave);
            }
        }
        Idelta = Idelta/(width*height);
        std::cout<<"矩阵方差为："<<Idelta<<std::endl;
    }
    
    return (Idelta > IdeltaCount) ? YES : NO;
}

@end
