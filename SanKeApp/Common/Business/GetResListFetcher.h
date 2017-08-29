//
//  GetResListFetcher.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface GetResListFetcher : PagedListFetcherBase

@property (nonatomic, strong) NSString *moduleId;
@property (nonatomic, strong) NSString *tab_type;

@end
