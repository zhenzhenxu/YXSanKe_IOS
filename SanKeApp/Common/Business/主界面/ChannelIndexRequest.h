//
//  ChannelIndexRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ChannelIndexRequestItem_Data_Elements
@end
@interface ChannelIndexRequestItem_Data_Elements : JSONModel
@property (nonatomic ,copy) NSString<Optional> *title;
@property (nonatomic ,copy) NSString<Optional> *desc;
@property (nonatomic ,copy) NSString<Optional> *author;
@property (nonatomic ,copy) NSString<Optional> *thanks;
@end
@interface ChannelIndexRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<ChannelIndexRequestItem_Data_Elements, Optional> *elements;
@property (nonatomic, copy) NSString<Optional> *moreData;
@end
@interface ChannelIndexRequestItem : HttpBaseRequestItem
@property (nonatomic ,strong) ChannelIndexRequestItem_Data<Optional> *data;
@end
@interface ChannelIndexRequest : YXGetRequest
@property (nonatomic, copy) NSString *stage;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, assign) NSInteger last_id;
@end
