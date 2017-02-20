//
//  ZoomImageView.m
//  ImgScale
//
//  Created by BO on 17/2/20.
//  Copyright © 2017年 xsqBo. All rights reserved.
//

#import "ZoomImageView.h"

#define Iphone_W  [UIScreen mainScreen].bounds.size.width
#define Iphone_H [UIScreen mainScreen].bounds.size.height

@interface ZoomImageView ()<UIScrollViewDelegate>{
    
    UIImageView *_showImageView;//图片视图
    CGRect _originalFrame;
    UIScrollView *_scrollView;
}
@property(strong,nonatomic)UIImageView *tempImageView;


@end
@implementation ZoomImageView

//实例化一个调用类
+(instancetype)getZoomImageView{
    
    static ZoomImageView *aZoomImageView;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        aZoomImageView=[[self alloc]init];
    });
    return aZoomImageView;
    
}

//初始化要展示的图片
-(void)showZoomImageView:(UIImageView *)imageView addGRType:(xsqGestureRecognizerType)grType{
    
    self.tempImageView = imageView;
    
    [self imageViewAddGRType:grType byImageView:imageView];
    
}


/**
 为Imgv 添加指定的手势
 
 @param gRType 手势类型 如 长按。 轻拍 双击
 @param imageView imgv
 */
-(void)imageViewAddGRType:(xsqGestureRecognizerType)gRType byImageView:(UIImageView *)imageView{
    
    imageView.userInteractionEnabled=YES;
    imageView.superview.userInteractionEnabled=YES;
    
    switch (gRType) {
        case xsqSigleTapGestureRecognizerType: {
            
            UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势
            
            tapSingleGR.numberOfTapsRequired = 1; //设置单击几次才触发方法
            
            [imageView addGestureRecognizer:tapSingleGR];
            
            break;
        }
            
        case xsqDoubleTapGestureRecognizerType: {
            
            
            UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势
            doubleTapGR.numberOfTapsRequired = 2; //设置单击几次才触发方法
            doubleTapGR.numberOfTouchesRequired = 1;
            
            if(imageView.gestureRecognizers.count!=0){
                UITapGestureRecognizer *tempTapGR=imageView.gestureRecognizers.firstObject;
                tempTapGR.numberOfTapsRequired = 1;
                // 双击手势确定监测失败才会触发单击手势的相应操作
                [tempTapGR requireGestureRecognizerToFail:doubleTapGR];
            }
            
            [imageView addGestureRecognizer:doubleTapGR];
            
            break;
        }
            
        case xsqLongPressGestureRecognizerType: {
            
            UILongPressGestureRecognizer *pressLongGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            
            [pressLongGestureRecognizer addTarget:self action:@selector(imageViewGestureAction:)]; //给长按手势添加方法
            
            [imageView addGestureRecognizer:pressLongGestureRecognizer]; // 添加到当前的ImageView
            
            break;
        }
    }
    
}


-(void)imageViewGestureAction:(UIGestureRecognizer *)gestureRecognizer{
  
        [self tapGR:gestureRecognizer];
 
}


-(void)tapGR:(UIGestureRecognizer *)gestureRecognizer{
    
    UIImageView *imageView=(UIImageView *)gestureRecognizer.view;
    
    if (imageView.image) {//判断图片是否为空...
        
        UIImageView *showImageView=[[UIImageView alloc]initWithImage:imageView.image];
        showImageView.userInteractionEnabled = YES;
        _showImageView=showImageView;
        [self addSubview:showImageView];
        
        UIScrollView *bgView = [[UIScrollView alloc] init];//scrollView作为背景
        bgView.frame = [UIScreen mainScreen].bounds;
        bgView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgViewGestureR:)];
        [bgView addGestureRecognizer:tapBg];
        
        showImageView.frame = [_tempImageView convertRect:_tempImageView.bounds toView:nil];
        
        [bgView addSubview:showImageView];
        
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
        _originalFrame = _showImageView.frame;
        _scrollView = bgView;
        
        //最大放大比例
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.delegate = self;
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = imageView.frame;
            frame.size.width = bgView.frame.size.width-10;
            frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
            frame.origin.x = 5;
            if (frame.size.height < Iphone_H-20) {
                
                frame.origin.y =(bgView.frame.size.height - frame.size.height) * 0.5;;
            }else{
                frame.origin.y = 10;
            }
            
            _showImageView.frame = frame;
        }];
        bgView.contentSize=CGSizeMake(0, _showImageView.frame.size.height);
    }
}


/**
 背景点击。。。

 @param tapGR <#tapGR description#>
 */
-(void)tapBgViewGestureR:(UITapGestureRecognizer *)tapGR{
    
    _scrollView.contentOffset = CGPointZero;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _showImageView.frame = _originalFrame;
        
        tapGR.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        [_showImageView removeFromSuperview];
        [_scrollView removeFromSuperview];
    }];
}


//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _showImageView;
}


@end
