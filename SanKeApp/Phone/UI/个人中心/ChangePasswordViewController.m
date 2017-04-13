//
//  ChangePasswordViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "InfoInputView.h"
#import "SubmitButton.h"

static NSString *const kChangePasswordType = @"1";
@interface ChangePasswordViewController ()

@property (nonatomic, strong) InfoInputView *passwordInput;
@property (nonatomic, strong) InfoInputView *confirmPasswordInput;
@property (nonatomic, strong) SubmitButton *submitButton;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self setupUI];
    [self setupLayout];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.passwordInput = [[InfoInputView alloc] init];
    self.passwordInput.textField.keyboardType = UIKeyboardTypeASCIICapable;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.passwordInput.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入新密码" attributes:attributes];
    self.passwordInput.layer.cornerRadius = 2.0f;
    self.passwordInput.clipsToBounds = YES;
    self.passwordInput.textField.secureTextEntry = YES;
    WEAK_SELF
    [self.passwordInput setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    }];
    
    self.confirmPasswordInput = [[InfoInputView alloc] init];
    self.confirmPasswordInput.layer.cornerRadius = 2.0f;
    self.confirmPasswordInput.clipsToBounds = YES;
    self.confirmPasswordInput.textField.keyboardType = UIKeyboardTypeASCIICapable;
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.confirmPasswordInput.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:attributes1];
    self.confirmPasswordInput.layer.cornerRadius = 2.0f;
    self.confirmPasswordInput.clipsToBounds = YES;
    self.confirmPasswordInput.textField.secureTextEntry = YES;
    [self.confirmPasswordInput setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    }];
    
    self.submitButton = [[SubmitButton alloc]init];
    self.submitButton.title = @"确认";
    [self.submitButton setSubmitBlock:^{
        STRONG_SELF
        [self submitAction];
    }];
    [self resetButtonEnable];
}

- (void)setupLayout {
    [self.view addSubview:self.passwordInput];
    [self.view addSubview:self.confirmPasswordInput];
    [self.view addSubview:self.submitButton];
    
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10.0f);
        make.right.equalTo(self.view).offset(-10.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [self.confirmPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordInput.mas_bottom).offset(10.0f);
        make.left.right.equalTo(self.passwordInput);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordInput.mas_bottom).offset(10.0f);
        make.left.right.equalTo(self.confirmPasswordInput);
        make.height.mas_equalTo(40.0f);
    }];
    
}

- (void)resetButtonEnable {

    BOOL isCorrect = [self.passwordInput.text yx_isValidString] && [self.confirmPasswordInput.text yx_isValidString];
    
    self.submitButton.canEdit = isCorrect;
}

- (void)submitAction
{
    [self.passwordInput resignFirstResponder];
    [self.confirmPasswordInput resignFirstResponder];
    NSString *password = self.passwordInput.text;
    NSString *confirmPassword = self.confirmPasswordInput.text;
    WEAK_SELF
    [LoginUtils verifyPasswordFormat:password completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        STRONG_SELF
        if (!formatIsCorrect) {
            [self showToast:@"请输入6~18位数字、字母或符号"];
            return;
        }
        if (![password isEqualToString:confirmPassword]) {
            [self showToast:@"新密码与确认密码不一致，请重新填写"];
            return;
        }
        [self changePassword];
    }];
}

- (void)changePassword {
    [self startLoading];
    WEAK_SELF
    [LoginDataManager changePasswordWithMobileNumber:[UserManager sharedInstance].userModel.name password:self.passwordInput.text type:kChangePasswordType completeBlock:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self showToast:@"修改密码成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}
@end
