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

@interface TeachingContentsView ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *headerScrollView;
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
    
    self.headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLineView.frame), kContainerWidth, 49)];
    self.headerScrollView.showsHorizontalScrollIndicator = NO;
    self.headerScrollView.showsVerticalScrollIndicator = NO;
    self.headerScrollView.delegate = self;
    self.headerScrollView.contentSize = CGSizeMake(kContainerWidth / 2.0f * self.data.volums.count, 49);
    [tableViewHeaderView addSubview:self.headerScrollView];
    for (int i = 0; i < self.data.volums.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        GetBookInfoRequestItem_Volum *volum = self.data.volums[i];
        btn.tag = 1000 + i;
        if (i == self.data.volumChooseInteger) {
            btn.selected = YES;
            self.headerScrollView.contentOffset = CGPointMake(i == self.data.volums.count - 1 ? self.headerScrollView.contentSize.width - kContainerWidth : kContainerWidth / 2.0f * i, 0);
        }
        [btn setTitle:volum.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        btn.frame = CGRectMake(kContainerWidth / 2.0f * i, 0, kContainerWidth / 2.0f, 49);
        [btn addTarget:self action:@selector(volumeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerScrollView addSubview:btn];
    }
    
    if (self.data.volums.count > 2) {
        UIButton *leftScrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftScrollBtn.frame = CGRectMake(0, CGRectGetMaxY(topLineView.frame), 34, 49);
        [leftScrollBtn setImage:[UIImage imageNamed:@"书册滑动左"] forState:UIControlStateNormal];
        [leftScrollBtn addTarget:self action:@selector(scrollBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        leftScrollBtn.tag = 2000;
        [tableViewHeaderView addSubview:leftScrollBtn];
        
        UIButton *rightScrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightScrollBtn.frame = CGRectMake(kContainerWidth - 34, CGRectGetMaxY(topLineView.frame), 34, 49);
        [rightScrollBtn setImage:[UIImage imageNamed:@"书册滑动"] forState:UIControlStateNormal];
        [rightScrollBtn addTarget:self action:@selector(scrollBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:rightScrollBtn];
    }
    
    UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerScrollView.frame), kContainerWidth, 1)];
    middleLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [tableViewHeaderView addSubview:middleLineView];
    UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(middleLineView.frame) + 15, 40, 18)];
    contentsLabel.text = @"目录";
    contentsLabel.font = [UIFont systemFontOfSize:12.0f];
    contentsLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [tableViewHeaderView addSubview:contentsLabel];
    
    tableViewHeaderView.frame = CGRectMake(0, 0, kContainerWidth, CGRectGetMaxY(contentsLabel.frame) + 15);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kContainerWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = tableViewHeaderView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeachingContentsCell class] forCellReuseIdentifier:NSStringFromClass([TeachingContentsCell class])];
    [self addSubview:self.tableView];
}

- (void)scrollBtnAction:(UIButton *)sender {
    if (sender.tag == 2000) {
        if (self.headerScrollView.contentOffset.x > kContainerWidth / 2.0f) {
            self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x - kContainerWidth / 2.0f, 0);
        } else if (self.headerScrollView.contentOffset.x > 0) {
            self.headerScrollView.contentOffset = CGPointMake(0, 0);
        }
    } else {
        if (self.headerScrollView.contentOffset.x < self.headerScrollView.contentSize.width - kContainerWidth - kContainerWidth / 2.0f) {
            self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x + kContainerWidth / 2.0f, 0);
        } else if (self.headerScrollView.contentOffset.x < self.headerScrollView.contentSize.width - kContainerWidth) {
            self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentSize.width - kContainerWidth, 0);
        }
    }
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
    
    [self.contentsArray enumerateObjectsUsingBlock:^(JSONModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.data.courseChooseInteger >= 0) {
            if ([obj isEqual:self.data.courses[self.data.courseChooseInteger]]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
        } else {
            if ([obj isEqual:self.data.units[self.data.unitChooseInteger]]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.headerScrollView]) {
        scrollView.contentOffset = CGPointMake(round(scrollView.contentOffset.x / (kContainerWidth / 2.0f)) * (kContainerWidth / 2.0f), 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:self.headerScrollView]) {
        scrollView.contentOffset = CGPointMake(round(scrollView.contentOffset.x / (kContainerWidth / 2.0f)) * (kContainerWidth / 2.0f), 0);
    }
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
    
    if ([self.contentsArray[indexPath.row] isKindOfClass:[GetBookInfoRequestItem_Unit class]]) {
        cell.isSelected = [model isEqual:self.data.units[self.data.unitChooseInteger]];
    } else {
        if (self.data.courseChooseInteger >= 0) {
            cell.isSelected = [model isEqual:self.data.courses[self.data.courseChooseInteger]];
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
