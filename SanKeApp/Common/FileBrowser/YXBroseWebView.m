//
//  YXBroseWebView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBroseWebView.h"
#import "YXShowWebMenuView.h"

@interface YXBroseWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDate *beginDate;
@end

@implementation YXBroseWebView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleString;
    [self setupLeftBack];
    WEAK_SELF
    [self setupRightWithImageNamed:@"更多icon" highlightImageNamed:@"更多icon-点击态"];
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.webView loadRequest:request];
    
    self.beginDate = [NSDate date];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.beginDate = [NSDate date];
    }];
}

- (void)naviRightAction{
    YXShowWebMenuView *menuView = [[YXShowWebMenuView alloc]initWithFrame:self.view.window.bounds];
    menuView.didSeletedItem = ^(NSInteger index) {
        if (index == 0) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
        }
        if (index == 1) {
            NSURL *requestURL = [[NSURL alloc] initWithString:self.webView.request.URL.absoluteString];
            [[UIApplication sharedApplication] openURL:requestURL];
        }
        if (index == 2) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.webView.request.URL.absoluteString;
            [self showToast:@"复制成功"];
        }
    };
    [self.view.window addSubview:menuView];
}
- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    SAFE_CALL_OneParam(self.browseTimeDelegate, browseTimeUpdated, [[NSDate date] timeIntervalSinceDate:self.beginDate]);
    SAFE_CALL(self.exitDelegate, browserExit);
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopLoading];
    if(self.errorView) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopLoading];
    if (error.code == -1009) {
        self.errorView.frame = self.view.bounds;
        if (!self.errorView) {
            WEAK_SELF
            self.errorView = [[ErrorView alloc]initWithFrame:self.view.bounds];
            self.errorView.retryBlock = ^{
                STRONG_SELF
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
            };
            [self.view addSubview:self.errorView];
        }
    }
}

@end
