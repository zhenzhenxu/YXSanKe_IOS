//
//  NSString+YXString.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXString)

// 是否为有效字符串
- (BOOL)yx_isValidString;

// 安全字符串
- (NSString *)yx_safeString;

// 去除字符串两端的空格及换行
- (NSString *)yx_stringByTrimmingCharacters;


#pragma mark - encode & decode

// 字符串编码
- (NSString *)yx_encodeString;

// 字符串解码
- (NSString *)yx_decodeString;

@end

@interface NSString (YXTextChecking)

// 正则表达式判断
- (BOOL)yx_textCheckingWithPattern:(NSString *)pattern;

// 是否为手机号
- (BOOL)yx_isPhoneNum;

// 是否为http链接
- (BOOL)yx_isHttpLink;

// 加密
- (NSString *)yx_md5;

@end


@interface NSString (YXFormatDate)
/*
 /   得到“2016-01-08”格式的时间字符串。
 */
+ (NSString *)timeStringWithDate:(NSDate *)date;

/*
 /   得到“203M”格式字符串。
 */
+ (NSString *)sizeStringWithFileSize:(unsigned long long)fileSize;

/*
 /   得到“00:00”格式的时间字符串。time是秒数。
 */
+ (NSString *)stringWithFormatFloat:(CGFloat)time;

/**
 *  格式化时间显示(动态 热点使用)
 *
 *  @param time 时间戳 单位毫秒
 *
 *  @return 需要显示的时间文本
 */
+ (NSString *)timeStringWithTimeStamp:(NSString *)time;
@end