//
//  LoginViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginViewController.h"
#import "StageSubjectSelectViewController.h"
#import "LoginActionView.h"
#import "LoginInputView.h"
#import "LoginLogoView.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginInputView *usernameView;
@property (nonatomic, strong) LoginInputView *passwordView;
@property (nonatomic, strong) LoginLogoView *logoView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI {
    LoginActionView *actionView = [[LoginActionView alloc]init];
    actionView.title = @"登陆";
    WEAK_SELF
    [actionView setActionBlock:^{
        STRONG_SELF
        [self startLogin];
    }];
    [self.contentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-90);
        make.height.mas_equalTo(40);
    }];
    
    self.passwordView = [[LoginInputView alloc]init];
    NSAttributedString *passwordPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passwordView.textField.attributedPlaceholder = passwordPlaceholder;
    self.passwordView.textField.secureTextEntry = YES;
    [self.contentView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(actionView.mas_left);
        make.right.mas_equalTo(actionView.mas_right);
        make.bottom.mas_equalTo(actionView.mas_top).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    self.usernameView = [[LoginInputView alloc]init];
    NSAttributedString *usernamePlaceholder = [[NSMutableAttributedString alloc]initWithString:@"用户名／手机号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.usernameView.textField.attributedPlaceholder = usernamePlaceholder;
    [self.contentView addSubview:self.usernameView];
    [self.usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(actionView.mas_left);
        make.right.mas_equalTo(actionView.mas_right);
        make.bottom.mas_equalTo(self.passwordView.mas_top).mas_offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    self.logoView = [[LoginLogoView alloc]init];
    [self.contentView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.usernameView.mas_top);
    }];
    
    UIButton *touristButton = [[UIButton alloc]init];
    touristButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [touristButton setTitle:@"游客登陆" forState:UIControlStateNormal];
    [touristButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [touristButton addTarget:self action:@selector(touristLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:touristButton];
    [touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(actionView.mas_bottom).mas_equalTo(15);
    }];
}

- (void)startLogin {
    DDLogWarn(@"用户名：%@, 密码：%@",self.usernameView.text,self.passwordView.text);
    if (isEmpty(self.usernameView.text)) {
        [self showToast:@"请输入用户名"];
        return;
    }
    if (isEmpty(self.passwordView.text)) {
        [self showToast:@"请输入密码"];
        return;
    }
    [UserManager sharedInstance].loginStatus = YES;
}

- (void)touristLogin {
    StageSubjectSelectViewController *vc = [[StageSubjectSelectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
