//
//  MarkView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MarkView.h"

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
                UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat lineAbove = marker.lineAbove.integerValue;
                CGFloat lineBelow = marker.lineBelow.integerValue;
                lineBtn.frame = CGRectMake(line.x0.integerValue * kWidthRadio, (line.y0.integerValue - lineAbove - 12.5f) * kHeightRadio, (line.x1.integerValue - line.x0.integerValue) * kWidthRadio, (lineAbove + lineBelow + 5 + 20) * kHeightRadio);
                lineBtn.tag = idx * 1000 + index;
                [lineBtn addTarget:self action:@selector(lineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:lineBtn];
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (lineAbove + 10) * kHeightRadio, lineBtn.bounds.size.width, 5 * kHeightRadio)];
                lineLabel.backgroundColor = [UIColor redColor];
                [lineBtn addSubview:lineLabel];
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
