//
//  YXShowWebMenuView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXShowWebMenuView.h"
#import "YXShowWebMenuTableViewCell.h"

@interface YXShowWebMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *topTriangleImageView;

@end

@implementation YXShowWebMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    [self setTriangleFrame];
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderGesture:)];
    [self.maskView addGestureRecognizer:tapGesture];
    [self addSubview:self.maskView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(66);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(135);
        make.width.mas_equalTo(149);
    }];
    [self.tableView registerClass:[YXShowWebMenuTableViewCell class] forCellReuseIdentifier:@"YXShowWebMenuTableViewCell"];
}

- (void)tapHeaderGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXShowWebMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXShowWebMenuTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell configCellWithTitle:@"刷新" imageString:@"刷新icon" highLightImage:@"刷新icon点击态" isLastOne:NO];
    }
    if (indexPath.row == 1) {
        [cell configCellWithTitle:@"在浏览器中打开" imageString:@"浏览器icon" highLightImage:@"浏览器icon-点击态" isLastOne:NO];
    }
    if (indexPath.row == 2) {
        [cell configCellWithTitle:@"复制链接" imageString:@"链接-0" highLightImage:@"链接点击态" isLastOne:YES];
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeFromSuperview];
    if (self.didSeletedItem) {
        self.didSeletedItem(indexPath.row);
    }
}

- (UIImageView *)topTriangleImageView {
    if (!_topTriangleImageView) {
        _topTriangleImageView = [UIImageView new];
        _topTriangleImageView.image = [UIImage imageNamed:@"切换项目名称的弹窗-尖角"];
        [self addSubview:_topTriangleImageView];
    }
    return _topTriangleImageView;
}

- (void)setTriangleFrame {
    self.topTriangleImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 58, 18, 8);
}


@end
