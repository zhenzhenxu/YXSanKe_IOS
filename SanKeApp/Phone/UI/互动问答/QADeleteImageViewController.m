//
//  QADeleteImageViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QADeleteImageViewController.h"
#import "UIImage+YXImage.h"

@interface QADeleteImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) DeleteBlock deleteButtonBlock;
@end

@implementation QADeleteImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - setupNavView
- (void)setupNavView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button sizeToFit];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self deletelAction];
    }];
    [self setupRightWithCustomView:button];
}

- (void)deletelAction {
    DDLogDebug(@"click to delete image");
    self.imageView.image = nil;
    [self.navigationController popViewControllerAnimated:YES];
    BLOCK_EXEC(self.deleteButtonBlock);
}

#pragma mark - setupUI
- (void)setupUI {
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    [self.imageView sizeToFit];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - setDeleteBlock
- (void)setDeleteBlock:(DeleteBlock)block {
    self.deleteButtonBlock = block;
}
@end
