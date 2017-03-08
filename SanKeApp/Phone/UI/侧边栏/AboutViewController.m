//
//  AboutViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AboutViewController.h"
#import "PrivacyPolicyViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *mailLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UIButton *privacyButton;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    [self setupUI];
    [self setupLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    
    self.signImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"i教研"]];
    
    self.versionLabel = [[UILabel alloc]init];
    self.versionLabel.font = [UIFont systemFontOfSize:16.0f];
    self.versionLabel.textColor = [UIColor colorWithHexString:@"c6c9cc"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    self.mailLabel = [[UILabel alloc]init];
    self.mailLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.mailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.mailLabel.text = @"客服邮箱  jiaoyan@ncct.gov.cn";
    self.mailLabel.textAlignment = NSTextAlignmentCenter;
    
    self.telephoneLabel = [[UILabel alloc]init];
    NSString *phoneString = @"客服电话  010-8235169";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:phoneString];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, 4)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"4691a6"]} range:NSMakeRange(6, 11)];
    self.telephoneLabel.attributedText = attributeString;
    self.telephoneLabel.textAlignment = NSTextAlignmentCenter;
    
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.privacyButton setTitle:@"隐私条例" forState:UIControlStateNormal];
    [self.privacyButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [self.privacyButton addTarget:self action:@selector(privacyButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupLayout {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.signImageView];
    [self.contentView addSubview:self.versionLabel];
    [self.contentView addSubview:self.mailLabel];
    [self.contentView addSubview:self.telephoneLabel];
    [self.contentView addSubview:self.privacyButton];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10.0f);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(69.0f);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(78, 78));
    }];
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(25.0f);
        make.centerX.equalTo(self.logoImageView);
        make.size.mas_equalTo(CGSizeMake(55, 23));
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signImageView.mas_bottom).offset(10.0f);
        make.centerX.equalTo(self.signImageView);
    }];
    [self.mailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.mas_bottom).offset(82.0f);
        make.centerX.equalTo(self.versionLabel);
    }];
    [self.telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mailLabel.mas_bottom).offset(28.0f);
        make.centerX.equalTo(self.mailLabel);
    }];
    
    [self.privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.telephoneLabel);
        make.bottom.equalTo(self.contentView).offset(-12.0f);
    }];
}

- (void)privacyButtonAction {
    PrivacyPolicyViewController *vc = [[PrivacyPolicyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
