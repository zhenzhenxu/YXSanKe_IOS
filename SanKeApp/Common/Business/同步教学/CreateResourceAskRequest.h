//
//  CreateResourceAskRequest.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface CreateResourceAskRequest : YXPostRequest

@property (nonatomic, strong) NSString *replyed_comment_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *objecttype;
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic, strong) NSString *touserId;
@property (nonatomic, strong) NSString *parentid;
@property (nonatomic, strong) NSString *istruename;

@end
