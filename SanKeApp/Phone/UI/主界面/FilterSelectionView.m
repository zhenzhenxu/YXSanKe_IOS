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
#import "StageSubjectModel.h"

static const NSInteger kNotSelectedTag = -1;

@interface FilterSelectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger firstLevelSelectedIndex;
@property (nonatomic, assign) NSInteger secondLevelSelectedIndex;
@property (nonatomic, assign) NSInteger thirdLevelSelectedIndex;
@property (nonatomic, strong) StageSubjectModel *model;
@end

@implementation FilterSelectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.firstLevelSelectedIndex = kNotSelectedTag;
        self.secondLevelSelectedIndex = kNotSelectedTag;
        self.thirdLevelSelectedIndex = kNotSelectedTag;
        [self setupMockData];
        [self setupUI];
    }
    return self;
}

- (void)setupMockData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"edition_filter" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.model = [[StageSubjectModel alloc]initWithData:data error:nil];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(self.width, 25);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 10, 14, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self.collectionView registerClass:[FilterCell class] forCellWithReuseIdentifier:@"FilterCell"];
    [self.collectionView registerClass:[FilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 35, 0));
    }];
    
    UIButton *resetButton = [[UIButton alloc]init];
    [resetButton setBackgroundImage:[UIImage yx_imageWithColor:[[UIColor colorWithHexString:@"d65b4b"] colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor colorWithHexString:@"d65b4b"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [[UIButton alloc]init];
    [doneButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"d65b4b"]] forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:resetButton];
    [self addSubview:doneButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionView.mas_left);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(resetButton.mas_right);
        make.top.mas_equalTo(resetButton.mas_top);
        make.right.mas_equalTo(self.collectionView.mas_right);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(resetButton.mas_width);
    }];
}

#pragma mark -  Button Actions
- (void)resetAction {
    self.firstLevelSelectedIndex = kNotSelectedTag;
    self.secondLevelSelectedIndex = kNotSelectedTag;
    self.thirdLevelSelectedIndex = kNotSelectedTag;
    [self.collectionView reloadData];
}

- (void)doneAction {
    if (self.firstLevelSelectedIndex == kNotSelectedTag) {
        DDLogError(@"您尚未进行任何选择");
        return;
    }
    StageSubjectItem *first = self.model.items[self.firstLevelSelectedIndex];
    StageSubjectItem *second = nil;
    StageSubjectItem *third = nil;
    if (self.secondLevelSelectedIndex != kNotSelectedTag) {
        second = first.items[self.secondLevelSelectedIndex];
        if (self.thirdLevelSelectedIndex != kNotSelectedTag) {
            third = second.items[self.thirdLevelSelectedIndex];
        }
    }
    DDLogInfo(@"选择结果为 版本: %@， 年级: %@， 学科: %@", first.name, second.name, third.name);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.firstLevelSelectedIndex == kNotSelectedTag) {
        return 1;
    }
    StageSubjectItem *first = self.model.items[self.firstLevelSelectedIndex];
    if (self.secondLevelSelectedIndex == kNotSelectedTag) {
        if (first.items.count > 0) {
            return 2;
        }
        return 1;
    }
    StageSubjectItem *second = first.items[self.secondLevelSelectedIndex];
    if (second.items.count > 0) {
        return 3;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.items.count;
    }
    StageSubjectItem *firstItem = self.model.items[self.firstLevelSelectedIndex];
    if (section == 1) {
        return firstItem.items.count;
    }
    StageSubjectItem *secondItem = firstItem.items[self.secondLevelSelectedIndex];
    return secondItem.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    StageSubjectItem *item = [self itemForIndexPath:indexPath];
    cell.title = item.name;
    if (indexPath.section == 0) {
        cell.isCurrent = indexPath.row==self.firstLevelSelectedIndex;
    }else if (indexPath.section == 1){
        cell.isCurrent = indexPath.row==self.secondLevelSelectedIndex;
    }else {
        cell.isCurrent = indexPath.row==self.thirdLevelSelectedIndex;
    }
    WEAK_SELF
    [cell setActionBlock:^{
        STRONG_SELF
        if (indexPath.section == 0) {
            self.firstLevelSelectedIndex = indexPath.row;
            self.secondLevelSelectedIndex = kNotSelectedTag;
            self.thirdLevelSelectedIndex = kNotSelectedTag;
            [self.collectionView reloadData];
        }else {
            if (indexPath.section == 1) {
                self.secondLevelSelectedIndex = indexPath.row;
                self.thirdLevelSelectedIndex = kNotSelectedTag;
                [self.collectionView reloadData];
            }else {
                self.thirdLevelSelectedIndex = indexPath.row;
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
            headerView.title = @"版本";
        }else if (indexPath.section == 1){
            headerView.seperatorHidden = NO;
            headerView.title = @"年级";
        }else {
            headerView.seperatorHidden = NO;
            headerView.title = @"单元";
        }
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    StageSubjectItem *item = [self itemForIndexPath:indexPath];
    return [FilterCell sizeForTitle:item.name];
}

- (StageSubjectItem *)itemForIndexPath:(NSIndexPath *)indexPath {
    StageSubjectItem *item = nil;
    if (indexPath.section == 0) {
        item = self.model.items[indexPath.row];
    }else {
        StageSubjectItem *firstItem = self.model.items[self.firstLevelSelectedIndex];
        if (indexPath.section == 1) {
            item = firstItem.items[indexPath.row];
        }else {
            StageSubjectItem *secondItem = firstItem.items[self.secondLevelSelectedIndex];
            item = secondItem.items[indexPath.row];
        }
    }
    return item;
}

@end
