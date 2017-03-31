//
//  QAReplyQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyQuestionViewController.h"
#import "QAInputeTextView.h"

@interface QAReplyQuestionViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) QAInputeTextView *textView;
@end

@implementation QAReplyQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我来回答";
    [self setupNavView];
    [self setupUI];
    [self setupLayout];
    [self setupObservers];
//    [self setupGestureRecognizer];
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
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviRightAction {
    DDLogDebug(@"点击发布");
    [self.view endEditing:YES];
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
    
    self.textView = [[QAInputeTextView alloc]initWithPlaceholder:@"请输入您的回答"];
    self.textView.backgroundColor = [UIColor yellowColor];
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
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
            self.textView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y + 10, 0);
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y , 0);
//            [self.textView setContentOffset:CGPointMake(0.f,self.textView.contentSize.height-self.textView.frame.size.height)];
//            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
//            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.equalTo(self.view).offset(10.0f);
//                make.right.equalTo(self.view).offset(-10.0f);
//                make.bottom.mas_equalTo(keyboardFrame.origin.y - [UIScreen mainScreen].bounds.size.height - 10);
//            }];
//            [self.view layoutIfNeeded];

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
    [self.textView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
