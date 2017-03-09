//
//  VerifyCodeInputView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VerifyCodeInputView.h"
#import "InfoInputView.h"


@interface VerifyCodeInputView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *getCodeButton;

@property (nonatomic, copy) VerifyCodeBlock block;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;
@end


@implementation VerifyCodeInputView

- (void)dealloc {
    DDLogDebug(@"%@释放了", [self.timer class]);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.codeInputView = [[InfoInputView alloc]init];
    
    self.codeInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.codeInputView.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机验证码" attributes:attributes];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"c6c9cc"];
    
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.getCodeButton addTarget:self action:@selector(getCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLayout {
    [self addSubview:self.codeInputView];
    [self addSubview:self.lineView];
    [self addSubview:self.getCodeButton];
    
    [self.codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.lineView.mas_left);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(10.0f);
        make.right.equalTo(self.getCodeButton.mas_left).offset(-10.0f);
    }];
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.0f);
        make.centerY.equalTo(self);
    }];
}

- (void)getCodeButtonAction {
    BLOCK_EXEC(self.block);
}

- (void)setRightButtonText:(NSString *)text
{
    [self.getCodeButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [self.getCodeButton setTitle:text forState:UIControlStateNormal];
}

- (void)resetRightButtonText:(NSString *)text
{
    [self.getCodeButton setTitleColor:[UIColor colorWithHexString:@"c6c9cc"] forState:UIControlStateNormal];
    [self.getCodeButton setTitle:text forState:UIControlStateNormal];
}

- (void)setRightButtonEnabled:(BOOL)enabled
{
    _getCodeButton.enabled = enabled;
}

- (void)setVerifyCodeBlock:(VerifyCodeBlock)block {
    self.block = block;
}

#pragma mark - timer
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
        [self resetRightButtonText:[NSString stringWithFormat:@"%02zd秒后重试",self.seconds]];
        self.seconds--;
    }
    [self setRightButtonEnabled:self.seconds <= 0];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.seconds = 0;
    [self setRightButtonText:@"获取验证码"];
    [self setRightButtonEnabled:self.seconds <= 0];
}
@end
