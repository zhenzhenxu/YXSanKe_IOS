//
//  QAReplyQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyQuestionViewController.h"
#import "QAInputeTextView.h"

@interface QAReplyQuestionViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) QAInputeTextView *textView;

@end

@implementation QAReplyQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我来回答";
    [self setupNavView];
    [self setupUI];
    [self setupGestureRecognizer];
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
    //弹提示框 然后反应
    DDLogDebug(@"点击取消按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviRightAction {
    DDLogDebug(@"点击发布");
}

- (void)setupUI {
    self.textView = [[QAInputeTextView alloc]initWithPlaceholder:@"请输入您的回答"];
    [self.view addSubview:self.textView];
    self.textView.backgroundColor = [UIColor redColor];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(10.0f);
                make.bottom.mas_equalTo(-10.f - keyboardFrame.size.height);
                make.right.mas_equalTo(-10.f);
            }];
            [self.view layoutIfNeeded];
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
            }];
            [self.view layoutIfNeeded];
        }];
    }];
}

#pragma mark - GestureRecognizer
- (void)setupGestureRecognizer {
    UISwipeGestureRecognizer *upRecognizer;
    upRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.textView addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer;
    downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.textView addGestureRecognizer:downRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        DDLogDebug(@"swipe down");
        [self.textView resignFirstResponder];
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        DDLogDebug(@"swipe up");
        [self.textView resignFirstResponder];
    }
}

@end
