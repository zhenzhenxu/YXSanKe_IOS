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

@interface SetPasswordViewController ()
@property (nonatomic, strong) InfoInputView *passwordInput;
@property (nonatomic, strong) SubmitButton *submitButton;

@property (nonatomic, assign) PasswordOperationType type;
@property (nonatomic, strong) NSString *phoneNumber;
@end

@implementation SetPasswordViewController

- (instancetype)initWithType:(PasswordOperationType)type phoneNumber:(NSString *)phoneNumber
{
    if (self = [super init]) {
        self.type = type;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

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
    
    if (self.type == PasswordOperationType_FirstSet) {
        self.title = @"设置密码";
    }else {
        self.title = @"重置密码";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.passwordInput = [[InfoInputView alloc] init];
    self.passwordInput.layer.cornerRadius = 2.0f;
    self.passwordInput.clipsToBounds = YES;
    self.passwordInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordInput.placeholder = @"请输入6~18位密码";
    WEAK_SELF
    self.passwordInput.textChangeBlock = ^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    };
    
    self.submitButton = [[SubmitButton alloc]init];
    self.submitButton.title = @"确认";
    [self.submitButton setSubmitBlock:^{
        STRONG_SELF
        [self submitAction];
    }];
    
}

- (void)setupLayout {
    [self.contentView addSubview:self.passwordInput];
    [self.contentView addSubview:self.submitButton];
    
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-10.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordInput.mas_bottom).offset(10.0f);
        make.left.right.equalTo(self.passwordInput);
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
    NSString *password = self.passwordInput.text;
    [LoginUtils verifyPasswordFormat:password completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self showToast:@"请输入6~18位数字、字母或符号"];
            return;
        }
        [self setPasswordRequest];
    }];
}

- (void)setPasswordRequest
{
//    [self startLoading];
//    WEAK_SELF
//    [LoginDataManager setPasswordWithMobileNumber:self.phoneNumber password:self.passwordInput.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
//        STRONG_SELF
//        [self stopLoading];
//        if (error) {
//            [self showToast:error.localizedDescription];
//            return;
//        }
//      
//        if (self.type == PasswordOperationType_FirstSet) {
//            DDLogDebug(@"跳转到个人信息必填页");
//            [self showToast:@"设置密码成功"];
//        }
//        if (self.type == PasswordOperationType_Reset) {
//            DDLogDebug(@"跳转到登陆页");
//            [self showToast:@"重置密码成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:YES];//测试
//            });
//        }
//    }];
    //测试
    [self showToast:@"设置密码成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });


}

@end
