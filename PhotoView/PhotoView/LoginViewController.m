//
//  LoginViewController.m
//  PhotoView
//
//  Created by qingyun on 15-2-9.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登陆";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 用户名
    _nameLabel = [[UITextField alloc] initWithFrame:CGRectMake(50, 180, 220, 44)];
    _nameLabel.borderStyle = UITextBorderStyleRoundedRect;
    _nameLabel.placeholder = @"请输入用户名";
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 44)];
    UIImageView *leftLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_icon_arrow"]];
    leftLabel.frame = CGRectMake(18, 10, 24, 24);
    // leftview可以是任意的UIView，可以自定义，理论多复杂都可以
    [leftView addSubview:leftLabel];
    _nameLabel.leftView = leftView;
    _nameLabel.leftViewMode = UITextFieldViewModeAlways;
    
    // 密码
    UITextField *pwdText = [[UITextField alloc] initWithFrame:CGRectMake(50, 240, 220, 44)];
    pwdText.borderStyle = UITextBorderStyleRoundedRect;
    pwdText.placeholder = @"请输入密码";
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 44)];
    UIImageView *rightLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_icon_unblock"]];
    rightLabel.frame = CGRectMake(18, 10, 24, 24);
    // leftview可以是任意的UIView，可以自定义，理论多复杂都可以
    [rightView addSubview:rightLabel];
    pwdText.leftView = rightView;
    pwdText.leftViewMode = UITextFieldViewModeAlways;
    
    
    // 登陆按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(115, pwdText.frame.origin.y+60, 90, 45);
    [submitButton setTitle:@"登陆" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"adward_button"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"adward_button_highlighted"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_nameLabel];
    [self.view addSubview:pwdText];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 隐藏导航和工具条
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}

// 登陆事件
- (void)logIn
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    // 使用属性传值
    [mainVC setName:_nameLabel.text];
    [self.navigationController pushViewController:mainVC animated:YES];
}


@end
