//
//  QAQuestionReplyBaseViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionReplyBaseViewController.h"

@interface QAQuestionReplyBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation QAQuestionReplyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupGestureRecognizer];
    [self setupObservers];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.contentView = [[UIView alloc]init];
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
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
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [self.contentView addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer;
    downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.contentView addGestureRecognizer:downRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        DDLogDebug(@"swipe down");
        [self.contentView resignFirstResponder];
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        DDLogDebug(@"swipe up");
        [self.contentView resignFirstResponder];
    }
}

@end
