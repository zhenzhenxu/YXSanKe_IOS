//
//  QAShareView.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAShareView.h"
#import "QAShareCell.h"
#import "QAShareHeaderView.h"

@implementation QAShareModel
@end

@interface QAShareView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) CancelActionBlock buttonActionBlock;
@property (nonatomic, copy) ShareActionBlock shareBlock;
@end
@implementation QAShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDataArray];
        [self setupUI];
    }
    return self;
}

- (void)setupDataArray {
    NSMutableArray *array = [NSMutableArray array];
    
    if ([YXShareManager isWXAppSupport]) {
        QAShareModel *model0 = [[QAShareModel alloc]init];
        model0.type = YXShareType_WeChat;
        QAShareModel *model1 = [[QAShareModel alloc]init];
        model1.type = YXShareType_WeChatFriend;
        
        [array addObject:model0];
        [array addObject:model1];
    }
    if ([YXShareManager isQQSupport]) {
        QAShareModel *model2 = [[QAShareModel alloc]init];
        model2.type = YXShareType_TcQQ;
        QAShareModel *model3 = [[QAShareModel alloc]init];
        model3.type = YXShareType_TcZone;
        
        [array addObject:model2];
        [array addObject:model3];
    }
    self.dataArray = array.copy;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.headerReferenceSize = CGSizeMake(self.width, 28);
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 15, 10, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.collectionView registerClass:[QAShareCell class] forCellWithReuseIdentifier:@"QAShareCell"];
    [self.collectionView registerClass:[QAShareHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAShareHeaderView"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    UIButton *cancelButton = [[UIButton alloc]init];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)cancelAction {
    BLOCK_EXEC(self.buttonActionBlock);
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAShareCell" forIndexPath:indexPath];
    QAShareModel *model =self.dataArray[indexPath.row];
    cell.type = model.type;
    WEAK_SELF
    [cell setActionBlock:^{
        STRONG_SELF
        DDLogDebug(@"点击%@cell",@(model.type));
        BLOCK_EXEC(self.shareBlock,model.type);
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        QAShareHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAShareHeaderView" forIndexPath:indexPath];
        headerView.title = @"分享到";
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(52, 52);
}


- (void)setCancelActionBlock:(CancelActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setShareActionBlock:(ShareActionBlock)block {
    self.shareBlock = block;
}
@end
