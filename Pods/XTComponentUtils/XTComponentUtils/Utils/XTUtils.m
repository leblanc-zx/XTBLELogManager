//
//  XTUtils.m
//  MobileInternetMeterReadingSystem
//
//  Created by apple on 2017/9/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XTUtils.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XTUtils

#pragma -mark 进制转换

/**
 NSData 转 16进制字符串
 
 @param data NSData
 @return 16进制字符串
 */
+ (NSString *)hexStringWithData:(NSData *)data
{
    
    Byte *bytes = malloc(data.length);
    memcpy(bytes, data.bytes, data.length);
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < data.length; i++) {
        NSString *hex = [NSString stringWithFormat:@"%x",(bytes[i] & 0xff)];
        //补0
        if (hex.length == 1) {
            [result appendFormat:@"0"];
        }
        [result appendString:hex];
    }
    
    return result;
    
}

/**
 16进制字符串 转 NSData
 
 @param hexString 16进制字符串
 @return NSData
 */
+ (NSData *)dataWithHexString:(NSString *)hexString {
    
    if (hexString.length%2 == 1) {
        hexString = [NSString stringWithFormat:@"0%@",hexString];
    }
    
    int length = (int)hexString.length/2;
    Byte *bytes = (Byte *)malloc(length*2);
    
    for (int i = 0; i < length; i ++) {
        NSString *hexStr = [hexString substringWithRange:NSMakeRange(i*2, 2)];
        bytes[i] = strtoul([hexStr UTF8String], 0, 16) & 0xff;
    }
    
    NSData *data = [NSData dataWithBytes:bytes length:length];
    return data;
    
}

/**
 将Long变成NSData（length个字节）
 
 @param value 整数
 @param length 字节长度
 @return NSData
 */
+ (NSData *)dataWithLong:(long)value length:(int)length {
    Byte *bot = malloc(length);
    for (int i = 0; i < length; i ++) {
        if (i == length - 1) {
            bot[i] = (Byte) (value & 0xff);
        } else {
            bot[i] = (Byte) ((value >> ((length-i-1)*8)) & 0xff);
        }
    }
    return [NSData dataWithBytes:bot length:length];
}

/**
 将NSData转换成Long <<正数>>
 
 @param data NSData
 @return <<正数>>long
 */
+ (long)positiveLongWithData:(NSData *)data {
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for (int m = 0; m < data.length; m++) {
        [str appendString:[self hexStringWithData:[data subdataWithRange:NSMakeRange(m, 1)]]];
    }
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanHexLongLong:&result];
    
    return result;
}

/**
 将NSData转换成Long <<可为负数>>
 
 @param data NSData
 @return <<可为负数>>long
 */
+ (long)longWithData:(NSData *)data {
    long total = 0;
    for (int i = 0; i < data.length; i ++) {
        if (i == data.length-1) {
            int a = (int)[self positiveLongWithData:[data subdataWithRange:NSMakeRange(i, 1)]];
            total += a;
        } else {
            int a = (int)[self positiveLongWithData:[data subdataWithRange:NSMakeRange(i, 1)]];
            total += a << ((data.length-i-1)*8);
        }
    }
    return total;
}

/**
 将 16进制字符串 转换为 10进制Long <<可为负数>>
 
 @param hexString 16进制字符串
 @return <<可为负数>>10进制Long
 */
+ (long)longWithHexString:(NSString *)hexString {
    NSData *data = [self dataWithHexString:hexString];
    return [self longWithData:data];
}

#pragma -mark 校验和

/**
 校验和算法
 
 @param originData 原始Data
 @return NSData校验和
 */
+ (NSData *)checksumDataWithOriginData:(NSData *)originData {
    Byte *byteData = (Byte *)malloc(originData.length);
    memcpy(byteData, [originData bytes], originData.length);
    int sum = [self checksumWithBytes:byteData startIndex:0 endIndex:(int)originData.length];
    Byte sumBytes[] = {(Byte)(sum & 0xff)};
    NSData *newData = [NSData dataWithBytes:sumBytes length:1];
    return newData;
}

/**
 校验和算法 取反+1
 
 @param originData 原始Data
 @return NSData校验和
 */
+ (NSData *)checkNegationGalOneSumDataWithOriginData:(NSData *)originData {
    Byte *byteData = (Byte *)malloc(originData.length);
    memcpy(byteData, [originData bytes], originData.length);
    int sum = [self checksumWithBytes:byteData startIndex:0 endIndex:(int)originData.length];
    Byte b1 = (Byte)(sum & 0xff);
    Byte b2 = (Byte)(0xFF - b1 + 1);
    Byte sumBytes[] = {b2};
    NSData *newData = [NSData dataWithBytes:sumBytes length:1];
    return newData;
}

/**
 校验和算法
 
 @param bytes 帧bytes
 @param startIndex 开始下标
 @param endIndex 结束下标
 @return Int
 */
+ (int)checksumWithBytes:(Byte[])bytes startIndex:(int)startIndex endIndex:(int)endIndex {
    int i;
    int temp = 0;
    for (i = startIndex; i < endIndex; i++) {
        int aa = (int)(bytes[i] & 0xff);
        temp += aa;
        //NSLog(@"===%d",temp);
    }
    return temp;
}

#pragma -mark hex & Data otherMethods

/**
 8字节十六进制随机串
 
 @return NSString
 */
+ (NSString *)randomHex8 {
    
    NSMutableString *randomStr = [[NSMutableString alloc] init];
    
    Byte *bytes = malloc(8);
    
    for (int i = 0; i < 8; i ++) {
        int random = arc4random()%256;
        
        bytes[i] = random & 0xff;
        
        NSString *sixTeenRandom = [NSString stringWithFormat:@"%x",(bytes[i] & 0xff)];
        //补0
        if (sixTeenRandom.length == 1) {
            [randomStr appendString:@"0"];
        }
        [randomStr appendString:sixTeenRandom];
    }
    
    return randomStr;
    
}

/**
 反向NSData <<如：11223344 -> 44332211>>
 
 @param originData 原始NSData
 @return 反向NSData
 */
+ (NSData *)reverseDataWithOriginData:(NSData *)originData {
    
    NSString *dataStr = [self hexStringWithData:originData];
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (long i = dataStr.length; i >= 2; i -= 2) {
        [resultStr appendString:[dataStr substringWithRange:NSMakeRange(i-2, 2)]];
    }
    return [self dataWithHexString:resultStr];
}

/**
 四元数组 <<四个字符串一组>>
 
 @param originString 原始字符串
 @return 四元数组<<四个字符串一组>>
 */
+ (NSArray *)fourStringArrayWithOriginString:(NSString *)originString {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < originString.length; i+=4) {
        [array addObject:[originString substringWithRange:NSMakeRange(i, 4)]];
    }
    return array;
}

#pragma -mark utf8
/**
 data转UTF8String
 
 @param data NSData
 @return UTF8String
 */
+ (NSString *)UTF8StringWithData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = [[NSString alloc] initWithData:[self UTF8DataWithOriginData:data] encoding:NSUTF8StringEncoding];
    }
    return string;
}

+ (NSData *)UTF8DataWithOriginData:(NSData *)originData {
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:originData.length];
    
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = originData.bytes;
    
    long dataLength = (long) originData.length;
    
    while (index < dataLength) {
        uint8_t len = 0;
        uint8_t firstChar = bytes[index];
        
        // 1个字节
        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
            len = 1;
        }
        // 2字节
        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
            if (index + 1 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                if (0x80 <= secondChar && secondChar <= 0xBF) {
                    len = 2;
                }
            }
        }
        // 3字节
        else if ((firstChar & 0xF0) == 0xE0) {
            if (index + 2 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                
                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                }
            }
        }
        // 4字节
        else if ((firstChar & 0xF8) == 0xF0) {
            if (index + 3 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                uint8_t fourthChar = bytes[index + 3];
                
                if (firstChar == 0xF0) {
                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if (firstChar == 0xF3) {
                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                }
            }
        }
        // 5个字节
        else if ((firstChar & 0xFC) == 0xF8) {
            len = 0;
        }
        // 6个字节
        else if ((firstChar & 0xFE) == 0xFC) {
            len = 0;
        }
        
        if (len == 0) {
            index++;
            [resData appendData:replacement];
        } else {
            [resData appendBytes:bytes + index length:len];
            index += len;
        }
    }
    
    return resData;
}

/**
 string转UTF8Data

 @param string NSString
 @return UTF8Data
 */
+ (NSData *)UTF8DataWithString:(NSString *)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

@end
