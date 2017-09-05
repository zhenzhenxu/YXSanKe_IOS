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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (!isEmpty(self.mark)) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 2;
        [[UIColor redColor] setStroke];
        for (GetBookInfoRequestItem_Marker *marker in self.mark.marker) {
            for (GetBookInfoRequestItem_MarkerLine *line in marker.lines) {
                [path moveToPoint:CGPointMake(line.x0.integerValue * kWidthRadio, line.y0.integerValue * kHeightRadio)];
                [path addLineToPoint:CGPointMake(line.x1.integerValue * kWidthRadio, line.y1.integerValue * kHeightRadio)];
            }
        }
        [path stroke];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self removeSubviews];
    if (!isEmpty(self.mark)) {
        for (GetBookInfoRequestItem_Marker *marker in self.mark.marker) {
            for (GetBookInfoRequestItem_MarkerIcon *icon in marker.icons) {
                UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                iconBtn.frame = CGRectMake(icon.ox.integerValue * kWidthRadio, icon.oy.integerValue * kHeightRadio, marker.iconWidth.integerValue, marker.iconHeight.integerValue);
                iconBtn.tag = marker.markerID.integerValue * 1000 + icon.iconID.integerValue;
                [iconBtn setImage:[UIImage imageNamed:@"标注icon"] forState:UIControlStateNormal];
                [iconBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:iconBtn];
            }
        }
    }
}

- (void)iconBtnAction:(UIButton *)sender {
    BLOCK_EXEC(self.markerBtnBlock, sender);
}

#pragma mark - setter
- (void)setMark:(GetBookInfoRequestItem_Mark *)mark {
    _mark = mark;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

@end
