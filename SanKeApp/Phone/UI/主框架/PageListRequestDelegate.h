//
//  PageListRequestDelegate.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PageListRequestDelegate <NSObject>
- (void)requestWillRefresh;
- (void)requestEndRefreshWithError:(NSError *)error;
- (void)requestWillFetchMore;
- (void)requestEndFetchMoreWithError:(NSError *)error;
@end
