//
//  MarkView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MarkView.h"
#import "MarkBtn.h"
#define kWidthRadio (self.bounds.size.width / self.mark.picWidth.integerValue)
#define kHeightRadio (self.bounds.size.height / self.mark.picHeight.integerValue)

@implementation MarkView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self removeSubviews];
    if (!isEmpty(self.mark)) {
        [self.mark.marker enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Marker *marker, NSUInteger index, BOOL * _Nonnull stop) {
            [marker.lines enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Marker_Item *line, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGFloat lineAbove = marker.lineAbove.integerValue;
                CGFloat lineBelow = marker.lineBelow.integerValue;
                MarkBtn *mark = [MarkBtn initWithMarker_Item:line ScaleX:kWidthRadio ScaleY:kHeightRadio lineAbove:lineAbove  lineBelow:lineBelow];
                mark.tag = idx * 1000 + index;
                [mark addTarget:self action:@selector(lineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:mark];
                 
            }];
            [marker.icons enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Marker_Item *icon, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                iconBtn.frame = CGRectMake(icon.ox.integerValue * kWidthRadio - 40 * kWidthRadio * .5f , icon.oy.integerValue * kHeightRadio - 40 * kWidthRadio * 1.25f, 40 * kWidthRadio, 40 * kWidthRadio * 1.25f);
                iconBtn.tag = idx * 1000 + index;
                [iconBtn setImage:[UIImage imageNamed:@"标注icon"] forState:UIControlStateNormal];
                [iconBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:iconBtn];
            }];
        }];
    }
}

- (void)lineBtnAction:(UIButton *)sender {
    BLOCK_EXEC(self.markerBtnBlock, sender, YES);
}

- (void)iconBtnAction:(UIButton *)sender {
    BLOCK_EXEC(self.markerBtnBlock, sender, NO);
}

#pragma mark - setter
- (void)setMark:(GetBookInfoRequestItem_Mark *)mark {
    _mark = mark;
    [self setNeedsLayout];
}

@end
