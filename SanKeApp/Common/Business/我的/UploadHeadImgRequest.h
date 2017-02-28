//
//  UploadHeadImgRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/2/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
static NSString *const YXUploadUserPicSuccessNotification = @"kYXUploadUserPicSuccessNotification";

@interface UploadHeadImgRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *headDetail;

@end

// 修改头像
@interface UploadHeadImgRequest : YXPostRequest

@property (nonatomic, strong) NSString<Optional> *width;  //宽
@property (nonatomic, strong) NSString<Optional> *height; //高
@property (nonatomic, strong) NSString<Optional> *left;   //左坐标
@property (nonatomic, strong) NSString<Optional> *top;    //上坐标
@property (nonatomic, strong) NSString<Optional> *rate;   //原图缩小的比率（1表示原图大小）
@end
