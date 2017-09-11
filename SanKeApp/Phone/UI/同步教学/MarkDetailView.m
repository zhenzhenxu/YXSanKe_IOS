//
//  MarkDetailView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MarkDetailView.h"

#define kMarkMaxWidth (kScreenWidth - 20.0f)
#define kMarkMaxHeight 239
#define kMarkMinHeight 43

@interface MarkDetailView ()<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) DTAttributedTextContentView *attributedTextContentView;

@end

@implementation MarkDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bounces = NO;
    self.layer.cornerRadius = 2;
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.attributedTextContentView = [[DTAttributedTextContentView alloc] init];
    self.attributedTextContentView.delegate = self;
    [self.contentView addSubview:self.attributedTextContentView];
}

- (void)fitSizeOfScrollView {
    CGFloat scrollViewHeight = 0.0f;
    if (self.contentSize.height >= kMarkMaxHeight) {
        scrollViewHeight = kMarkMaxHeight;
    } else if (self.contentSize.height > kMarkMinHeight) {
        scrollViewHeight = self.contentSize.height;
    } else {
        scrollViewHeight = kMarkMinHeight;
    }
    self.bounds = CGRectMake(0, 0, kMarkMaxWidth, scrollViewHeight);
}

- (void)updateDetailViewLocation:(BOOL)animated {
    CGFloat detailCenterY = 0.0f;
    
    if ([self.markBtn.superview convertPoint:self.markBtn.center toView:self.window].y > kScreenHeight / 2.0f) {
        detailCenterY = [self.markBtn.superview convertPoint:CGPointMake(self.markBtn.center.x, CGRectGetMinY(self.markBtn.frame)) toView:self.window].y - self.bounds.size.height / 2.0f;
        self.center = CGPointMake(kScreenWidth / 2.0f, [self.markBtn.superview convertPoint:CGPointMake(self.markBtn.center.x, CGRectGetMinY(self.markBtn.frame)) toView:self.window].y);
    } else {
        detailCenterY = [self.markBtn.superview convertPoint:CGPointMake(self.markBtn.center.x, CGRectGetMaxY(self.markBtn.frame)) toView:self.window].y + self.bounds.size.height / 2.0f;
        self.center = CGPointMake(kScreenWidth / 2.0f, [self.markBtn.superview convertPoint:CGPointMake(self.markBtn.center.x, CGRectGetMaxY(self.markBtn.frame)) toView:self.window].y);
    }
    CGFloat currentHeight = self.bounds.size.height;
    if (animated) {
        self.bounds = CGRectMake(0, 0, kMarkMaxWidth, 0);
        [UIView animateWithDuration:0.3 animations:^{
            self.center = CGPointMake(kScreenWidth / 2.0f, detailCenterY);
            self.bounds = CGRectMake(0, 0, kMarkMaxWidth, currentHeight);
        }];
    } else {
        self.center = CGPointMake(kScreenWidth / 2.0f, detailCenterY);
        self.bounds = CGRectMake(0, 0, kMarkMaxWidth, currentHeight);
    }
}

#pragma mark - setters
- (void)setTextInfo:(NSString *)textInfo {
    _textInfo = textInfo;

    NSData *data = [textInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:NULL];
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attributedString];
    NSRange entireString = NSMakeRange(0, [attributedString length]);
    self.attributedTextContentView.attributedString = attributedString;
    
    CGRect maxRect = CGRectMake(0, 0, kMarkMaxWidth - 30, CGFLOAT_HEIGHT_UNKNOWN);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    CGSize sizeNeeded = [layoutFrame frame].size;
    self.attributedTextContentView.frame = CGRectMake(15, 15, kMarkMaxWidth - 30, sizeNeeded.height);
    self.contentView.frame = CGRectMake(0, 0, kMarkMaxWidth, sizeNeeded.height + 30);
    self.contentSize = self.contentView.frame.size;
    [self fitSizeOfScrollView];
}

- (void)setMarkBtn:(UIButton *)markBtn {
    _markBtn = markBtn;
    [self updateDetailViewLocation:YES];
}

#pragma mark - DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        return imageView;
    }
    return nil;
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", lazyImageView.url];
    
    CGFloat imagesHeight = 0.0f;
    
    for (DTTextAttachment *oneAttachment in [self.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        oneAttachment.displaySize = CGSizeMake(kMarkMaxWidth - 30, (kMarkMaxWidth - 30) / size.width * size.height);
        imagesHeight += oneAttachment.displaySize.height;
    }
    
    // need to reset the layouter because otherwise we get the old framesetter or cached layout frames
    self.attributedTextContentView.layouter = nil;
    
    CGRect frame = self.attributedTextContentView.frame;
    frame.size.height = frame.size.height + imagesHeight;
    self.attributedTextContentView.frame = frame;
    self.contentView.frame = CGRectMake(0, 0, kMarkMaxWidth, self.attributedTextContentView.frame.size.height + 30);
    self.contentSize = self.contentView.frame.size;
    [self fitSizeOfScrollView];
    [self updateDetailViewLocation:NO];
    // here we're layouting the entire string,
    // might be more efficient to only relayout the paragraphs that contain these attachments
    [self.attributedTextContentView relayoutText];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
