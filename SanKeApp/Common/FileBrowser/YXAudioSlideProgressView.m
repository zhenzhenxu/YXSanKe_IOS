//
//  YXAudioSlideProgressView.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/11/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXAudioSlideProgressView.h"
@interface YXAudioSlideProgressView()
@property (nonatomic, strong) UIImageView *thumbNormalView;
@property (nonatomic, strong) UIView *wholeProgressView;
@end

@implementation YXAudioSlideProgressView {
    UIImage *_iconImage;
}
- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.bSliding = NO;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"音频全屏浏览-播放条"]];
    [self addSubview:bgImageView];
    bgImageView.userInteractionEnabled = NO;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(@0);
    }];
    
    self.wholeProgressView = [[UIView alloc] init];
    self.wholeProgressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.wholeProgressView];
    self.wholeProgressView.userInteractionEnabled = NO;

    _iconImage = [UIImage imageNamed:@"音频全屏浏览-播放条-按钮"];
    
    self.thumbNormalView = [[UIImageView alloc] init];
    self.thumbNormalView.frame = CGRectMake(0, 0, _iconImage.size.width, _iconImage.size.height);
    self.thumbNormalView.image = _iconImage;
    [self addSubview:self.thumbNormalView];
    
    [self.wholeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.right.mas_equalTo(-3);
        make.centerY.mas_equalTo(@0);
    }];
}

- (void)layoutSubviews {
    [self updateUI];
    [super layoutSubviews];
}

- (void)updateUI {
    [self.thumbNormalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_iconImage.size.width, _iconImage.size.height));
        make.centerX.mas_equalTo(self.wholeProgressView.mas_left).mas_offset(self.wholeProgressView.bounds.size.width * self.playProgress);
        make.centerY.mas_equalTo(self.wholeProgressView.mas_centerY);
    }];
}

#pragma mark - touch event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    DDLogWarn(@"%@", NSStringFromCGPoint(touchPoint));
    if (CGRectContainsPoint([self slidePointImageRect], touchPoint)) {
        self.bSliding = YES;
        self.thumbNormalView.image = [UIImage imageNamed:@"音频全屏浏览-播放条-按钮-按下之后"];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat startX = self.wholeProgressView.bounds.origin.x;
    CGFloat endX = self.wholeProgressView.bounds.origin.x + self.wholeProgressView.bounds.size.width;
    touchPoint.x = MAX(startX, touchPoint.x);
    touchPoint.x = MIN(endX, touchPoint.x);
    
    self.playProgress = (touchPoint.x - startX) / (endX - startX);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsLayout];
    self.bSliding = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.bSliding = NO;
    self.thumbNormalView.image = [UIImage imageNamed:@"音频全屏浏览-播放条-按钮"];
}

- (CGRect)slidePointImageRect {
    CGRect rect = self.thumbNormalView.frame;
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    return rect;
}

@end
