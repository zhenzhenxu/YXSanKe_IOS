//
//  StageSubjectSelectViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectSelectViewController.h"
#import "StageSubjectCell.h"
#import "StageSubjectHeaderView.h"
#import "StageSubjectModel.h"

static const NSInteger kNotSelectedTag = -1;

@interface StageSubjectSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger stageSelectedIndex;
@property (nonatomic, assign) NSInteger subjectSelectedIndex;
@property (nonatomic, strong) StageSubjectModel *model;
@end

@implementation StageSubjectSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.stageSelectedIndex = kNotSelectedTag;
    self.subjectSelectedIndex = kNotSelectedTag;
    [self setupMockData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMockData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"stage_subject" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.model = [[StageSubjectModel alloc]initWithData:data error:nil];
}

- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 25);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 10, 14, 10);
    
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
    [resetButton setBackgroundImage:[UIImage yx_imageWithColor:[[UIColor colorWithHexString:@"d65b4b"] colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor colorWithHexString:@"d65b4b"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [[UIButton alloc]init];
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
    if (self.stageSelectedIndex == kNotSelectedTag) {
        DDLogError(@"您尚未进行任何选择");
        return;
    }
    StageSubjectItem *stage = self.model.items[self.stageSelectedIndex];
    StageSubjectItem *subject = nil;
    if (self.subjectSelectedIndex != kNotSelectedTag) {
        subject = stage.items[self.subjectSelectedIndex];
    }
    DDLogInfo(@"选择结果为 学段: %@， 学科: %@", stage.name, subject.name);
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
        return self.model.items.count;
    }
    StageSubjectItem *stage = self.model.items[self.stageSelectedIndex];
    return stage.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StageSubjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StageSubjectCell" forIndexPath:indexPath];
    
    StageSubjectItem *item = [self itemForIndexPath:indexPath];
    cell.title = item.name;
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
            headerView.type = StageSubject_Stage;
        }else {
            headerView.seperatorHidden = NO;
            headerView.type = StageSubject_Subject;
        }
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    StageSubjectItem *item = [self itemForIndexPath:indexPath];
    return [StageSubjectCell sizeForTitle:item.name];
}

- (StageSubjectItem *)itemForIndexPath:(NSIndexPath *)indexPath {
    StageSubjectItem *item = nil;
    if (indexPath.section == 0) {
        item = self.model.items[indexPath.row];
    }else {
        StageSubjectItem *stage = self.model.items[self.stageSelectedIndex];
        item = stage.items[indexPath.row];
    }
    return item;
}

@end
