//
//  QAInputeTextView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAInputeTextView.h"

@implementation QAInputeTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    if (self = [super init]) {
        
        self.layer.cornerRadius = 2.0f;
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14.0f];
        self.textColor = [UIColor colorWithHexString:@"333333"];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]
                                     };
        NSAttributedString *placeholderAttributed = [[NSMutableAttributedString alloc]initWithString:placeholder attributes:attributes];
        self.attributedPlaceholder = placeholderAttributed;
        
        self.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 9);
    }
    return self;
}

@end
