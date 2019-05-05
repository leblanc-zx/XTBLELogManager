//
//  XTUtils+MD5.h
//  XTComponentUtils
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (MD5)

/**
 获取MD5
 
 @param string 明文
 @return MD5字符串
 */
+ (NSString *)MD5WithString:(NSString *)string;

/**
 获取20位MD5
 
 @param string 明文
 @return 20位MD5字符串
 */
+ (NSString *)MD5Encode20WithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
