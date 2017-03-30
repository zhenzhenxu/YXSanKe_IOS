//
//  QAAskQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAAskQuestionViewController.h"
#import "QAInputeTextView.h"
#import "QAPublishQuestionViewController.h"

@interface QAAskQuestionViewController ()<UITextViewDelegate>
@property (nonatomic, strong) QAInputeTextView *textView;
@end

@implementation QAAskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要提问";
    [self setupNavView];
    [self setupUI];
    [self setupObservers];
    [self setupGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNavView
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
    //弹提示框 然后反应
    DDLogDebug(@"点击取消按钮");
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction {
    DDLogDebug(@"点击下一步");
    [self.view endEditing:YES];
    if (![self.textView.text yx_isValidString]) {
        [self showToast:@"空"];
    }else {
        QAPublishQuestionViewController *vc = [[QAPublishQuestionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupUI {
    self.textView = [[QAInputeTextView alloc]initWithPlaceholder:@"请写下您的问题并用问号结尾（30字以内)"];
    [self.view addSubview:self.textView];
    //    self.textView.backgroundColor = [UIColor redColor];
    self.textView.delegate = self;
    
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
            self.textView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y + 10, 0);
        }];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    if (content.length > 30) {
        textView.text =  [content substringToIndex:30];
    }
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
