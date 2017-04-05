//
//  QAPublishQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAPublishQuestionViewController.h"
#import "QAInputAccessoryView.h"
#import "YXImagePickerController.h"
#import "QADeleteImageViewController.h"
#import "UIImage+YXImage.h"
#import "QATextView.h"
#import "ProjectMainViewController.h"

static CGFloat const kTextViewHeight = 130.0f;

@interface QAPublishQuestionViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) QATextView *textView;
@property (nonatomic, strong) QAInputAccessoryView *customView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@end

@implementation QAPublishQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightWithTitle:@"发布"];
    [self setupUI];
    [self setupLayout];
    [self setupObservers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    DDLogDebug(@"click to publish question");
    [self.view endEditing:YES];
    [self publishQuestion];
}

- (void)setupUI {
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.clipsToBounds = YES;
    UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapAction:)];
    [self.contentView addGestureRecognizer:clickTap];
    
    self.textView = [[QATextView alloc]init];
    self.textView.placeholedr = @"请输入您的内容描述…（选填)";
    QAInputAccessoryView *customView = [[QAInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];
    customView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    WEAK_SELF
    [customView setHideBlock:^{
        STRONG_SELF
        DDLogDebug(@"click hideButton");
        [self.view endEditing:YES];
    }];
    [customView setCameraBlock:^{
        STRONG_SELF
        DDLogDebug(@"click cameraButton");
        [self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [customView setAlbumBlock:^{
        STRONG_SELF
        DDLogDebug(@"click albumButton");
        [self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    self.textView.inputAccessoryView = customView;
    self.customView = customView;
    
    self.imagePickerController = [[YXImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = NO;
}

- (void)setupLayout {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    
    [self.view addSubview:self.textView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)type {
    WEAK_SELF
    [self.imagePickerController presentFromViewController:self pickImageWithSourceType:type completion:^(UIImage *selectedImage) {
        STRONG_SELF
        if (!selectedImage) {
            return;
        }
        self.imageView.image = selectedImage;
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.top.equalTo(self.textView.mas_bottom).offset(14.0f);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kTextViewHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)clickTapAction:(UITapGestureRecognizer *)recognizer {
    [self.textView becomeFirstResponder];
}

- (void)selectedImage:(UITapGestureRecognizer *) recognizer {
    if (!self.imageView.image && !self.imageView ) {
        return;
    }
    QADeleteImageViewController *vc = [[QADeleteImageViewController alloc]init];
    vc.image = self.imageView.image;
    [vc setDeleteBlock:^{
        self.imageView.image = nil;
        [self.imageView removeFromSuperview];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.view layoutIfNeeded];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedImage:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.imageView.image) {
            return;
        }
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

#pragma mark - publishQuestion
- (void)publishQuestion {
    [QADataManager createAskWithTitle:self.questionTitle content:self.textView.text attachmentID:nil completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        if (error) {
            [self showToast:error.localizedDescription];
            return ;
        }
        [self showToast:@"发布问题成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
