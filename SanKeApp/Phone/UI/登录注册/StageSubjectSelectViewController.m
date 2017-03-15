//
//  StageSubjectSelectViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectSelectViewController.h"
#import "LoginViewController.h"
#import "StageSubjectCell.h"
#import "StageSubjectHeaderView.h"
#import "YXProblemItem.h"
#import "YXRecordManager.h"

static const NSInteger kNotSelectedTag = -1;

@interface StageSubjectSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger stageSelectedIndex;
@property (nonatomic, assign) NSInteger subjectSelectedIndex;
@property (nonatomic, strong) FetchStageSubjectRequestItem *item;
@end

@implementation StageSubjectSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"i教研";
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count == 1) {
        [self setupRightWithImageNamed:@"登陆" highlightImageNamed:@"登陆"];
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.stageSelectedIndex = kNotSelectedTag;
    self.subjectSelectedIndex = kNotSelectedTag;
    self.item = [StageSubjectDataManager dataForStageAndSubject];
    [self setupUI];
    if (![UserManager sharedInstance].userModel.isSankeUser && ![UserManager sharedInstance].userModel.isAnonymous) {
        [self showToast:@"您所在的学科频道正在搭建中!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    if ([UserManager sharedInstance].userModel.isAnonymous) {
        [UserManager sharedInstance].loginStatus = NO;
    }else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)naviLeftAction {
    if ([UserManager sharedInstance].userModel.isAnonymous) {
         [UserManager sharedInstance].loginStatus = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 35, 10));
    }];
    
    UIButton *resetButton = [[UIButton alloc]init];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [resetButton setBackgroundImage:[UIImage yx_imageWithColor:[[UIColor colorWithHexString:@"d65b4b"] colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    
    [resetButton setTitleColor:[UIColor colorWithHexString:@"d65b4b"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [[UIButton alloc]init];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [doneButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"d65b4b"]] forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resetButton];
    [self.view addSubview:doneButton];
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
    item.subject = subject.subjectID;
    item.grade = stage.stageID;
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

@end
