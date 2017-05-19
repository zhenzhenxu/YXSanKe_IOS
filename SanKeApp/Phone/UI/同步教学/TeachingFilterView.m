//
//  TeachingFilterView.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingFilterView.h"
#import "TeachingFilterCell.h"
#import "TeachingFilterBackgroundView.h"

static const NSUInteger kTagBase = 876;
static const CGFloat kTableViewRowHeight = 44;

@interface TeachingFilterView_Item:NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end
@implementation TeachingFilterView_Item

@end
@interface TeachingFilterView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *typeContainerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *selectionTableView;

@property (nonatomic, strong) NSMutableArray *filterItemArray;
@property (nonatomic, strong) TeachingFilterView_Item *currentFilterItem;
@property (nonatomic, assign) BOOL layoutComplete;
@property (nonatomic, assign) BOOL isAnimating;
@end


@implementation TeachingFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.filterItemArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.typeContainerView = [[UIView alloc]initWithFrame:self.bounds];
    self.typeContainerView.backgroundColor = [UIColor whiteColor];
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.typeContainerView.frame.size.width, lineHeight)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.typeContainerView addSubview:topLine];
    
    UIView *bottomlLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeContainerView.bounds.size.height-lineHeight, self.typeContainerView.frame.size.width, lineHeight)];
    bottomlLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.typeContainerView addSubview:bottomlLine];
    [self addSubview:self.typeContainerView];
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    
    self.selectionTableView = [[UITableView alloc]init];
    self.selectionTableView.backgroundColor = [UIColor clearColor];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = kTableViewRowHeight;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    self.selectionTableView.layer.cornerRadius = 2.0f;
    [self.selectionTableView registerClass:[TeachingFilterCell class] forCellReuseIdentifier:@"TeachingFilterCell"];
    
}

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key{
    TeachingFilterView_Item *item = [[TeachingFilterView_Item alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = 0;
    [self.filterItemArray addObject:item];
}

- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key{
    __block TeachingFilterView_Item *item = nil;
    __block NSInteger itemIndex;
    
    WEAK_SELF
    [self.filterItemArray enumerateObjectsUsingBlock:^(TeachingFilterView_Item *f, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([f.typeName isEqualToString:key]) {
            STRONG_SELF
            item = f;
            itemIndex = idx;
            *stop = YES;
        }
    }];
    
    item.currentIndex = index;
    
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+itemIndex];
    [b setTitle:[self currentFilterNameForItem:item] forState:UIControlStateNormal];
    [self changeButton:b foldStatus:YES];
    [self changeButton:b selectedStatus:YES];
    [self exchangeTitleImagePositionForButton:b];
}

- (void)layoutSubviews{
    if (self.layoutComplete) {
        return;
    }
    CGFloat btnWidth = self.typeContainerView.bounds.size.width/self.filterItemArray.count;
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TeachingFilterView_Item *item = (TeachingFilterView_Item *)obj;
        UIButton *b = [self typeButtonWithName:[self currentFilterNameForItem:item]];
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.typeContainerView.bounds.size.height);
        b.tag = kTagBase + idx;
        [self exchangeTitleImagePositionForButton:b];
        BOOL status = item.currentIndex>=0 ? YES:NO;
        [self changeButton:b selectedStatus:status];
        [self.typeContainerView addSubview:b];
        if (idx < self.filterItemArray.count-1) {
            CGFloat h = 15;
            CGFloat y = (self.typeContainerView.bounds.size.height-h)/2;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(b.frame.origin.x+b.frame.size.width-lineWidth, y, lineWidth, h)];
            line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
            [self.typeContainerView addSubview:line];
        }
    }];
    
    self.layoutComplete = YES;
}


- (NSString *)currentFilterNameForItem:(TeachingFilterView_Item *)item{
    return item.filterArray[item.currentIndex];
}

- (UIButton *)typeButtonWithName:(NSString *)name{
    UIButton *b = [[UIButton alloc]init];
    b.titleLabel.textAlignment = NSTextAlignmentCenter;
    b.titleLabel.numberOfLines = 1;
    b.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [b setTitle:name forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self changeButton:b foldStatus:YES];
    return b;
}

- (void)exchangeTitleImagePositionForButton:(UIButton *)button{
    NSString *title = [button titleForState:UIControlStateNormal];
    CGFloat titleWidth = ceilf([title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width);
    titleWidth = MIN(titleWidth, button.frame.size.width - 20.0f);
    UIImage *image = [button imageForState:UIControlStateNormal];
    CGFloat imageWidth = image.size.width;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
}

- (void)changeButton:(UIButton *)b foldStatus:(BOOL)isFold{
    if (isFold) {
        [b setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
    }else{
        [b setImage:[UIImage imageNamed:@"上拉"] forState:UIControlStateNormal];
    }
}

- (void)changeButton:(UIButton *)b selectedStatus:(BOOL)isSelected{
    if (isSelected) {
        [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"点击后"] forState:UIControlStateNormal];
    }else{
        [b setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
}

- (void)btnAction:(UIButton *)sender{
    NSInteger curIndex = sender.tag - kTagBase;
    [self showFilterSelectionViewWithIndex:curIndex];
    [self changeButton:sender foldStatus:NO];
}

- (void)tapAction{
    [self hideFilterSelectionView];
}

#pragma mark - Show & Hide
- (void)showFilterSelectionViewWithIndex:(NSInteger)index{
    self.currentFilterItem = self.filterItemArray[index];
    
    UIView *superview = self.window;
    self.maskView.frame = superview.bounds;
    [superview addSubview:self.maskView];
    
    CGRect rect = [self convertRect:self.bounds toView:superview];
    CGFloat tableHeight;
    if (self.currentFilterItem.filterArray.count == 0) {//服务端数据返回为空时 显示
        tableHeight = kTableViewRowHeight;
    }else {
        tableHeight = MIN(self.currentFilterItem.filterArray.count*kTableViewRowHeight , kTableViewRowHeight *4);
    }
    TeachingFilterBackgroundView *bgView = [[TeachingFilterBackgroundView alloc]initWithFrame:CGRectMake(6, rect.origin.y+rect.size.height-5, rect.size.width-6-6, tableHeight+8) triangleX:self.bounds.size.width/(self.filterItemArray.count * 2)*(1+2*index)-6];
    self.selectionTableView.frame = CGRectMake(0, 8, bgView.bounds.size.width, tableHeight);
    [bgView addSubview:self.selectionTableView];
    [superview addSubview:bgView];
    [self.selectionTableView reloadData];
    if (self.currentFilterItem.filterArray.count > 4) {
        if (self.currentFilterItem.currentIndex > 1 &&  self.currentFilterItem.currentIndex < (self.currentFilterItem.filterArray.count - 1)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentFilterItem.currentIndex inSection:0];
            CGRect rectintableview=[self.selectionTableView rectForRowAtIndexPath:indexPath];
            [self.selectionTableView setContentOffset:CGPointMake(self.selectionTableView.contentOffset.x,(rectintableview.origin.y - kTableViewRowHeight * 2)) animated:NO];
        }else {
            [self.selectionTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentFilterItem.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
}

- (void)hideFilterSelectionView{
    [self.selectionTableView.superview removeFromSuperview];
    [self.maskView removeFromSuperview];
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:index+kTagBase];
    [self changeButton:b foldStatus:YES];
}

- (void)refreshFilters:(NSArray *)filters forKey:(NSString *)key isFilter:(BOOL)isFilter {
    __block TeachingFilterView_Item *item = [[TeachingFilterView_Item alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = 0;
    
    
    if (self.filterItemArray.count > 0) {
        __block NSInteger itemIndex = 0;
        WEAK_SELF
        [self.filterItemArray enumerateObjectsUsingBlock:^(TeachingFilterView_Item *f, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([f.typeName isEqualToString:key]) {
                STRONG_SELF
                itemIndex = idx;
                *stop = YES;
            }
        }];
        
        [self.filterItemArray replaceObjectAtIndex:itemIndex withObject:item];
        UIButton *b = [self.typeContainerView viewWithTag:kTagBase+itemIndex];
        [b setTitle:[self currentFilterNameForItem:item] forState:UIControlStateNormal];
        [self changeButton:b foldStatus:YES];
        [self changeButton:b selectedStatus:YES];
        [self exchangeTitleImagePositionForButton:b];
    }
    if (isFilter) {
        [self filterItemArrayChanged];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentFilterItem.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeachingFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingFilterCell"];
    cell.filterName = self.currentFilterItem.filterArray[indexPath.row];
    cell.isCurrent = (indexPath.row == self.currentFilterItem.currentIndex);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentFilterItem.currentIndex = indexPath.row;
    [self filterItemArrayChanged];
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+index];
    [b setTitle:self.currentFilterItem.filterArray[indexPath.row] forState:UIControlStateNormal];
    [self changeButton:b foldStatus:YES];
    
    [self hideFilterSelectionView];
    [self changeButton:b selectedStatus:YES];
    [self exchangeTitleImagePositionForButton:b];
}

- (void)filterItemArrayChanged {
    NSMutableArray *array = [NSMutableArray array];
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TeachingFilterView_Item *item = (TeachingFilterView_Item *)obj;
        NSInteger index = MAX(item.currentIndex, 0);
        [array addObject:@(index)];
    }];
    SAFE_CALL_OneParam(self.delegate, filterChanged, array);
}

@end
