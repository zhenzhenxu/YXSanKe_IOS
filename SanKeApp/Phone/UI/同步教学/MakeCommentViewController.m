//
//  MakeCommentViewController.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MakeCommentViewController.h"
#import "ResourceDataManger.h"
#import "QATextView.h"
#import "MenuSelectionView.h"

@interface MakeCommentViewController ()

@property (nonatomic, strong) QATextView *textView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;

@end

@implementation MakeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self setupUI];
    [self setupObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[QATextView alloc] init];
    self.textView.layer.cornerRadius = 2.0f;
    self.textView.clipsToBounds = YES;
    self.textView.placeholder = @"写评论...";
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    }];
}

- (void)setupNavigationBar {
    self.title = @"写评论";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button sizeToFit];
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self cancelAction];
    }];
    [self setupLeftWithCustomView:button];
    [self setupRightWithTitle:@"发送"];
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
    [self.view endEditing:YES];
    if (![self.textView.text yx_isValidString]) {
        [self showToast:@"内容不可为空"];
        return;
    }
    if ([self stringContainsEmoji:self.textView.text]) {
        [self showToast:@"您输入的内容包含表情或特殊字符，暂不支持。"];
        return;
    }
    [self startLoading];
    WEAK_SELF
    [ResourceDataManger createResourceAskWithResourceID:self.resourceID content:self.textView.text resName:self.resName resAuthorId:self.resAuthorID completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self stopLoading];
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

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]
     subscribeNext:^(id x) {
         STRONG_SELF
         NSNotification *notification = (NSNotification *)x;
         CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
         NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
         [UIView animateWithDuration:duration.floatValue animations:^{
             [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.top.left.mas_equalTo(10.0f);
                 make.right.mas_equalTo(-10.0f);
                 make.bottom.mas_equalTo(keyboardFrame.origin.y - [UIScreen mainScreen].bounds.size.height - 10);
             }];
             [self.view layoutIfNeeded];
         }];
     }];
}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
