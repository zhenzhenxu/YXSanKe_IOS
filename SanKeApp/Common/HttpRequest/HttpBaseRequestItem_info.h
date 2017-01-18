//
//  HttpBaseRequestItem_info.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HttpBaseRequestItem_info_userinfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *backgroundimage;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *quxian;
@property (nonatomic, strong) NSString<Optional> *sheng;
@property (nonatomic, strong) NSString<Optional> *shi;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *truename;
@property (nonatomic, strong) NSString<Optional> *userid;
@end

@interface HttpBaseRequestItem_info : JSONModel
@property (nonatomic, strong) HttpBaseRequestItem_info_userinfo<Optional> *userInfo;
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *is_taged;  //0--未设置学段学科，1--已设置
@property (nonatomic, strong) NSString<Optional> *is_sanke;  // 1--是三科用户
@end
