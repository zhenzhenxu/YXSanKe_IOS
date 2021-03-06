//
//  SetPasswordViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "InfoInputView.h"
#import "SubmitButton.h"
#import "SupplementInfoViewController.h"

@interface SetPasswordViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) InfoInputView *userNameInput;
@property (nonatomic, strong) InfoInputView *passwordInput;
@property (nonatomic, strong) SubmitButton *submitButton;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    self.title = @"注册账号";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.topView = [[UIView alloc]init];
    self.topView.layer.cornerRadius = 2.0f;
    self.topView.clipsToBounds = YES;
    
    self.userNameInput = [[InfoInputView alloc] init];
    self.userNameInput.textField.keyboardType = UIKeyboardTypeASCIICapable;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.userNameInput.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:attributes];
    WEAK_SELF
    [self.userNameInput setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    }];
    
    self.passwordInput = [[InfoInputView alloc] init];
    self.passwordInput.layer.cornerRadius = 2.0f;
    self.passwordInput.clipsToBounds = YES;
    self.passwordInput.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordInput.textField.secureTextEntry = YES;
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.passwordInput.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6~18位密码" attributes:attributes1];
    [self.passwordInput setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    }];
    
    self.submitButton = [[SubmitButton alloc]init];
    self.submitButton.title = @"确认";
    [self.submitButton setSubmitBlock:^{
        STRONG_SELF
        [self submitAction];
    }];
    
}

- (void)setupLayout {
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.userNameInput];
    [self.topView addSubview:self.passwordInput];
    [self.contentView addSubview:self.submitButton];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-10.0f);
    }];
    [self.userNameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.topView);
        make.height.mas_equalTo(40.0f);
    }];
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameInput.mas_bottom).offset(1.0f);
        make.left.right.equalTo(self.userNameInput);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.topView);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10.0f);
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(40.0f);
    }];
    
}

- (void)resetButtonEnable {
    __block BOOL passwordFormatIsCorrect;
    [LoginUtils verifyPasswordFormat:self.passwordInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        passwordFormatIsCorrect = !isEmpty && formatIsCorrect;
        
    }];
    self.submitButton.canEdit =  passwordFormatIsCorrect;
}


- (void)submitAction
{
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    NSString *password = self.passwordInput.text;
    if (![self.userNameInput.text yx_isValidString]) {
        [self showToast:@"请输入用户名"];
        return;
    }
    [LoginUtils verifyPasswordFormat:password completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self showToast:@"请输入6~18位数字、字母或符号"];
            return;
        }
        [self registerAccount];
    }];
}

- (void)registerAccount {
    WEAK_SELF
    [self startLoading];
    [LoginDataManager registerWithUserName:self.userNameInput.text password:self.passwordInput.text mobileNumber:self.mobileNumber completeBlock:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        SupplementInfoViewController *vc = [[SupplementInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
