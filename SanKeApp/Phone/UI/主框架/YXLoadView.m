//
//  YXLoadView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

@interface YXMinuteView : UIView

@end

@implementation YXMinuteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    UIImageView *handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 17, 3.0f)];
    handImageView.image = [UIImage imageNamed:@"长针"];
    [self addSubview:handImageView];
}
@end

@interface YXHourView : UIView

@end

@implementation YXHourView
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    UIImageView *handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 0.0f, 3.0f, 14.0f)];
    handImageView.image = [UIImage imageNamed:@"短针"];
    [self addSubview:handImageView];
}

@end


#import "YXLoadView.h"
@interface YXLoadView(){
    UIImageView *_minuteHand;
    UIImageView *_hourHand;
    double imageviewAngle;
    BOOL _isRuning;
    UIView *_ringView;
    NSDate *_anHourAgo;
}
@end

@implementation YXLoadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    _minuteHand = [[UIImageView alloc] init];
    _minuteHand.image = [UIImage imageNamed:@"长针"];
    _minuteHand.frame = CGRectMake(0.0f, 0.0f, 17.0f, 3.0f);
    _minuteHand.center = self.center;
    _minuteHand.layer.shouldRasterize = YES;
    [self setAnchor:CGPointMake(0.0f, 0.5f) forView:_minuteHand];
    [self addSubview:_minuteHand];
    
    _hourHand = [[UIImageView alloc] init];
    _hourHand.image = [UIImage imageNamed:@"短针"];
    _hourHand.frame = CGRectMake(0.0f, 0.0f, 3.0f, 13.0f);
    _hourHand.center = self.center;
    _hourHand.layer.shouldRasterize = YES;
    [self setAnchor:CGPointMake(0.5f,0.0f) forView:_hourHand];
    [self addSubview:_hourHand];
    
    _ringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11.0f, 11.0f)];
    _ringView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _ringView.layer.cornerRadius = 5.5f;
    _ringView.layer.borderWidth = 3.0f;
    _ringView.center = self.center;
    _ringView.layer.borderColor = [UIColor colorWithHexString:@"2d87cf"].CGColor;
    [self addSubview:_ringView];
    
    imageviewAngle = 0.0f;
    _isRuning = NO;
}

- (void)setAnchor:(CGPoint)aPoint forView:(UIView *)aView {
    aView.layer.anchorPoint = aPoint;
    aView.layer.position = CGPointMake(aView.layer.position.x + (aPoint.x - aView.layer.anchorPoint.x) * aView.bounds.size.width, aView.layer.position.y + (aPoint.y - aView.layer.anchorPoint.y) * aView.bounds.size.height);
}
- (void)startAnimate{
    NSDate * now = [NSDate date];
    if (!_anHourAgo) {
        _anHourAgo = [now dateByAddingTimeInterval:-0.2f];
    }
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:_anHourAgo];
    if (!_isRuning  && timeBetween > 0.1f) {
        _isRuning = YES;
        [self rorateAnimatetion];
        _anHourAgo = [NSDate date];
    }
}
- (void)stopAnimate{
    _isRuning = NO;
}
- (void)rorateAnimatetion
{
    if(_isRuning)
    {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _minuteHand.transform = CGAffineTransformRotate(_minuteHand.transform, M_PI/3.0f);
            _hourHand.transform = CGAffineTransformRotate(_hourHand.transform, M_PI / 36.0f);
        }completion:^(BOOL finished) {
            if(finished){
                [self rorateAnimatetion];
            }
        }];
    }
}
@end
