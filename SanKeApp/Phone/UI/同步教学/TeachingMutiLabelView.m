//
//  TeachingMutiLabelView.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMutiLabelView.h"

static const NSUInteger kTagBase = 10086;
static const CGFloat margin = 12;


@interface TeachingMutiLabelView ()
@property (nonatomic, copy) ClickTabButtonBlock buttonActionBlock;
@property (nonatomic, strong) UIButton *blackView;
@property (nonatomic, strong) UIButton *lastLabelBtn;
@property (nonatomic, strong) UIButton *expandBtn;
@end


@implementation TeachingMutiLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return self;
}

#pragma mark - setters
- (void)setTabArray:(NSArray<GetBookInfoRequestItem_Label *> *)tabArray {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    _tabArray = tabArray;
    
    [self setupUI];
}

- (void)setLastLabelBtn:(UIButton *)lastLabelBtn {
    _lastLabelBtn = lastLabelBtn;
    if (CGRectGetMinY(lastLabelBtn.frame) > 12) {
        self.expandBtn.hidden = NO;
    } else {
        self.expandBtn.hidden = YES;
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.clipsToBounds = YES;
    
    self.blackView = [[UIButton alloc] initWithFrame:self.superview.bounds];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
    self.blackView.hidden = YES;
    [self.blackView addTarget:self action:@selector(expandBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:self.blackView];
    [self.superview bringSubviewToFront:self];
    [self.superview insertSubview:self.blackView belowSubview:self];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1/[UIScreen mainScreen].scale)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:topLineView];
    
    UILabel *materialLabel = [[UILabel alloc] init];
    materialLabel.text = @"教学资料:";
    materialLabel.textColor = [UIColor colorWithHexString:@"999999"];
    materialLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:materialLabel];
    [materialLabel sizeToFit];
    materialLabel.center = CGPointMake(materialLabel.bounds.size.width / 2.0f + 10, 22);
    
    self.expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expandBtn.frame = CGRectMake(self.bounds.size.width - 50, 12, 40, 20);
    self.expandBtn.backgroundColor = [UIColor colorWithHexString:@"4691a6"];
    self.expandBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.expandBtn setTitle:@"展开" forState:UIControlStateNormal];
    [self.expandBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.expandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.expandBtn setImage:[UIImage imageNamed:@"筛选展开"] forState:UIControlStateNormal];
    [self.expandBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.expandBtn.imageView.width-2.5, 0, self.expandBtn.imageView.width+2.5)];
    [self.expandBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.expandBtn.titleLabel.width+2.5, 0, -self.expandBtn.titleLabel.width-2.5)];
    self.expandBtn.layer.cornerRadius = 2;
    [self.expandBtn addTarget:self action:@selector(expandBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.expandBtn];
    self.expandBtn.hidden = YES;
    
    __block CGFloat x = CGRectGetMaxX(materialLabel.frame) + 5;
    __block CGFloat y = materialLabel.center.y - 10;
    
    [self.tabArray enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Label *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [self buttonWithTitle:obj.name];
        b.frame = CGRectMake(x, y, 54, 20);
        if (CGRectGetMaxX(b.frame) > self.frame.size.width - 50) {
            x = CGRectGetMaxX(materialLabel.frame) + 5;
            y = CGRectGetMaxY(b.frame) + margin;
            b.frame = CGRectMake(x, y, 54, 20);
        }
        x = CGRectGetMaxX(b.frame) + margin;
        b.tag = kTagBase + idx;
        [self addSubview:b];
        if (idx == self.tabArray.count - 1) {
            self.lastLabelBtn = b;
        }
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.layer.cornerRadius = 2;
    b.layer.borderColor = [UIColor colorWithHexString:@"4691a6"].CGColor;
    b.layer.borderWidth = 1;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [b addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

#pragma mark - actions
- (void)expandBtnAction {
    self.expandBtn.selected = !self.expandBtn.selected;
    [UIView animateWithDuration:.3 animations:^{
        if (self.expandBtn.selected) {
            self.frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMaxY(self.lastLabelBtn.frame) + 12);
            self.expandBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        } else {
            self.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
            self.expandBtn.imageView.transform = CGAffineTransformIdentity;
        }
    }];
    if (self.expandBtn.selected) {
        self.blackView.hidden = NO;
    } else {
        self.blackView.hidden = YES;
    }
}

- (void)chooseButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag - kTagBase;
    self.currentTabIndex = index;
    BLOCK_EXEC(self.buttonActionBlock);
}

-(void)setClickTabButtonBlock:(ClickTabButtonBlock)block {
    self.buttonActionBlock = block;
}


@end
