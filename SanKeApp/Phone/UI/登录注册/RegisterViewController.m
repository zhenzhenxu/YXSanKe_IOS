//
//  RegisterViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RegisterViewController.h"
#import "InfoInputView.h"
#import "SetPasswordViewController.h"
#import "PrivacyPolicyViewController.h"
#import "PrivacyPolicyView.h"
#import "SubmitButton.h"
#import "VerifyCodeInputView.h"


@interface RegisterViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) InfoInputView *phoneNumInput;
@property (nonatomic, strong) VerifyCodeInputView *verifyCodeInput;
@property (nonatomic, strong) PrivacyPolicyView *privacyPolicyView;
@property (nonatomic, strong) SubmitButton *submitButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation RegisterViewController

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
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.topView = [[UIView alloc]init];
    self.topView.layer.cornerRadius = 2.0f;
    self.topView.clipsToBounds = YES;
    
    self.phoneNumInput = [[InfoInputView alloc] init];
    self.phoneNumInput.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumInput.placeholder = @"手机号";
    WEAK_SELF
    self.phoneNumInput.textChangeBlock = ^(NSString *text) {
        STRONG_SELF
        if (text.length > 11) {
            self.phoneNumInput.text = [text substringToIndex:11];
        }
        [self resetButtonEnable];
    };
    
    self.verifyCodeInput = [[VerifyCodeInputView alloc] init];
    [self.verifyCodeInput setRightButtonText:@"获取验证码"];
    [self.verifyCodeInput setVerifyCodeBlock:^{
        STRONG_SELF
        [self sendAgainAction];
        DDLogDebug(@"获取验证码");
    }];
    self.verifyCodeInput.codeInputView.textChangeBlock = ^(NSString *text) {
        STRONG_SELF
        if (text.length > 6) {
            self.verifyCodeInput.codeInputView.text = [text substringToIndex:6];
        }
        [self resetButtonEnable];
    };
    [self resetSendAgainButtonTitle];
    
    self.privacyPolicyView = [[PrivacyPolicyView alloc]init];
    self.privacyPolicyView.isMark = YES;
    [self.privacyPolicyView setMarkBlock:^{
        STRONG_SELF
        [self resetButtonEnable];
    }];
    [self.privacyPolicyView setChooseBlock:^{
        STRONG_SELF
        PrivacyPolicyViewController *vc = [[PrivacyPolicyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self resetButtonEnable];
    
    self.submitButton = [[SubmitButton alloc]init];
    self.submitButton.title = @"下一步";
    [self.submitButton setSubmitBlock:^{
        STRONG_SELF
        [self submitAction];
    }];
    [self resetButtonEnable];
}

- (void)setupLayout {
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.phoneNumInput];
    [self.topView addSubview:self.verifyCodeInput];
    [self.contentView addSubview:self.privacyPolicyView];
    [self.contentView addSubview:self.submitButton];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-10.0f);
    }];
    [self.phoneNumInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.topView);
        make.height.mas_equalTo(40.0f);
    }];
    [self.verifyCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneNumInput);
        make.top.equalTo(self.phoneNumInput.mas_bottom).offset(1.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.topView);
    }];
    
    [self.privacyPolicyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(35.0f);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyPolicyView.mas_bottom);
        make.left.right.equalTo(self.privacyPolicyView);
        make.height.mas_equalTo(40.0f);
    }];
}

- (void)resetButtonEnable {
    
    __block BOOL enableVerifyButton;
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        enableVerifyButton = !isEmpty && formatIsCorrect;
    }];
    
    __block BOOL verifyCodeFormatIsCorrect;
    [LoginUtils verifySMSCodeFormat:self.verifyCodeInput.codeInputView.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        verifyCodeFormatIsCorrect = !isEmpty && formatIsCorrect;
    }];
    
    BOOL enableRegisterButton;
    
    enableRegisterButton = enableVerifyButton && verifyCodeFormatIsCorrect && self.privacyPolicyView.isMark;
    
    self.submitButton.canEdit =  enableRegisterButton;
}

- (void)sendAgainAction {
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (isEmpty) {
            [self showToast:@"请输入您的手机号码"];
            return;
        }
        if (!formatIsCorrect) {
            [self showToast:@"您输入的手机号码错误"];
            return;
        }
        [self getVerifyCodeRequest];
    }];
}

- (void)getVerifyCodeRequest {
    //    if (self.timer) {
    //        return;
    //    }
    //    [self startTimer];
    //    WEAK_SELF
    //    [self startLoading];
    //    [LoginDataManager getVerifyCodeWithMobileNumber:self.phoneNumInput.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
    //        STRONG_SELF
    //        [self stopLoading];
    //        if (error) {
    //            [self stopTimer];
    //            [self showToast:error.localizedDescription];
    //        }
    //        [self showToast:@"验证码已发送至您的手机"];
    //    }];
    //测试
    [self showToast:@"验证码已发送至您的手机"];
}

- (void)startTimer {
    if (!self.timer) {
        self.seconds = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countdownTimer {
    if (self.seconds <= 0) {
        [self stopTimer];
    } else {
        [self.verifyCodeInput resetRightButtonText:[NSString stringWithFormat:@"%@秒后重试", @(self.seconds)]];
        self.seconds--;
    }
    [self.verifyCodeInput setRightButtonEnabled:self.seconds <= 0];
}

- (void)stopTimer {
    [self resetSendAgainButtonTitle];
    [self.timer invalidate];
    self.timer = nil;
    self.seconds = 0;
}

- (void)resetSendAgainButtonTitle {
    [self.verifyCodeInput setRightButtonText:@"获取验证码"];
}

- (void)submitAction {
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self showToast:@"请输入正确的手机号码"];
            return;
        }
        [self verifySMSCode];
    }];
}

- (void)verifySMSCode {
    //    WEAK_SELF
    //    [self startLoading];
    //    [LoginDataManager verifySMSCodeWithMobileNumber:self.phoneNumInput.text verifyCode:self.verifyCodeInput.codeInputView.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
    //        STRONG_SELF
    //        [self stopLoading];
    //        if (error) {
    //            [self showToast:error.localizedDescription];
    //            return;
    //        }
    //    SetPasswordViewController *vc = [[SetPasswordViewController alloc]init];
    //    vc.phoneNumber = self.phoneNumInput.text;
    //    [self.navigationController pushViewController:vc animated:YES];
    //    }];
    //测试
    SetPasswordViewController *vc = [[SetPasswordViewController alloc]init];
    vc.phoneNumber = self.phoneNumInput.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
