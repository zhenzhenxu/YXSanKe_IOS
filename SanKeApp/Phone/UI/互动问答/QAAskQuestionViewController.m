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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) QAInputeTextView *textView;
@end

@implementation QAAskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要提问";
    [self setupNavView];
    [self setupUI];
    [self setupLayout];
    [self setupObservers];
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
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.clipsToBounds = YES;
    
    self.textView = [[QAInputeTextView alloc]initWithPlaceholder:@"请写下您的问题并用问号结尾（30字以内)"];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor yellowColor];
}

- (void)setupLayout {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y + 10, 0);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
