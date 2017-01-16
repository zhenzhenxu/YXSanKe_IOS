//
//  ChannelIndexFetch.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "ChannelIndexRequest.h"
@interface ChannelIndexFetch : PagedListFetcherBase
@property (nonatomic, copy) NSString *stage;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, assign) NSInteger last_id;
@end
