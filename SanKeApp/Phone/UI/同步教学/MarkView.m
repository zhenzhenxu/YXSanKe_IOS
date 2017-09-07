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
                lineBtn.frame = CGRectMake(line.x0.integerValue * kWidthRadio, line.y0.integerValue * kHeightRadio - marker.lineAbove.integerValue - 1, (line.x1.integerValue - line.x0.integerValue) * kWidthRadio, marker.lineAbove.integerValue + marker.lineBelow.integerValue + 2);
                lineBtn.tag = idx * 1000 + index;
                [lineBtn addTarget:self action:@selector(lineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:lineBtn];
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, marker.lineAbove.integerValue, lineBtn.bounds.size.width, 2)];
                lineLabel.backgroundColor = [UIColor redColor];
                [lineBtn addSubview:lineLabel];
            }];
            [marker.icons enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Marker_Item *icon, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                iconBtn.frame = CGRectMake(icon.ox.integerValue * kWidthRadio - marker.iconWidth.integerValue * .5f , icon.oy.integerValue * kHeightRadio - marker.iconWidth.integerValue * 1.25f, marker.iconWidth.integerValue, marker.iconWidth.integerValue * 1.25f);
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
