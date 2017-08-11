//
//  GetMarkDetailRequest.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface GetMarkDetailRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *textInfo;
@end

@interface GetMarkDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetMarkDetailRequestItem_Data<Optional> *data;
@end

@interface GetMarkDetailRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *marker_id;
@property (nonatomic, strong) NSString<Optional> *icon_id;
@property (nonatomic, strong) NSString<Optional> *line_id;
@end
