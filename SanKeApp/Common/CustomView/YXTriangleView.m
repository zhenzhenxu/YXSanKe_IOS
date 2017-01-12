//
//  YXTriangleView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTriangleView.h"

@implementation YXTriangleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.direction = YXTriangleDirection_Top;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.direction == YXTriangleDirection_Top) {
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width/2, 0);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    }else if (self.direction == YXTriangleDirection_Bottom){
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width, 0);
    }else if (self.direction == YXTriangleDirection_Left){
        CGContextMoveToPoint(context, rect.size.width, 0);
        CGContextAddLineToPoint(context, 0, rect.size.height/2);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    }else if (self.direction == YXTriangleDirection_Right){
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
        CGContextAddLineToPoint(context, 0, rect.size.height);
    }
    CGContextClosePath(context);
    [[UIColor whiteColor]setFill];
    CGContextFillPath(context);
}

@end
