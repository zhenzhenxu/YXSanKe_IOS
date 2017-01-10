//
//  YXFileFavorWrapper.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileFavorWrapper.h"
#import "NavigationBarController.h"
//#import "YXDatumCellModel.h"
//#import "YXResourceCollectionRequest.h"

@interface YXFileFavorWrapper()
@property (nonatomic, strong) id data;
@property (nonatomic, weak) UIViewController *baseVC;
@property (nonatomic, strong) UIButton *favorButton;
//@property (nonatomic, strong) YXResourceCollectionRequest *collectionRequest;
@property (nonatomic, strong) NSSet *collectionResourceSet;
@end

@implementation YXFileFavorWrapper

- (instancetype)initWithData:(id)data baseVC:(UIViewController *)vc{
    if (self = [super init]) {
        self.data = data;
        self.baseVC = vc;
        [self setupButton];
    }
    return self;
}

- (void)setupButton{
    self.favorButton = [NavigationBarController naviButtonForTitle:@"收藏"];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)favorAction{
//    if (self.collectionRequest) {
//        [self.collectionRequest stopRequest];
//    }
//    YXDatumCellModel *datumModel = (YXDatumCellModel *)self.data;
//    self.collectionRequest = [[YXResourceCollectionRequest alloc] init];
//    self.collectionRequest.aid = datumModel.aid;
//    self.collectionRequest.type = datumModel.type;
//    self.collectionRequest.iscollection = @"0";
//    @weakify(self);
//    [YXPromtController startLoadingInView:self.baseVC.view.window];
//    [self.collectionRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//        @strongify(self);
//        [YXPromtController stopLoadingInView:self.baseVC.view.window];
//        HttpBaseRequestItem *item = (HttpBaseRequestItem *)retItem;
//        if (item && !error) {
//            self.favorButton.hidden = YES;
//            datumModel.isFavor = TRUE;
//            datumModel.rawData.isCollection = @"1";
//            SAFE_CALL(self.delegate, fileDidFavor);
//            [YXPromtController showToast:@"已保存到\"我的资源\"" inView:self.baseVC.view.window];
//        } else {
//            [YXPromtController showToast:error.localizedDescription inView:self.baseVC.view.window];
//        }
//    }];
}


@end
