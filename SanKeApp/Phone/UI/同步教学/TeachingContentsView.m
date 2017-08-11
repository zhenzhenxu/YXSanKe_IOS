//
//  TeachingContentsView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingContentsView.h"
#import "TeachingContentsCell.h"

#define kContainerWidth (kScreenWidth - 50)

@interface TeachingContentsView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentsArray;

@end

@implementation TeachingContentsView

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.contentsArray = [NSMutableArray array];
    
    UIView *tableViewHeaderView = [[UIView alloc] init];
    UILabel *volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46, 40, 18)];
    volumeLabel.text = @"书册";
    volumeLabel.font = [UIFont systemFontOfSize:12.0f];
    volumeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [tableViewHeaderView addSubview:volumeLabel];
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(volumeLabel.frame) + 10, kContainerWidth, 1)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [tableViewHeaderView addSubview:topLineView];
    
    CGFloat lastButtonBottom = 0.0f;;
    for (int i = 0; i < self.data.volums.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        GetBookInfoRequestItem_Volum *volum = self.data.volums[i];
        btn.tag = 1000 + i;
        if (i == self.data.volumChooseInteger) {
            btn.selected = YES;
        }
        [btn setTitle:volum.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        btn.frame = CGRectMake(i % 2 == 0 ? 0 : kContainerWidth / 2.0f, CGRectGetMaxY(topLineView.frame) + i / 2 * 49, kContainerWidth / 2.0f, 49);
        [btn addTarget:self action:@selector(volumeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
        
        if (i % 2 == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + i / 2 * 49, kContainerWidth, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
            [tableViewHeaderView addSubview:lineView];
        }
        
        if (i == self.data.volums.count - 1) {
            lastButtonBottom = CGRectGetMaxY(btn.frame);
        }
    }
    
    UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, lastButtonBottom + 1 + 15, 40, 18)];
    contentsLabel.text = @"目录";
    contentsLabel.font = [UIFont systemFontOfSize:12.0f];
    contentsLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [tableViewHeaderView addSubview:contentsLabel];
    
    tableViewHeaderView.frame = CGRectMake(0, 0, kContainerWidth, CGRectGetMaxY(contentsLabel.frame) + 15);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kContainerWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = tableViewHeaderView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeachingContentsCell class] forCellReuseIdentifier:NSStringFromClass([TeachingContentsCell class])];
    [self addSubview:self.tableView];
}

- (void)volumeButtonAction:(UIButton *)sender {
    if (sender.tag - 1000 == self.data.volumChooseInteger) {
        return;
    }
    self.data.volumChooseInteger = sender.tag - 1000;
    self.data.unitChooseInteger = 0;
    self.data.courseChooseInteger = -1;
    self.pageChooseBlock(self.data);
}

- (void)setData:(TeachingContentsModel *)data {
    _data = data;
    [self setupUI];
    [self contentsArrayOnCurrentVolume:self.data.volums[self.data.volumChooseInteger]];
}

- (void)contentsArrayOnCurrentVolume:(GetBookInfoRequestItem_Volum *)currentVolume {
    [self.contentsArray removeAllObjects];
    for (GetBookInfoRequestItem_Unit *unit in currentVolume.units) {
        [self.contentsArray addObject:unit];
        for (GetBookInfoRequestItem_Course *course in unit.courses) {
            [self.contentsArray addObject:course];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeachingContentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeachingContentsCell class])];
    JSONModel *model = self.contentsArray[indexPath.row];
    cell.title = (NSString *)[model valueForKey:@"name"];
    cell.isIndented = [self.contentsArray[indexPath.row] isKindOfClass:[GetBookInfoRequestItem_Course class]];
    
    if (self.data.courseChooseInteger >= 0) {
        if ([model isEqual:self.data.courses[self.data.courseChooseInteger]]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
    } else {
        if ([model isEqual:self.data.units[self.data.unitChooseInteger]]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.contentsArray[indexPath.row] isKindOfClass:[GetBookInfoRequestItem_Unit class]]) {
        [self.data.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:self.contentsArray[indexPath.row]]) {
                self.data.unitChooseInteger = idx;
            }
        }];
        self.data.courseChooseInteger = -1;
    } else {
        [self.data.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.courses containsObject:self.contentsArray[indexPath.row]]) {
                self.data.unitChooseInteger = idx;
            }
        }];
        [self.data.courses enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Course * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:self.contentsArray[indexPath.row]]) {
                self.data.courseChooseInteger = idx;
            }
        }];
    }
    self.pageChooseBlock(self.data);
}

@end
