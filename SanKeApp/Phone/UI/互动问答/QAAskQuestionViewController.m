//
//  QAAskQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAAskQuestionViewController.h"
#import "QAPublishQuestionViewController.h"
#import "QATextView.h"

@interface QAAskQuestionViewController ()<UITextViewDelegate>
@property (nonatomic, strong) QATextView *textView;
@end

@implementation QAAskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要提问";
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
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftButton sizeToFit];
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self cancelAction];
    }];
    [self setupLeftWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightButton sizeToFit];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self nextAction];
    }];
    [self setupRightWithCustomView:rightButton];
}

- (void)cancelAction {
    DDLogDebug(@"click to cancel");
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction {
    DDLogDebug(@"click to next step");
    [self.view endEditing:YES];
    if (![self.textView.text yx_isValidString]) {
        [self showToast:@"空"];
    }else {
        QAPublishQuestionViewController *vc = [[QAPublishQuestionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupUI {
    self.textView = [[QATextView alloc]init];
    self.textView.placeholedr = @"请写下您的问题并用问号结尾（30字以内)";
    self.textView.delegate = self;
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

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    if (content.length > 30) {
        textView.text =  [content substringToIndex:30];
    }
}

@end
