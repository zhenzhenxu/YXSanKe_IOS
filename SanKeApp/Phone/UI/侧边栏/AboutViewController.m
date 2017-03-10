//
//  AboutViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AboutViewController.h"
#import "PrivacyPolicyViewController.h"
#import "MenuSelectionView.h"
#import "AboutHeaderView.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AboutHeaderView *headerview;
@property (nonatomic, strong) UITableView *taleView;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, strong) UIButton *privacyButton;

@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.phoneString = @"010-8235169";
    [self setupUI];
    [self setupLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.headerview = [[AboutHeaderView alloc]init];
    
    self.taleView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.taleView.delegate = self;
    self.taleView.dataSource = self;
    self.taleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.taleView.layoutMargins = UIEdgeInsetsZero;
    self.taleView.scrollEnabled = NO;
    [self.taleView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.taleView];
    
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.privacyButton setTitle:@"隐私条例" forState:UIControlStateNormal];
    [self.privacyButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [self.privacyButton addTarget:self action:@selector(privacyButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupLayout {
    [self.view addSubview:self.headerview];
    [self.view addSubview:self.taleView];
    [self.view addSubview:self.privacyButton];
    
    
     [self.headerview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.equalTo(self.view);
    }];
    [self.taleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerview.mas_bottom).offset(78.0f);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.privacyButton.mas_top);
    }];
    
    [self.privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(28.0f);
        make.bottom.equalTo(self.view).offset(-12.0f);
    }];
}
#pragma mark - tableView dataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.text = @"客服邮箱  jiaoyan@ncct.gov.cn";;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        NSString *phoneString = [NSString stringWithFormat:@"客服电话  %@",self.phoneString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:phoneString];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, 4)];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"4691a6"]} range:NSMakeRange(6, 11)];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"334466"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.attributedText = attributeString;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self callActionWithPhoneNumber];
    }
}

- (void)callActionWithPhoneNumber{
    self.menuSelectionView = [[MenuSelectionView alloc]init];
    NSString * title = [NSString stringWithFormat:@"呼叫:  %@",self.phoneString];
    self.menuSelectionView.dataArray = @[
                                         title,
                                         @"取消"
                                         ];
    CGFloat height = [self.menuSelectionView totalHeight];
    [self.view addSubview:self.menuSelectionView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    alert.contentView = self.menuSelectionView;
    WEAK_SELF
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [self.menuSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.height.mas_equalTo(height);
            make.bottom.equalTo(view);
        }];
        [view layoutIfNeeded];
    }];
    [self.menuSelectionView setChooseMenuBlock:^(NSInteger index) {
        STRONG_SELF
        [alert hide];
        switch (index) {
            case 0:{
                NSString *telUrl = [NSString stringWithFormat:@"tel://%@",self.phoneString];
                if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]) {
                    [self showToast:@"此设备不支持通话！"];
                }
            }
                break;
            case 1:
            {
                [alert hide];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)privacyButtonAction {
    PrivacyPolicyViewController *vc = [[PrivacyPolicyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
