//
//  ResourceAskListFetcher.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ResourceAskListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *resourceID;
@end
