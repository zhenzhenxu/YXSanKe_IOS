//
//  HttpBaseRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "JSONModel.h"

static NSString *const YXTokenInValidNotification = @"kYXTokenInValidNotification";

@interface HttpBaseRequestItem_Status : JSONModel
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *code;
@end

@interface HttpBaseRequestItem : JSONModel

//@property (nonatomic, copy) HttpBaseRequestItem_Status<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *debugDesc;
//老良师通接口通用格式
@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *debug;

@end


typedef void(^HttpRequestCompleteBlock)(id retItem, NSError *error, BOOL isMock);

@interface HttpBaseRequest : JSONModel {
    ASIHTTPRequest *_request;
    HttpRequestCompleteBlock _completeBlock;
    Class _retClass;
    BOOL _isMock;
}
@property (nonatomic, copy) NSString<Ignore> *urlHead;
- (ASIHTTPRequest *)request;
- (void)updateRequestUrlAndParams;

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock;

- (void)stopRequest;
- (void)dealWithResponseJson:(NSString *)json;

#pragma mark - private util
- (NSDictionary *)_paramDict;
- (NSString *)_generateFullUrl;
@end
