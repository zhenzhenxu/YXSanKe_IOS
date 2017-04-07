//
//  QAReplyQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyQuestionViewController.h"
#import "QATextView.h"
#import "MenuSelectionView.h"
#import "QAQuestionDetailViewController.h"

@interface QAReplyQuestionViewController ()
@property (nonatomic, strong) QATextView *textView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@end

@implementation QAReplyQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我来回答";
    [self setupUI];
    [self setupObservers];
    [self setupNavView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[QATextView alloc]init];
    self.textView.placeholder = @"请输入您的回答";
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark - setupObservers
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

#pragma mark - setupNavView
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
    [self handleCancelAction];
}

- (void)handleCancelAction {
    self.menuSelectionView = [[MenuSelectionView alloc]init];
    self.menuSelectionView.dataArray = @[
                                         @"确定",
                                         @"取消"
                                         ];
    CGFloat height = [self.menuSelectionView totalHeight];
    [self.view addSubview:self.menuSelectionView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    alert.contentView = self.menuSelectionView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_bottom).offset(0);
                make.height.mas_equalTo(height);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.mas_bottom).offset(0);
            make.height.mas_equalTo(height);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.height.mas_equalTo(height);
                make.bottom.equalTo(view);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [self.menuSelectionView setChooseMenuBlock:^(NSInteger index) {
        STRONG_SELF
        [alert hide];
        [self chooseMenuWithIndex:index];
    }];
}

- (void)chooseMenuWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1:{
            return;
        }
            break;
            
        default:
            break;
    }
}

- (void)naviRightAction {
    DDLogDebug(@"click to publish answer");
    [self.view endEditing:YES];
    [self publishAnswer];
}

- (void)publishAnswer {
    if (isEmpty(self.textView.text)) {
        [self showToast:@"内容不能为空"];
        return;
    }
    [QADataManager createAnswerWithAskID:self.questionID answer:self.textView.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        if (error) {
            [self showToast:error.localizedDescription];
            return ;
        }
        [self showToast:@"发布成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}

@end
