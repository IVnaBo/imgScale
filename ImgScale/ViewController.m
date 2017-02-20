//
//  ViewController.m
//  ImgScale
//
//  Created by BO on 17/2/20.
//  Copyright © 2017年 xsqBo. All rights reserved.
//

#import "ViewController.h"
#import "ZoomImageView.h"
@interface ViewController ()
@property(strong,nonatomic)UIImageView * global_img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * img = [UIImage imageNamed:@"socute"];
    UIImageView * imgv = [[UIImageView alloc]initWithImage:img];
    imgv.frame = CGRectMake(45, 60, 80, 80);
    imgv.userInteractionEnabled = YES;
    [[ZoomImageView getZoomImageView]showZoomImageView:imgv addGRType:xsqSigleTapGestureRecognizerType];
    [self.view addSubview:imgv];

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LongPressGT:) name:LongProgressNoti object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
