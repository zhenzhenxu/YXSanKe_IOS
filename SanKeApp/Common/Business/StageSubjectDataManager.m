//
//  StageSubjectDataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectDataManager.h"

@interface StageSubjectDataManager()
@property (nonatomic, strong) FetchStageSubjectRequest *request;
@property (nonatomic, strong) FetchStageSubjectRequestItem *requestItem;
@end

@implementation StageSubjectDataManager
+ (StageSubjectDataManager *)sharedInstance {
    static dispatch_once_t once;
    static StageSubjectDataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[StageSubjectDataManager alloc] init];
        [sharedInstance loadData];
    });
    
    return sharedInstance;
}

+ (void)updateToLatestData {
    StageSubjectDataManager *manager = [StageSubjectDataManager sharedInstance];
    [manager.request stopRequest];
    manager.request = [[FetchStageSubjectRequest alloc]init];
    WEAK_SELF
    [manager.request startRequestWithRetClass:[FetchStageSubjectRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        if (retItem) {
            manager.requestItem = retItem;
            [manager saveData];
        }
    }];
}

+ (FetchStageSubjectRequestItem *)dataForStageAndSubject {
    return [StageSubjectDataManager sharedInstance].requestItem;
}

+ (void)fetchStageSubjectWithStageID:(NSString *)stageID subjectID:(NSString *)subjectID completeBlock:(void(^)(FetchStageSubjectRequestItem_stage *stage,FetchStageSubjectRequestItem_subject *subject))completeBlock {
    __block FetchStageSubjectRequestItem_stage *stage = nil;
    __block FetchStageSubjectRequestItem_subject *subject = nil;
    
    NSArray *stageArray = [self dataForStageAndSubject].data.stages;
    [stageArray enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_stage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.stageID isEqualToString:stageID]) {
            stage = obj;
            *stop = YES;
        }
    }];
    [stage.subjects enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_subject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.subjectID isEqualToString:subjectID]) {
            subject = obj;
            *stop = YES;
        }
    }];
    BLOCK_EXEC(completeBlock,stage,subject);
}

#pragma mark - 
- (void)saveData {
    NSString *json = [self.requestItem toJSONString];
    [[NSUserDefaults standardUserDefaults]setValue:json forKey:@"stage_subject_key"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)loadData {
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"stage_subject_key"];
    if (json) {
        self.requestItem = [[FetchStageSubjectRequestItem alloc]initWithString:json error:nil];
    }else {
        // 此处需要加载本地数据以保证学科学段表不为空
    }
}

@end
