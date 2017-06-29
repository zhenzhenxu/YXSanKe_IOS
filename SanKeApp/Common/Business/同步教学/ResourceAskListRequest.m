//
//  ResourceAskListRequest.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceAskListRequest.h"

@implementation ResourceAskListItem_Element

- (void)setContent:(NSString<Optional> *)content {
    _content = content;
    self.cellHeight = [NSNumber numberWithDouble:[self heightForCellWithContent:content]];
}

- (CGFloat)heightForCellWithContent:(NSString *)content {
    return [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40.0f, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                              attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}
                                 context:nil].size.height + 51.0f;
}

@end

@implementation ResourceAskListItem_Data
@end

@implementation ResourceAskListItem
@end

@implementation ResourceAskListRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_res_ask"];
        self.action = @"list";
        self.objecttype = @"16";
    }
    return self;
}

@end
