//
//  MainViewController.m
//  PhotoView
//
//  Created by qingyun on 15-2-9.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"图片浏览器";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置默认加载图片和图片总数
    _imageNo = 1;
    _allImageNum = 10;
    
    // 更改导航栏上的功能标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    titleLabel.text = @"图片浏览器";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor purpleColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    // 使用UISwitch开启/关闭夜间模式
    _nightOpen = [[UISwitch alloc] initWithFrame:CGRectZero];
    _nightOpen.tintColor = [UIColor greenColor];
    _nightOpen.onTintColor = [UIColor blackColor];
    [_nightOpen addTarget:self action:@selector(openNight) forControlEvents:UIControlEventValueChanged];
    // 将夜间模式开关设为导航条上的rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nightOpen];
    
    // 设置加载图片数量的文本框
    _numberText = [[UITextField alloc] initWithFrame:CGRectMake(50, 80, 100, 40)];
    _numberText.borderStyle = UITextBorderStyleBezel;
    _numberText.backgroundColor = [UIColor cyanColor];
    // 设置该文本框位数字输入模式键盘
    _numberText.keyboardType = UIKeyboardTypeNumberPad;
    _numberText.delegate = self;
    
    // 设置“设置”按钮
    _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberButton.frame = CGRectMake(_numberButton.frame.origin.x+100+40+50, 80, 80, 40);
    [_numberButton setTitle:@"设置" forState:UIControlStateNormal];
    [_numberButton setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    _numberButton.backgroundColor = [UIColor greenColor];
    [_numberButton addTarget:self action:@selector(clickSetButton) forControlEvents:UIControlEventTouchDown];
    
    // 设置图片显示的UIImageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 140, 220, 220)];
    // contentMode模式改成压缩居中模式
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 屏幕左侧点击区域
    _leftConrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 140, 160, 220)];
    [_leftConrol addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchDown];
    // 屏幕右侧点击区域
    _rightConrol = [[UIControl alloc] initWithFrame:CGRectMake(160, 140, 160, 220)];
    [_rightConrol addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchDown];
    
    // 控制拖动加载的滑动条
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 360, 280, 40)];
    _slider.minimumValue = 1;
    // 将滑动条的最大值跟图片总数属性保持一致
    _slider.maximumValue = _allImageNum;
    [_slider addTarget:self action:@selector(slderDrag) forControlEvents:UIControlEventValueChanged];
    
    // 控制分页 加载的分页控制器
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(20, 400, 280, 40)];
    // 将总页数跟图片总数属性保持一致
    _page.numberOfPages = _allImageNum;
    _page.pageIndicatorTintColor = [UIColor orangeColor];
    _page.currentPageIndicatorTintColor = [UIColor grayColor];
    [_page addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    
    // 功能描述区
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 420, 280, 100)];
    _descLabel.font = [UIFont systemFontOfSize:17];
    _descLabel.numberOfLines = 0;
    
    // 功能描述切换
    _descSegment = [[UISegmentedControl alloc] initWithItems:@[@"功能简介",@"作者",@"捐赠"]];
    _descSegment.frame = CGRectMake(0, 0, 280, 30);
    [_descSegment addTarget:self action:@selector(descShow) forControlEvents:UIControlEventValueChanged];
    
    // ToolBar上左右两侧的留空
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 将功能描述切换按钮设定在ToolBar上
    UIBarButtonItem *segmentItem = [[UIBarButtonItem alloc] initWithCustomView:_descSegment];
    [self setToolbarItems:@[spaceItem,segmentItem,spaceItem]];
    
    // 把所有控件添加到self.view上
    [self.view addSubview:_numberText];
    [self.view addSubview:_numberButton];
    [self.view addSubview:_imageView];
    [self.view addSubview:_slider];
    [self.view addSubview:_page];
    [self.view addSubview:_leftConrol];
    [self.view addSubview:_rightConrol];
    [self.view addSubview:_descLabel];
    
    // 加载图片
    [self loadImage];
}

// 设置导航条和工具栏的显示（隐藏），不管该视图控制器如何加载，都要走viewWillAppear方法和viewDidAppear
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - _numberText Delegate
// 代理：监控文本框是否以0开始
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0 && [string isEqualToString:@"0"]) {
        [self creaytAlert:@"不能以0开始！"];
        return NO;
    }
    return YES;
}
// 代理：监控文本框中数字是否超过20
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] > 20) {
        [self creaytAlert:@"总页数不能超过20！"];
        return NO;
    }
    return YES;
}

#pragma mark - Custom Function
// 加载图片方法
- (void)loadImage
{
    [_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", _imageNo]]];
}
// 警告信息封装
- (void)creaytAlert:(NSString *)alertMsg
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"警告" message:alertMsg delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [errorAlert show];
}

#pragma mark - UIContorl Action
// 开启/关闭夜间模式
- (void)openNight
{
    if (_nightOpen.isOn) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}
// 设置按钮事件
- (void)clickSetButton
{
    // resignFirstResponder是有返回值的，可以直接用捕获文本结束是否成功
    if ([_numberText resignFirstResponder]) {
        _allImageNum = [_numberText.text intValue];
        _slider.maximumValue = _allImageNum;
        _slider.value = 1;
        _page.numberOfPages = _allImageNum;
        _page.currentPage = 0;
        _numberText.text = nil;
        [self loadImage];
    }
}
// 拖动滑动条，保持跟_page同步
- (void)slderDrag
{
    _imageNo = _slider.value;
    _page.currentPage = _slider.value-1;
    [self loadImage];
}
// 点击分页控制器，保持跟_slider同步
- (void)pageChange
{
    _slider.value = _page.currentPage+1;
    _imageNo = _slider.value;
    [self loadImage];
}
// 屏幕左侧点击事件
- (void)clickLeft
{
    if (_imageNo == 1) {
        [self creaytAlert:@"这已经是第一张了!"];
    } else {
        _imageNo--;
        _slider.value--;
        _page.currentPage--;
        [self loadImage];
    }
}
// 屏幕右侧点击事件
- (void)clickRight
{
    if (_imageNo == _allImageNum) {
        [self creaytAlert:@"已经超出最大限制"];
    } else {
        _imageNo++;
        _slider.value++;
        _page.currentPage++;
        [self loadImage];
    }
}
// 分段按钮点击事件，用来切换功能描述
- (void)descShow
{
    switch (_descSegment.selectedSegmentIndex) {
        case 0:
            _descLabel.text = @"这是我的第一个APP，还好吧，我已经看到了未来的曙光！";
            break;
        case 1:
            _descLabel.text = [NSString stringWithFormat:@"未来大神---%@", _name];
            break;
        case 2:
            _descLabel.text = @"送人玫瑰，手留余香。。。看啥呢，说你呢！";
            break;
        default:
            break;
    }
}
@end
