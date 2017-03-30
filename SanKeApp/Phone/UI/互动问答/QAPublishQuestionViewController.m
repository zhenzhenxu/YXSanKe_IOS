//
//  QAPublishQuestionViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAPublishQuestionViewController.h"
#import "QAInputeTextView.h"
#import "QAInputAccessoryView.h"
#import "YXImagePickerController.h"

static CGFloat const kTextViewHeight = 150.0f;

@interface QAPublishQuestionViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) QAInputeTextView *textView;
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
    DDLogDebug(@"点击发布问题");
    [self.view endEditing:YES];
    
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.clipsToBounds = YES;
    
    self.textView = [[QAInputeTextView alloc]initWithPlaceholder:@"请输入您的内容描述…（选填)"];
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
    
    self.imagePickerController = [[YXImagePickerController alloc] init];
}

- (void)setupLayout {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.imageView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height);
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
@end
