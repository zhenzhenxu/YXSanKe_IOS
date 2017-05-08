//
//  StepOneRequest.m
//  SanKeApp
//
//  Created by Lei Cai on 08/05/2017.
//  Copyright © 2017 niuzhaowang. All rights reserved.
//

#import "StepOneRequest.h"

@interface StepOneRequest ()
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastModifiedDate;
@end

@implementation StepOneRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"aid":@"id"}];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"http://newupload.yanxiu.com/fileUpload";
    }
    return self;
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    self.userId = @"23246746";
    self.aid = @"app_wd_img";
    self.name = @"zhijian";
    self.lastModifiedDate = @"1430654170000";
    
    // 设置 form-data，第一步无需cookie
    [self.request addData:self.data withFileName:@"iosUploadDemo" andContentType:nil forKey:@"file"];
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
}

@end


@implementation StepOneResponse

@end
