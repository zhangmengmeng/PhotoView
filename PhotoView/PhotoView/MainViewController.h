//
//  MainViewController.h
//  PhotoView
//
//  Created by qingyun on 15-2-9.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIViewController实现文件上下文中要用到的控件都写成属性

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) NSString *name;

@property (nonatomic) int imageNo;
@property (nonatomic) int allImageNum;

@property (strong, nonatomic) UISwitch *nightOpen;

@property (strong, nonatomic) UITextField *numberText;
@property (strong, nonatomic) UIButton *numberButton;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIControl *leftConrol;
@property (strong, nonatomic) UIControl *rightConrol;


@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UIPageControl *page;

@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UISegmentedControl *descSegment;

@end
