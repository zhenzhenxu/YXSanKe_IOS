//
//  MarkBtn.m
//  SanKeApp
//
//  Created by SRT on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MarkBtn.h"

@interface MarkBtn()

@property (nonatomic, assign) CGFloat scaleY;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) GetBookInfoRequestItem_Marker_Item *markItem;

@end

@implementation MarkBtn

#pragma mark - instanceMethod
+(instancetype)initWithMarker_Item:(GetBookInfoRequestItem_Marker_Item *)item ScaleX:(CGFloat)scaleX ScaleY:(CGFloat)scaleY lineAbove:(CGFloat)lineAbove lineBelow:(CGFloat)lineBelow{
    MarkBtn *btn = [MarkBtn buttonWithType:UIButtonTypeCustom];
    btn.markItem = item;
    btn.scaleY = scaleY;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(item.x0.integerValue * scaleX, (item.y0.integerValue - lineAbove - 12.5f) * scaleY, (item.x1.integerValue - item.x0.integerValue) * scaleX, (lineAbove + lineBelow + 5 + 20) * scaleY);
    [btn drawBorder];
    return btn;
}

#pragma mark - lazyload
-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.lineWidth = 5.0f * self.scaleY;
    }
    return _shapeLayer;
}



#pragma mark - drawMethod
-(void)drawBorder{
    if (isEmpty(self.markItem)) {
        return;
    }
    UIBezierPath *bezPath = [self getBezPathByMarker_Item:self.markItem];
    self.shapeLayer.path = bezPath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

-(UIBezierPath *)getBezPathByMarker_Item:(GetBookInfoRequestItem_Marker_Item *)item{
    
    UIBezierPath *bezPath;
    if ([self.markItem.style isEqualToString:@"1"]) {
        // 1 为直线
        bezPath = [UIBezierPath bezierPath];
        [bezPath moveToPoint:CGPointMake(0, 0)];
        [bezPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    }else if ([self.markItem.style isEqualToString:@"2"]){
        // 2 为圆
        bezPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }else if ([self.markItem.style isEqualToString:@"3"]){
        // 3 为方框
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2;
        bezPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    }else if ([self.markItem.style isEqualToString:@"4"]){
        // 4 为竖线
        bezPath = [UIBezierPath bezierPath];
        [bezPath moveToPoint:CGPointMake(0, 0)];
        [bezPath addLineToPoint:CGPointMake(0,self.bounds.size.height)];
    }else{
        return nil;
    }
    return bezPath;

}


@end
