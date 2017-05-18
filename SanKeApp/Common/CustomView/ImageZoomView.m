//
//  ImageZoomView.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ImageZoomView.h"

#define kMinZoomScale 1.0f //最小缩放倍数
#define kMaxZoomScale 5.0f //最大缩放倍数

@interface ImageZoomView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageZoomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = kMaxZoomScale;
    scrollView.minimumZoomScale = kMinZoomScale;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTap];
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
}

- (void)layoutSubviews {
    self.scrollView.frame = self.bounds;
    [self setupLayout];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
    self.scrollView.contentOffset = CGPointZero;
    [self setupLayout];
}

-(void)setupLayout {
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat maxHeight = self.scrollView.bounds.size.height;
        CGFloat maxWidth = self.scrollView.bounds.size.width;
        if(width > maxWidth || height > width){
            CGFloat ratio = height / width;
            CGFloat maxRatio = maxHeight / maxWidth;
            if(ratio < maxRatio){
                width = maxWidth;
                height = width*ratio;
            }else{
                height = maxHeight;
                width = height / ratio;
            }
        }
        self.imageView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
        self.scrollView.contentSize = self.imageView.frame.size;
        self.scrollView.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollView.contentSize = self.imageView.frame.size;
    }
     self.scrollView.contentOffset = CGPointZero;
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

#pragma mark - handleDoubleTap
- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer
{
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.scrollView.zoomScale == self.scrollView.minimumZoomScale;
            CGFloat scale = zoomOut?self.scrollView.maximumZoomScale:self.scrollView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.zoomScale = scale;
                if(zoomOut){
                    CGFloat x = touchPoint.x*scale - self.scrollView.bounds.size.width / 2;
                    CGFloat maxX = self.scrollView.contentSize.width-self.scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.scrollView.bounds.size.height / 2;
                    CGFloat maxY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
            
        }
            break;
        default:break;
    }
}
@end
