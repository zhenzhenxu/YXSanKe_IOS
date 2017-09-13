//
//  YXQLPreviewController.m
//  YanXiuApp
//
//  Created by wd on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQLPreviewController.h"
#import "NavigationBarController.h"

@interface YXQLPreviewItem : NSObject<QLPreviewItem>
- (void)setTitle:(NSString *)title;
- (void)setUrl:(NSURL *)url;
@end
@implementation YXQLPreviewItem
@synthesize previewItemTitle = _previewItemTitle;
@synthesize previewItemURL = _previewItemURL;
- (void)setTitle:(NSString *)title{
    _previewItemTitle = title;
}
- (void)setUrl:(NSURL *)url{
    _previewItemURL = url;
}
@end


@interface YXQLPreviewController ()<QLPreviewControllerDataSource>
@property (nonatomic, strong) UINavigationBar   *qlNavigationBar;
@property (nonatomic, strong) UINavigationBar   *overlayNavigationBar;
@property (nonatomic, strong) UINavigationItem *overlayNavigationItem;
@property (nonatomic, strong) YXQLPreviewItem *previewItem;
@property (nonatomic, strong) NSDate *beginDate;

@end

@implementation YXQLPreviewController

- (void)dealloc {
     [self.qlNavigationBar removeObserver:self forKeyPath:@"hidden" context:nil];
}

- (instancetype)init{
    if (self = [super init]) {
        self.previewItem = [[YXQLPreviewItem alloc]init];
    }
    return self;
}

- (void)setQlTitle:(NSString *)qlTitle{
    _qlTitle = qlTitle;
    [self.previewItem setTitle:qlTitle];
}

- (void)setQlUrl:(NSString *)qlUrl{
    _qlUrl = qlUrl;
    [self.previewItem setUrl:[NSURL fileURLWithPath:qlUrl]];
}

- (BOOL)canPreview{
    return [YXQLPreviewController canPreviewItem:self.previewItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    self.beginDate = [NSDate date];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.beginDate = [NSDate date];
    }];
}

- (BOOL)shouldAutorotate
{
    return NO; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.qlNavigationBar) {
        return;
    }
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.qlNavigationBar = [self getNavigationBarFromView:self.view];
    self.overlayNavigationBar = [[UINavigationBar alloc] initWithFrame:[self navigationBarFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]]];
    self.overlayNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.overlayNavigationBar];
    [self.navigationController setNavigationBarHidden:YES];
    //self.navigationController.navigationBar = self.overlayNavigationBar;
    NSAssert(self.qlNavigationBar, @"could not find navigation bar");
    if (self.qlNavigationBar) {
        [self.qlNavigationBar addObserver:self forKeyPath:@"hidden" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    // Now initialize your custom navigation bar with whatever items you like...
    self.overlayNavigationItem = [[UINavigationItem alloc] initWithTitle:self.qlTitle];
    WEAK_SELF
    [NavigationBarController setLeftWithNavigationItem:self.overlayNavigationItem imageName:@"返回按钮" highlightImageName:@"返回按钮点击态" action:^{
        STRONG_SELF
        [self doneButtonTapped:nil];
    }];
    self.overlayNavigationItem.hidesBackButton = YES;
    
    UIButton *rightButton = self.favorWrapper.favorButton;
    self.overlayNavigationItem.rightBarButtonItems = [NavigationBarController barButtonItemsForView:rightButton];
    
    [self.overlayNavigationBar pushNavigationItem:self.overlayNavigationItem animated:NO];
    UIView *barBgView = [[UIView alloc]init];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.overlayNavigationBar addSubview:barBgView];
    [barBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
//     [self.overlayNavigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor blueColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.overlayNavigationBar.frame = [self navigationBarFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (UIButton *)leftButton{
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [b setTitle:@"返回" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:16];
    [b addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (NSArray *)leftBarButtonItemsWithButton:(UIButton *)button
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    return @[negativeSpacer, barButtonItem];
}

- (NSArray *)rightBarButtonItemsWithButton:(UIButton *)button
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    return @[negativeSpacer,barButtonItem];
}


- (void)doneButtonTapped:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
    SAFE_CALL_OneParam(self.browseTimeDelegate, browseTimeUpdated, [[NSDate date] timeIntervalSinceDate:self.beginDate]);
    SAFE_CALL(self.exitDelegate, browserExit);
}

- (UINavigationBar *)getNavigationBarFromView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UINavigationBar class]]) {
            return (UINavigationBar *)v;
        } else {
            UINavigationBar *navigationBar = [self getNavigationBarFromView:v];
            if (navigationBar) {
                return navigationBar;
            }
        }
    }
    return nil;
}

- (CGRect)navigationBarFrameForOrientation:(UIInterfaceOrientation)orientation {
    // We cannot use the frame of qlNavigationBar as it changes position when hidden, also there seems to be a bug in iOS7 concerning qlNavigationBar height in landcape
    return CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, [self navigationBarHeight:orientation]);
}
- (CGFloat)navigationBarHeight:(UIInterfaceOrientation)orientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            return 52.0f;
        } else {
            return 64.0f;
        }
    } else {
        return 64.0f;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Toggle visiblity of our custom navigation bar according to the ql navigationbar
    if ([keyPath isEqualToString:@"hidden"]) {
        self.overlayNavigationBar.hidden = self.qlNavigationBar.isHidden;
        [UIApplication sharedApplication].statusBarHidden = self.qlNavigationBar.isHidden;
    }
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.previewItem;
}


@end
