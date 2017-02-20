//
//  ZoomImageView.h
//  ImgScale
//
//  Created by BO on 17/2/20.
//  Copyright © 2017年 xsqBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LongProgressNoti  @"LongProgressNoti"

typedef NS_ENUM(NSInteger,xsqGestureRecognizerType){
    
    xsqSigleTapGestureRecognizerType,   //点击触发
    xsqDoubleTapGestureRecognizerType,  //双击触发
    xsqLongPressGestureRecognizerType   //长按触发
};

@interface ZoomImageView : UIView

//实例化一个调用类
+(instancetype)getZoomImageView;

//初始化要展示的图片
-(void)showZoomImageView:(UIImageView *)imageView addGRType:(xsqGestureRecognizerType)grType;

@end
