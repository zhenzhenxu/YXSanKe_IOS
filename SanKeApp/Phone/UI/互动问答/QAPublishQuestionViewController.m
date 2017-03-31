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

static CGFloat const kTextViewHeight = 150.0f;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    DDLogDebug(@"click to publish question");
    [self.view endEditing:YES];
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
    self.textView.backgroundColor = [UIColor redColor];
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
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.backgroundColor = [UIColor yellowColor];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedImage:)];
    [self.imageView addGestureRecognizer:tap];
    
    self.imagePickerController = [[YXImagePickerController alloc] init];
}

- (void)setupLayout {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.imageView];
    
    [self.view addSubview:self.textView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kTextViewHeight);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.textView.mas_bottom).offset(14.0f);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)type {
    WEAK_SELF
    [self.imagePickerController pickImageWithSourceType:type completion:^(UIImage *selectedImage) {
        STRONG_SELF
        self.imageView.image = selectedImage;
    }];
}

- (void)clickTapAction:(UITapGestureRecognizer *)recognizer {
    [self.textView becomeFirstResponder];
}

- (void)selectedImage:(UITapGestureRecognizer *) recognizer {
    if (!self.imageView.image ) {
        return;
    }
    QADeleteImageViewController *vc = [[QADeleteImageViewController alloc]init];
    vc.image = self.imageView.image;
    [vc setDeleteBlock:^{
        self.imageView.image = nil;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
