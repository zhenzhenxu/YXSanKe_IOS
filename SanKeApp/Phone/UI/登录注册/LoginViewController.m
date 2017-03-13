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
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginInputView *usernameView;
@property (nonatomic, strong) LoginInputView *passwordView;
@property (nonatomic, strong) LoginLogoView *logoView;
@property (nonatomic, strong) LoginActionView *actionView;
@property (nonatomic, strong) UIButton *forgotButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *touristButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupLayout];
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
    actionView.title = @"登录";
    WEAK_SELF
    [actionView setActionBlock:^{
        STRONG_SELF
        [self startLogin];
    }];
    self.actionView = actionView;
    
    self.passwordView = [[LoginInputView alloc]init];
    NSAttributedString *passwordPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passwordView.textField.attributedPlaceholder = passwordPlaceholder;
    self.passwordView.textField.secureTextEntry = YES;
    
    self.usernameView = [[LoginInputView alloc]init];
    NSAttributedString *usernamePlaceholder = [[NSMutableAttributedString alloc]initWithString:@"用户名／手机号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.usernameView.textField.attributedPlaceholder = usernamePlaceholder;
    
    self.logoView = [[LoginLogoView alloc]init];
    
    UIButton *touristButton = [[UIButton alloc]init];
    touristButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [touristButton setTitle:@"随便看看" forState:UIControlStateNormal];
    [touristButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [touristButton addTarget:self action:@selector(touristLogin) forControlEvents:UIControlEventTouchUpInside];
    self.touristButton = touristButton;
    
    UIButton *forgotButton = [[UIButton alloc]init];
    forgotButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [forgotButton addTarget:self action:@selector(forgotPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    self.forgotButton = forgotButton;
    
    UIButton *registerButton = [[UIButton alloc]init];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton= registerButton;
}

- (void)setupLayout {
    [self.contentView addSubview:self.actionView];
    [self.contentView addSubview:self.passwordView];
    [self.contentView addSubview:self.usernameView];
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.touristButton];
    [self.contentView addSubview:self.forgotButton];
    [self.contentView addSubview:self.registerButton];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75*[UIScreen mainScreen].bounds.size.width/375);
        make.right.mas_equalTo(-75*[UIScreen mainScreen].bounds.size.width/375);
        make.bottom.mas_equalTo(-90);
        make.height.mas_equalTo(40);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.actionView.mas_left);
        make.right.mas_equalTo(self.actionView.mas_right);
        make.bottom.mas_equalTo(self.actionView.mas_top).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.actionView.mas_left);
        make.right.mas_equalTo(self.actionView.mas_right);
        make.bottom.mas_equalTo(self.passwordView.mas_top).mas_offset(-10);
        make.height.mas_equalTo(40);
    }];

    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.usernameView.mas_top);
    }];
    
    [self.touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.actionView.mas_bottom).mas_equalTo(15);
    }];
    
    [self.forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actionView);
        make.top.equalTo(self.touristButton);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.actionView);
        make.top.equalTo(self.touristButton);
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
    WEAK_SELF
    [self startLoading];
    [LoginDataManager loginWithName:self.usernameView.text password:self.passwordView.text completeBlock:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        if ([UserManager sharedInstance].userModel.isTaged) {
            return;
        }
        StageSubjectSelectViewController *vc = [[StageSubjectSelectViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)touristLogin {
    WEAK_SELF
    [self startLoading];
    [LoginDataManager touristLoginWithCompleteBlock:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        if ([UserManager sharedInstance].userModel.isTaged) {
            return;
        }
        StageSubjectSelectViewController *vc = [[StageSubjectSelectViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)forgotPasswordAction {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerAction {
    YXProblemItem *item = [[YXProblemItem alloc]init];
    item.objType = @"reg";
    item.type = YXRecordClickType;
    [YXRecordManager addRecord:item];
    
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
