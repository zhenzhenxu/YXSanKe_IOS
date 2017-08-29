//
//  FilterSelectionView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FilterSelectionView.h"
#import "FilterHeaderView.h"
#import "FilterCell.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"

static const NSInteger kNotSelectedTag = -1;

@implementation FilterSelectedItem
@end

@interface FilterSelectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger firstLevelSelectedIndex;
@property (nonatomic, assign) NSInteger secondLevelSelectedIndex;
@property (nonatomic, assign) NSInteger thirdLevelSelectedIndex;
@property (nonatomic, assign) NSInteger forthLevelSelectedIndex;
@property (nonatomic, assign) NSInteger tFirstLevelSelectedIndex;
@property (nonatomic, assign) NSInteger tSecondLevelSelectedIndex;
@property (nonatomic, assign) NSInteger tThirdLevelSelectedIndex;
@property (nonatomic, assign) NSInteger tForthLevelSelectedIndex;
@property (nonatomic, assign) BOOL needReset;
@end

@implementation FilterSelectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.firstLevelSelectedIndex = 0;
        self.secondLevelSelectedIndex = 0;
        self.thirdLevelSelectedIndex = kNotSelectedTag;
        self.forthLevelSelectedIndex = kNotSelectedTag;
        [self setupUI];
        self.needReset = NO;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(self.width, 28);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 14, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[FilterCell class] forCellWithReuseIdentifier:@"FilterCell"];
    [self.collectionView registerClass:[FilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 0, 68, 0));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *resetButton = [[UIButton alloc]init];
    resetButton.layer.cornerRadius = 2;
    resetButton.clipsToBounds = YES;
    resetButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [resetButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f3f3"]] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [[resetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.needReset = YES;
        [self resetAction];
    }];
    
    UIButton *doneButton = [[UIButton alloc]init];
    doneButton.layer.cornerRadius = 2;
    doneButton.clipsToBounds = YES;
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [doneButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"4691a6"]] forState:UIControlStateNormal];
    [doneButton setTitle:@"确认" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:resetButton];
    [self addSubview:doneButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(-67.5f);
        make.centerY.mas_equalTo(lineView.mas_bottom).offset(34.5f);
        make.size.mas_equalTo(CGSizeMake(75, 29));
    }];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(67.5f);
        make.centerY.mas_equalTo(lineView.mas_bottom).offset(34.5f);
        make.size.mas_equalTo(CGSizeMake(75, 29));
    }];
}

- (void)setHasCourseFilter:(BOOL)hasCourseFilter {
    _hasCourseFilter = hasCourseFilter;
    self.secondLevelSelectedIndex = hasCourseFilter ? kNotSelectedTag : 0;
}

#pragma mark -  Button Actions
- (void)resetAction {
    
    self.tFirstLevelSelectedIndex = self.firstLevelSelectedIndex;
    self.tSecondLevelSelectedIndex = self.secondLevelSelectedIndex;
    self.tThirdLevelSelectedIndex = self.thirdLevelSelectedIndex;
    self.tForthLevelSelectedIndex = self.forthLevelSelectedIndex;
    
    self.firstLevelSelectedIndex = 0;
    self.secondLevelSelectedIndex = self.hasCourseFilter ? kNotSelectedTag : 0;
    self.thirdLevelSelectedIndex = kNotSelectedTag;
    self.forthLevelSelectedIndex = kNotSelectedTag;
    
    [self.collectionView reloadData];
}

- (void)cancelReset{
    self.firstLevelSelectedIndex = self.tFirstLevelSelectedIndex;
    self.secondLevelSelectedIndex = self.tSecondLevelSelectedIndex;
    self.tThirdLevelSelectedIndex = self.thirdLevelSelectedIndex;
    self.forthLevelSelectedIndex = self.tForthLevelSelectedIndex;
}

- (void)doneAction {
    ChannelTabFilterRequestItem_filter *first;
    if (self.firstLevelSelectedIndex == kNotSelectedTag) {
        first = nil;
    }else{
        first = self.data.filters[self.firstLevelSelectedIndex];
    }
    ChannelTabFilterRequestItem_filter *second = nil;
    ChannelTabFilterRequestItem_filter *third = nil;
    ChannelTabFilterRequestItem_filter *forth = nil;
    if (self.secondLevelSelectedIndex != kNotSelectedTag) {
        if (first.subFilters.count > 0) {
            second = first.subFilters[self.secondLevelSelectedIndex];
            if (self.thirdLevelSelectedIndex != kNotSelectedTag) {
                if (second.subFilters.count > 0) {
                    third = second.subFilters[self.thirdLevelSelectedIndex];
                    if (self.forthLevelSelectedIndex != kNotSelectedTag) {
                        if (third.subFilters.count > 0) {
                            forth = third.subFilters[self.forthLevelSelectedIndex];
                        }
                    }
                }
            }
        }
    }
    
    FilterSelectedItem *selectedItem = [[FilterSelectedItem alloc] init];
    selectedItem.volume = first;
    selectedItem.unit = second;
    selectedItem.course = third;
    
    BLOCK_EXEC(self.completeBlock, selectedItem);
    
    YXProblemItem *recordItem = [[YXProblemItem alloc]init];
    recordItem.edition_id = @"720175";
    recordItem.volume_id = first.filterID ? first.filterID : [NSString string];
    recordItem.unit_id = second.filterID ? second.filterID : [NSString string];
    recordItem.course_id = third.filterID ? third.filterID : [NSString string];
    recordItem.grade = [UserManager sharedInstance].userModel.stageID;
    recordItem.subject = [UserManager sharedInstance].userModel.subjectID;
    recordItem.section_id = self.sectionId;
    recordItem.objType = @"filter";
    recordItem.type = YXRecordClickType;
    [YXRecordManager addRecord:recordItem];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.firstLevelSelectedIndex == kNotSelectedTag) {
        return 1;
    }
    ChannelTabFilterRequestItem_filter *first = self.data.filters[self.firstLevelSelectedIndex];
    if (self.secondLevelSelectedIndex == kNotSelectedTag) {
        if (first.subFilters.count > 0) {
            return 2;
        }
        return 1;
    }
    if (first.subFilters.count < 1) {
        return 1;
    }
    ChannelTabFilterRequestItem_filter *second = first.subFilters[self.secondLevelSelectedIndex];
    if (self.thirdLevelSelectedIndex == kNotSelectedTag) {
        if (second.subFilters.count > 0) {
            return 3;
        }
        return 2;
    }
    if (second.subFilters.count < 1) {
        return 2;
    }
    ChannelTabFilterRequestItem_filter *third = second.subFilters[self.thirdLevelSelectedIndex];
    if (third.subFilters.count > 0) {
        return 4;
    }
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.data.filters.count;
    }
    ChannelTabFilterRequestItem_filter *firstItem = self.data.filters[self.firstLevelSelectedIndex];
    if (section == 1) {
        return firstItem.subFilters.count;
    }
    ChannelTabFilterRequestItem_filter *secondItem = firstItem.subFilters[self.secondLevelSelectedIndex];
    if (section == 2) {
        return secondItem.subFilters.count;
    }
    ChannelTabFilterRequestItem_filter *thirdItem = secondItem.subFilters[self.thirdLevelSelectedIndex];
    return thirdItem.subFilters.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    ChannelTabFilterRequestItem_filter *item = [self itemForIndexPath:indexPath];
    cell.title = item.name;
    if (indexPath.section == 0) {
        cell.isCurrent = indexPath.row==self.firstLevelSelectedIndex;
    }else if (indexPath.section == 1){
        cell.isCurrent = indexPath.row==self.secondLevelSelectedIndex;
    }else if (indexPath.section == 2){
        cell.isCurrent = indexPath.row==self.thirdLevelSelectedIndex;
    }else {
        cell.isCurrent = indexPath.row==self.forthLevelSelectedIndex;
    }
    WEAK_SELF
    [cell setActionBlock:^{
        STRONG_SELF
        if (indexPath.section == 0) {
            self.firstLevelSelectedIndex = indexPath.row;
            self.secondLevelSelectedIndex = self.hasCourseFilter ? kNotSelectedTag : 0;
            self.thirdLevelSelectedIndex = kNotSelectedTag;
            [self.collectionView reloadData];
        }else {
            if (indexPath.section == 1) {
                self.secondLevelSelectedIndex = indexPath.row;
                self.thirdLevelSelectedIndex = kNotSelectedTag;
                [self.collectionView reloadData];
            }else if (indexPath.section == 2){
                self.thirdLevelSelectedIndex = indexPath.row;
                self.forthLevelSelectedIndex = kNotSelectedTag;
                [self.collectionView reloadData];
            }else {
                self.forthLevelSelectedIndex = indexPath.row;
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                [CATransaction commit];
            }
        }
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        FilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.seperatorHidden = YES;
            headerView.title = self.data.category.subCategory.name;
        }else if (indexPath.section == 1){
            headerView.seperatorHidden = NO;
            headerView.title = self.data.category.subCategory.subCategory.name;
        }else if (indexPath.section == 2){
            headerView.seperatorHidden = NO;
            headerView.title = self.data.category.subCategory.subCategory.subCategory.name;
        }else {
            headerView.seperatorHidden = NO;
            headerView.title = self.data.category.subCategory.subCategory.subCategory.subCategory.name;
        }
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChannelTabFilterRequestItem_filter *item = [self itemForIndexPath:indexPath];
    return [FilterCell sizeForTitle:item.name collectionViewWidth:self.collectionView.width];
}

- (ChannelTabFilterRequestItem_filter *)itemForIndexPath:(NSIndexPath *)indexPath {
    ChannelTabFilterRequestItem_filter *item = nil;
    if (indexPath.section == 0) {
        item = self.data.filters[indexPath.row];
    }else {
        ChannelTabFilterRequestItem_filter *firstItem = self.data.filters[self.firstLevelSelectedIndex];
        if (indexPath.section == 1) {
            item = firstItem.subFilters[indexPath.row];
        }else{
            ChannelTabFilterRequestItem_filter *secondItem = firstItem.subFilters[self.secondLevelSelectedIndex];
            if (indexPath.section == 2){
                item = secondItem.subFilters[indexPath.row];
            }else {
                ChannelTabFilterRequestItem_filter *thirdItem = secondItem.subFilters[self.thirdLevelSelectedIndex];
                item = thirdItem.subFilters[indexPath.row];
            }
        }
    }
    return item;
}

@end
