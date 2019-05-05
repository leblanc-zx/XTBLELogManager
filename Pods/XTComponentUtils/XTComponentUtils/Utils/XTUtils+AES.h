//
//  XTUtils+AES.h
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (AES)

/**
 AES-CBC模式加密

 @param string 要加密的数据
 @param key 密钥支持128 192 256bit，16、24、32字节，长度错误将抛出异常
 @param iv 初始化向量iv为16字节。如果为nil，则初始化向量为0
 @return 加密结果为16进制字符串形式
 */
+ (NSString *)aesEncryptWithString:(NSString *)string key:(NSString *)key iv:(NSString *)iv;

/**
 AES-CBC模式解密
 @param data 需要解密的数据
 @param key 密钥支持128 192 256bit，16、24、32字节，长度错误将抛出异常
 @param iv 初始化向量iv为16字节。如果为nil，则初始化向量为0
 @return 解密结果为UTF8String
 */
+ (NSString *)aesDecryptWithData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

/**
 sha256签名
 
 @param arg1 参数1,参数2,参数3...
 @return NSString形式返回
 */
+ (NSString *)sha256HashSign:(NSString *)arg1, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
