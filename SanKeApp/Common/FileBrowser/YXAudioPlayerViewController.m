//
//  YXAudioPlayerViewController.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/11/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXAudioPlayerViewController.h"

#import "LePlayer.h"
#import "LePlayerView.h"
#import "YXPlayerTopView.h"
#import "YXPlayerBottomView.h"
#import "YXPlayerBufferingView.h"
#import "AppDelegate.h"
#import "YXAudioSlideProgressView.h"

@interface YXAudioPlayerViewController() {
    NSDate *_startTime;
    NSTimeInterval _playTime;
}
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) NSMutableArray *disposableArray;

@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) YXAudioSlideProgressView *slideProgressView;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UILabel *playedTimeLabel;
@property (nonatomic, strong) UILabel *durationTimeLabel;
@end

@implementation YXAudioPlayerViewController

- (void)viewDidLoad {
    _playTime = 0;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(preProgress)]) {
        self.preProgress = [self.delegate preProgress];
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"304754"];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.player = [[LePlayer alloc] init];
    self.player.progress = self.preProgress;
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    
    self.playerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    [self setupObserver];
    
    // audio UI is below
    [self setupAudioUI];
    
    //[self checkNetwork];
    // 开始播放
    if (self.bIsLocalFile) {
        self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
    } else {
        self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
    }
}
- (void)recordPlayerDuration {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(playerProgress:totalDuration:stayTime:)]) {
        if (self.player.duration) {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
            }
            [self.delegate playerProgress:self.slideProgressView.playProgress totalDuration:self.player.duration stayTime:self->_playTime];
            self->_playTime = 0;
            self->_startTime = nil;
        }
    }
}
- (void)setupAudioUI {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@40);
        make.left.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(backButton.mas_right).offset(10);
        make.centerX.mas_equalTo(@0);
        make.centerY.mas_equalTo(backButton.mas_centerY);
        make.right.mas_lessThanOrEqualTo(@-10);
    }];
    titleLabel.text = self.title;
    
    // 预览保存button
    if (self.favorWrapper) {
        UIButton *btn = self.favorWrapper.favorButton;
        [self.view addSubview:btn];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(backButton.mas_right).offset(10);
            make.centerX.mas_equalTo(@0);
            make.centerY.mas_equalTo(backButton.mas_centerY);
            make.right.mas_lessThanOrEqualTo(btn.mas_left).mas_offset(-10);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backButton.mas_centerY);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(-10);
        }];
    }
    
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseButton addTarget:self action:@selector(playPauseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playPauseButton];
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self setPlaying];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setImage:[UIImage imageNamed:@"音频全屏浏览previous"] forState:UIControlStateNormal];;
    [self.view addSubview:preBtn];
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseButton.mas_centerY);
        make.centerX.mas_equalTo(self.playPauseButton.mas_centerX).mas_offset(-80);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [preBtn addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[UIImage imageNamed:@"音频全屏浏览next"] forState:UIControlStateNormal];;
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseButton.mas_centerY);
        make.centerX.mas_equalTo(self.playPauseButton.mas_centerX).mas_offset(80);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgResImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"音频全屏浏览-素材图"]];
    [self.view addSubview:bgResImageView];
    [bgResImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playPauseButton).mas_offset(@120);
        make.centerX.mas_equalTo(@0);
    }];
    
    UIImageView *upImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"音频全屏浏览-素材-上"]];
    UIImageView *downImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"音频全屏浏览-素材-下"]];
    [self.view addSubview:upImgView];
    [self.view addSubview:downImgView];
    

    self.slideProgressView = [[YXAudioSlideProgressView alloc] init];
    self.slideProgressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.slideProgressView];
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(@170);
        make.height.mas_equalTo(@40);
    }];
    
    [upImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(self.slideProgressView.mas_centerY);
    }];
    [downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(self.slideProgressView.mas_centerY);
    }];
    [self.slideProgressView updateUI];

    [self.slideProgressView addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = nextBtn;
    self.preButton = preBtn;
    
    
    self.preButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.slideProgressView.hidden = YES;
    self.playPauseButton.hidden = YES;
    
    //
    self.playedTimeLabel = [[UILabel alloc] init];
    self.playedTimeLabel.textColor = [UIColor whiteColor];
    self.playedTimeLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.playedTimeLabel];
    
    self.durationTimeLabel = [[UILabel alloc] init];
    self.durationTimeLabel.textColor = [UIColor whiteColor];
    self.durationTimeLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.durationTimeLabel];
    
    [self.playedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upImgView.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(@10);
    }];
    
    [self.durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upImgView.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(@-10);
    }];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)checkNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self showToast:@"网络不可用，请检查网络"];
        return;
    }
    
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self backAction];
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            if (self.bIsLocalFile) {
                self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
            } else {
                self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
            }
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    if ([r isReachableViaWiFi]) {
        // 开始播放
        if (self.bIsLocalFile) {
            self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
        } else {
            self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
        }
    }
}


- (void)backAction {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(playerProgress:totalDuration:stayTime:)]) {
        if (self.player.duration) {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
            }
            [self.delegate playerProgress:self.slideProgressView.playProgress totalDuration:self.player.duration stayTime:_playTime];
        }
    }
    
    for (RACDisposable *d in self.disposableArray) {
        [d dispose];
    }
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    SAFE_CALL(self.exitDelegate, browserExit);
}

- (void)playPauseAction {
    //self.player.bIsPlayable = YES;
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
    } else if (self.player.state == PlayerView_State_Finished) {
        [self.player seekTo:0];
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)do3GCheck {
    [self.player pause];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self backAction];
        return;
    }];
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.player play];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:goAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)setupObserver {
    // 2G / wifi
    Reachability *r = [Reachability reachabilityForInternetConnection];
    // 播放中，网络切换为2G
    @weakify(r);
    @weakify(self);
    [r setReachableBlock:^void (Reachability * reachability) {
        @strongify(r);
        @strongify(self); if (!self) return;;
        if([r isReachableViaWiFi]) {
            return;
        }
        
        if([r isReachableViaWWAN]) {
            [self do3GCheck];
        }
    }];
    [r startNotifier];
    
    self.disposableArray = [NSMutableArray array];
    RACDisposable *r0 = [RACObserve(self.player, state) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if ([x unsignedIntegerValue] == PlayerView_State_Playing) {
            self->_startTime = [NSDate date];
        } else {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
                self->_startTime = nil;
            }
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
                DDLogInfo(@"buffering");
                break;
            case PlayerView_State_Playing:
                DDLogInfo(@"Playing");
                [self setPlaying];
                break;
            case PlayerView_State_Paused:
                DDLogInfo(@"Paused");
                [self setPaused];
                break;
            case PlayerView_State_Finished:
                DDLogInfo(@"Finished");
                [self backAction];
                [self.player pause];
                [self setPaused];
                break;
            case PlayerView_State_Error:
            {
                DDLogError(@"Error");
                @weakify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self showToast:@"播放失败！"];
                });
            }
                break;
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [self.player rac_observeKeyPath:@"bIsPlayable"
                                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               observer:self
                                                  block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                                                      @strongify(self); if (!self) return;
                                                  }];
    
    RACDisposable *r2 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
//        if (isEmpty(self->_startTime)) {
//            self->_startTime = [NSDate date];
//        }

        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
        self.slideProgressView.hidden = NO;
        self.playPauseButton.hidden = NO;
        self.slideProgressView.duration = [x doubleValue];
        [self.slideProgressView updateUI];
        
        self.durationTimeLabel.text = [[self class] stringFromTime:[x doubleValue]];
        self.playedTimeLabel.text = [[self class] stringFromTime:self.slideProgressView.duration * self.slideProgressView.playProgress];
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
    }];
    
    RACDisposable *r4 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if (self.slideProgressView.bSliding) {
            return;
        }
        
        if (self.slideProgressView.duration > 0) {
            self.slideProgressView.playProgress = [x floatValue] / self.slideProgressView.duration;
            self.playedTimeLabel.text = [[self class] stringFromTime:self.slideProgressView.duration * self.slideProgressView.playProgress];
            [self.slideProgressView updateUI];
        }
    }];
    
//    RACDisposable *r5 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
//        @strongify(self); if (!self) return;
//        if (self->_startTime) {
//            self->_startTime = [NSDate date];
//        }
//    }];
    
    [self.disposableArray addObject:r0];
    [self.disposableArray addObject:r1];
    [self.disposableArray addObject:r2];
    [self.disposableArray addObject:r3];
    [self.disposableArray addObject:r4];
//    [self.disposableArray addObject:r5];
}

#pragma mark - top actions

- (void)setPlaying {
    [self.playPauseButton setImage:[UIImage imageNamed:@"音频全屏浏览-stop"] forState:UIControlStateNormal];
}

- (void)setPaused {
    [self.playPauseButton setImage:[UIImage imageNamed:@"音频全屏浏览-play"] forState:UIControlStateNormal];
}

- (void)progressAction {
    [self.player seekTo:self.player.duration * self.slideProgressView.playProgress];
    DDLogError(@"%f", self.slideProgressView.playProgress);
}

- (void)preAction {
    NSTimeInterval t = self.player.duration * self.slideProgressView.playProgress;
    [self.player seekTo:t - 5];
}

- (void)nextAction {
    NSTimeInterval t = self.player.duration * self.slideProgressView.playProgress;
    [self.player seekTo:t + 5];
}

+ (NSString *)stringFromTime:(NSTimeInterval)time {
    int minute = ((int)time) / 60;
    int second = ((int)time) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
