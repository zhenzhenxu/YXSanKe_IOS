//
//  QAReplyQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyQuestionViewController.h"
#import "QATextView.h"

@interface QAReplyQuestionViewController ()
@property (nonatomic, strong) QATextView *textView;
@property (nonatomic, assign) CGFloat oldOffsetY;
@end

@implementation QAReplyQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我来回答";
    [self setupNavView];
    [self setupUI];
    [self setupObservers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button sizeToFit];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self cancelAction];
    }];
    [self setupLeftWithCustomView:button];
    
    [self setupRightWithTitle:@"发布"];
}

- (void)cancelAction {
    DDLogDebug(@"click to cancel");
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviRightAction {
    DDLogDebug(@"click to publish answer");
    [self.view endEditing:YES];
}

- (void)setupUI {
    self.textView = [[QATextView alloc]init];
    self.textView.placeholedr = @"请输入您的回答";
    self.textView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.view).offset(10.0f);
                make.right.equalTo(self.view).offset(-10.0f);
                make.bottom.mas_equalTo(keyboardFrame.origin.y - [UIScreen mainScreen].bounds.size.height - 10);
            }];
            [self.view layoutIfNeeded];
        }];
    }];
}

@end
