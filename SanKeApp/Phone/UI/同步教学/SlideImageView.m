//
//  SlideImageView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SlideImageView.h"
#import "YXPromtController.h"
#import "MenuSelectionView.h"

#define kMinZoomScale 1.0f //最小缩放倍数
#define kMaxZoomScale 2.0f //最大缩放倍数

@interface SlideImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;

@end

@implementation SlideImageView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kSlideViewDidSlide" object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            self.scrollView.zoomScale = 1.0f;
        }];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = kMaxZoomScale;
    scrollView.minimumZoomScale = kMinZoomScale;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    [self.imageView setShowActivityIndicatorView:YES];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [self.doubleTap setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:self.doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToSaveImage:)];
    [imageView addGestureRecognizer:longPress];
    
    self.markView = [[MarkView alloc] init];
    [self.imageView addSubview:self.markView];
}

- (void)setModel:(TeachingPageModel *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.imageView.image = [UIImage imageNamed:@"图片加载失败"];
        }else {
            self.imageView.image = image;
            self.markView.mark = model.mark;
            [self setNeedsLayout];
        }
    }];
}

- (void)layoutSubviews {
    self.scrollView.frame = self.bounds;
    [self setupLayout];
}

- (void)setupLayout {
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
    self.markView.frame = self.imageView.bounds;
    [self.markView setNeedsDisplay];
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - longPress & saveImage
- (void)longPressToSaveImage:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self handleSaveImage];
    }
}

- (void)handleSaveImage {
    self.menuSelectionView = [[MenuSelectionView alloc]init];
    self.menuSelectionView.dataArray = @[
                                         @"保存图片",
                                         @"取消"
                                         ];
    CGFloat height = [self.menuSelectionView totalHeight];
    [self.scrollView addSubview:self.menuSelectionView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    alert.contentView = self.menuSelectionView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_bottom).offset(0);
                make.height.mas_equalTo(height);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.mas_bottom).offset(0);
            make.height.mas_equalTo(height);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.height.mas_equalTo(height);
                make.bottom.equalTo(view);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [self.menuSelectionView setChooseMenuBlock:^(NSInteger index) {
        STRONG_SELF
        [alert hide];
        [self chooseMenuWithIndex:index];
    }];
}

- (void)chooseMenuWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self saveImage:self.imageView.image];
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void)saveImage:(UIImage *)image {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            [YXPromtController showToast:@"相册权限受限\n请在设置-隐私-相册中开启" inView:self.scrollView];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                    {
                        [YXPromtController showToast:@"相册权限受限\n请在设置-隐私-相册中开启" inView:self.scrollView];
                    }
                    else if (status == PHAuthorizationStatusAuthorized)
                    {
                        [self loadImageFinished:image];
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
            [self loadImageFinished:image];
            break;
        default:
            break;
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    if (image == nil) {
        [YXPromtController showToast:@"保存失败" inView:self.scrollView];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [YXPromtController showToast:@"保存失败" inView:self.scrollView];
    }else{
        [YXPromtController showToast:@"已经保存成功" inView:self.scrollView];
    }
}

#pragma mark - handleDoubleTap
- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer {
    if (recongnizer.state == UIGestureRecognizerStateEnded || recongnizer.state == UIGestureRecognizerStateCancelled) {
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
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
    [self.markView setNeedsDisplay];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
