//
//  XTUtils+MD5.m
//  XTComponentUtils
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+MD5.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XTUtils (MD5)

/**
 获取MD5

 @param string 明文
 @return MD5字符串
 */
+ (NSString *)MD5WithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return [output lowercaseString];
}

/**
 获取20位MD5
 
 @param string 明文
 @return 20位MD5字符串
 */
+ (NSString *)MD5Encode20WithString:(NSString *)string {
    NSString *md5 = [self MD5WithString:string];
    return [md5 substringToIndex:20];
}

@end
