//
//  QAReplyListFetcher.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface QAReplyListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *ask_id;
@end
