//
//  UserInfoHeaderView.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoHeaderView.h"

#define ICONIMAGEVIEWHEIGHT 73.0f

@interface UserInfoHeaderView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation UserInfoHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.userInteractionEnabled = YES;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.alpha = 0.9;
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.mask = [self shapeLayerForMaskWithViewHeight:ICONIMAGEVIEWHEIGHT cornerRadius:8.0f];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.userInteractionEnabled = YES;
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.effectView];
    [self.backgroundImageView addSubview:self.maskView];
    [self.backgroundImageView addSubview:self.iconImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(ICONIMAGEVIEWHEIGHT * cos(M_PI * 30 / 180), ICONIMAGEVIEWHEIGHT));
    }];
}

- (void)setModel:(UserModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUrl] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            self.backgroundImageView.image = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"4691a6"]];
            self.effectView.hidden = YES;
            self.maskView.hidden = YES;
        } else {
            self.backgroundImageView.image = image;
            self.effectView.hidden = NO;
            self.maskView.hidden = NO;
        }
    }];
}

- (CAShapeLayer *)shapeLayerForMaskWithViewHeight:(CGFloat)viewHeight cornerRadius:(CGFloat)cornerRadius {
    CGFloat radian_30 = M_PI * 30 / 180;
    CGFloat halfViewHeight = viewHeight * 0.5f;
    CGFloat longSide = halfViewHeight * cos(radian_30);
    CGFloat shortSide = halfViewHeight * sin(radian_30);
    CGFloat gapLength = cornerRadius * tan(radian_30);
    CGFloat gapLongSide = cornerRadius * sin(radian_30);
    CGFloat gapShortSide = gapLength * sin(radian_30);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, shortSide + gapLength)];
    [path addQuadCurveToPoint:CGPointMake(gapLongSide, shortSide - gapShortSide) controlPoint:CGPointMake(0, shortSide)];
    [path addLineToPoint:CGPointMake(longSide - gapLongSide, gapShortSide)];
    [path addQuadCurveToPoint:CGPointMake(longSide + gapLongSide, gapShortSide      ) controlPoint:CGPointMake(longSide, 0)];
    [path addLineToPoint:CGPointMake(longSide * 2 - gapLongSide, shortSide - gapShortSide)];
    [path addQuadCurveToPoint:CGPointMake(longSide * 2, shortSide + gapLength) controlPoint:CGPointMake(longSide * 2, shortSide)];
    [path addLineToPoint:CGPointMake(longSide * 2, shortSide + halfViewHeight - gapLength)];
    [path addQuadCurveToPoint:CGPointMake(longSide * 2 - gapLongSide, shortSide + halfViewHeight + gapShortSide) controlPoint:CGPointMake(longSide * 2, shortSide + halfViewHeight)];
    [path addLineToPoint:CGPointMake(longSide + gapLongSide, viewHeight - gapShortSide)];
    [path addQuadCurveToPoint:CGPointMake(longSide - gapLongSide, viewHeight - gapShortSide) controlPoint:CGPointMake(longSide, viewHeight)];
    [path addLineToPoint:CGPointMake(gapLongSide, shortSide + halfViewHeight + gapShortSide)];
    [path addQuadCurveToPoint:CGPointMake(0, shortSide + halfViewHeight - gapLength) controlPoint:CGPointMake(0, shortSide + halfViewHeight)];
    [path closePath];
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.path = path.CGPath;
    return shapLayer;
}

@end
