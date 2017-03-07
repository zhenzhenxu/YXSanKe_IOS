//
//  SupplementInfoViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SupplementInfoViewController.h"
#import "StageSubjectCell.h"
#import "StageSubjectHeaderView.h"
#import "SupplementUserInfoViewController.h"

static const NSInteger kNotSelectedTag = -1;

@interface SupplementInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger stageSelectedIndex;
@property (nonatomic, assign) NSInteger subjectSelectedIndex;
@property (nonatomic, strong) FetchStageSubjectRequestItem *item;

@end

@implementation SupplementInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人资料";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.stageSelectedIndex = kNotSelectedTag;
    self.subjectSelectedIndex = kNotSelectedTag;
    self.item = [StageSubjectDataManager dataForStageAndSubject];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 28);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 14, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[StageSubjectCell class] forCellWithReuseIdentifier:@"StageSubjectCell"];
    [self.collectionView registerClass:[StageSubjectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StageSubjectHeaderView"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark -  Button Actions
- (void)resetAction {
    self.stageSelectedIndex = kNotSelectedTag;
    self.subjectSelectedIndex = kNotSelectedTag;
    [self.collectionView reloadData];
}

- (void)doneAction {
    if (self.stageSelectedIndex == kNotSelectedTag || self.subjectSelectedIndex == kNotSelectedTag) {
        [self showToast:@"请选择学段和学科"];
        return;
    }
    FetchStageSubjectRequestItem_stage *stage = self.item.data.stages[self.stageSelectedIndex];
    FetchStageSubjectRequestItem_subject *subject = stage.subjects[self.subjectSelectedIndex];
    YXProblemItem *item = [YXProblemItem new];
    item.subject = stage.stageID;
    item.grade = subject.subjectID;
    item.type = YXRecordGradeType;
    [YXRecordManager addRecord:item];
    WEAK_SELF
    [MineDataManager updateStage:stage.stageID subject:subject.subjectID completeBlock:^(NSError *error) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.stageSelectedIndex == kNotSelectedTag) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.item.data.stages.count;
    }
    FetchStageSubjectRequestItem_stage *stage = self.item.data.stages[self.stageSelectedIndex];
    return stage.subjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StageSubjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StageSubjectCell" forIndexPath:indexPath];
    
    NSString *name = [self itemNameForIndexPath:indexPath];
    cell.title = name;
    if (indexPath.section == 0) {
        cell.isCurrent = indexPath.row==self.stageSelectedIndex;
    }else {
        cell.isCurrent = indexPath.row==self.subjectSelectedIndex;
    }
    WEAK_SELF
    [cell setActionBlock:^{
        STRONG_SELF
        if (indexPath.section == 0) {
            self.stageSelectedIndex = indexPath.row;
            self.subjectSelectedIndex = kNotSelectedTag;
            [self.collectionView reloadData];
        }else {
            self.subjectSelectedIndex = indexPath.row;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            [CATransaction commit];
            [self jumpToSupplementUserInfo];
        }
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        StageSubjectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StageSubjectHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.seperatorHidden = YES;
            headerView.title = self.item.category.name;
        }else {
            headerView.seperatorHidden = NO;
            headerView.title = self.item.category.subCategory.name;
        }
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [self itemNameForIndexPath:indexPath];
    return [StageSubjectCell sizeForTitle:name];
}

- (NSString *)itemNameForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FetchStageSubjectRequestItem_stage *stage = self.item.data.stages[indexPath.row];
        return stage.name;
    }else {
        FetchStageSubjectRequestItem_stage *stage = self.item.data.stages[self.stageSelectedIndex];
        FetchStageSubjectRequestItem_subject *subject = stage.subjects[indexPath.row];
        return subject.name;
    }
}

- (void)jumpToSupplementUserInfo {
    FetchStageSubjectRequestItem_stage *stage = self.item.data.stages[self.stageSelectedIndex];
    FetchStageSubjectRequestItem_subject *subject = stage.subjects[self.subjectSelectedIndex];
    SupplementUserInfoViewController *vc = [[SupplementUserInfoViewController alloc]init];
    vc.stageID = stage.stageID;
    vc.subjectID = subject.subjectID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
