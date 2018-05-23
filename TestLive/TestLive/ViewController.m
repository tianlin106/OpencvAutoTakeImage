//
//  ViewController.m
//  TestLive
//
//  Created by pk on 2018/2/9.
//  Copyright © 2018年 pk. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import "AAView.h"
#import "TestTableViewCell.h"


typedef void(^GetClearImage)(UIImage * image);

@interface ViewController ()<AAViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AAView * aview = [[AAView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    aview.testDelegate = self;
    [self.view addSubview:aview];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    TestTableViewCell * cell = [[TestTableViewCell alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 50)];
    cell.frame = CGRectMake(0, 300, self.view.bounds.size.width, 50);
    [self.view addSubview:cell];
    
    
    TestTableViewCell * bcell = [[TestTableViewCell alloc] initWithFrame:CGRectMake(0, 600, self.view.bounds.size.width, 50)];
    bcell.frame = CGRectMake(0, 600, self.view.bounds.size.width, 50);
    [self.view addSubview:bcell];
}

- (void)testAAViewDelegate{
    NSLog(@"testAAViewDelegate");
}

- (void)testProtocol{
    NSLog(@"testProtocol");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)idCardAction:(id)sender {
    
    SecondViewController * secVC = [[SecondViewController alloc] initWithType:CameraGetPictureType_IDCard];
    GetClearImage callback = ^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        });
    };
    secVC.getImageCallBack = [callback copy];
    [self.navigationController pushViewController:secVC animated:YES];
}

- (IBAction)btnAction:(id)sender {
    
    SecondViewController * secVC = [[SecondViewController alloc] initWithType:CameraGetPictureType_Licence];
    GetClearImage callback = ^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        });
    };
    secVC.getImageCallBack = [callback copy];
    [self.navigationController pushViewController:secVC animated:YES];
}

@end
