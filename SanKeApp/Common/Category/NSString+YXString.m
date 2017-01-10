//
//  NSString+YXString.m
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "NSString+YXString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YXString)

- (BOOL)yx_isValidString
{
    if (nil == self
        || ![self isKindOfClass:[NSString class]]
        || [self yx_stringByTrimmingCharacters].length <= 0) {
        return NO;
    }
    return YES;
}

- (NSString *)yx_safeString
{
    if ([self yx_isValidString]) {
        return self;
    }
    return @"";
}

- (NSString *)yx_stringByTrimmingCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)yx_encodeString
{
    CFStringRef stringFef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (__bridge CFStringRef)self,
                                                                    NULL,
                                                                    (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)stringFef;
}

- (NSString *)yx_decodeString
{
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (YXTextChecking)

- (BOOL)yx_textCheckingWithPattern:(NSString *)pattern
{
    if ([pattern yx_isValidString]
        && [self yx_isValidString]) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *firstMacth = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (firstMacth) {
            return YES;
        }
    }
    return NO;
}

/*
 * ^[1]，首字母必须是1
 * [3-8]，第二个数字为3-8之间
 * +，表示至少一个[3-8]
 * \\d，表示数字
 * {9}，表示后面包含9个数字
 * $，结束符
 */
- (BOOL)yx_isPhoneNum
{
    NSString *phoneNum = [self yx_stringByTrimmingCharacters];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return (phoneNum.length == 11) && [phoneNum yx_textCheckingWithPattern:@"^[1][3-8]+\\d{9}$"];
}

- (BOOL)yx_isHttpLink
{
    if (![self yx_isValidString]) {
        return NO;
    }
    NSString *link = [self yx_stringByTrimmingCharacters];
    if ([link hasPrefix:@"http"]
        || [link hasPrefix:@"https"]
        || [link hasPrefix:@"www."]) {
        return YES;
    }
    return NO;
}

- (NSString *)yx_md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

@end

@implementation NSString (YXFormatDate)

+ (NSString *)timeStringWithDate:(NSDate *)date{
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [formatter stringFromDate:date];
        return destDateString;
    }
}

+ (NSString *)sizeStringWithFileSize:(unsigned long long)fileSize
{
    // 小于1KB
    if (fileSize < 1024) {
        return @"< 1K";
        //        return [NSString stringWithFormat:@"%lldB", aBytes];
    }
    
    // 1KB - 1MB
    if ((fileSize >= 1024) && (fileSize < 1024*1024)) {
        //        unsigned long long kb = aBytes / 1024ll;
        //        return [NSString stringWithFormat:@"%lldK", kb];
        float kb = (float)fileSize / 1024.f;
        return [NSString stringWithFormat:@"%.2fK", kb];
    }
    
    // 1MB - 1GB
    if ((fileSize >= 1024*1024) && (fileSize < 1024*1024*1024)) {
        float mb = (float)fileSize / (1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fM", mb];
    }
    
    // 大于等于1GB
    if (fileSize >= 1024*1024*1024) {
        float gb = (float)fileSize / (1024.f*1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fG", gb];
    }
    
    return @"";
}
+ (NSString *)stringWithFormatFloat:(CGFloat)time
{
    NSInteger newTime = (NSInteger)time;
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)newTime/60,(long)newTime%60];
    return timeString;
}

+ (NSString *)timeStringWithTimeStamp:(NSString *)time{
    double timeStamp = time.doubleValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000.0f];
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    if (interval < 60) {//小于1分钟
       return @"1分钟前";
    }else if (interval < 60 * 60){//小于60分钟
        return [NSString stringWithFormat:@"%d分钟前",(int)(interval/60.0f)];
    }
    else if (interval < 24 * 60 * 60){
        return [NSString stringWithFormat:@"%d小时前",(int)(interval/60.0f/60.0f)];
    }
    else if (interval < 7 * 24 * 60 * 60){
        return [NSString stringWithFormat:@"%d天前",(int)(interval/60.0f/60.0f/24.0f)];
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        return [formatter stringFromDate:date];
    }
}
@end
