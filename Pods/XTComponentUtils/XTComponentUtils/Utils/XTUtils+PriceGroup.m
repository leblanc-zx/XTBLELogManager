//
//  XTUtils+PriceGroup.m
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+PriceGroup.h"

@implementation XTUtils (PriceGroup)

/**
 价格组信息<<4阶5价>>
 
 @param priceGroupData 价格组Data
 @return 价格组信息<<4阶5价>>
 */
+ (XTPriceGroupInfo *)xtPriceGroupInfoWithPriceGroupData:(NSData *)priceGroupData {
    
    XTPriceGroupInfo *xtPriceGroupInfo = [[XTPriceGroupInfo alloc] init];
    long price1 = [self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(0, 2)]];
    xtPriceGroupInfo.price1 = price1;
    long devideCount1 = (int)[self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(2, 3)]];
    xtPriceGroupInfo.devideCount1 = devideCount1;
    long price2 = [self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(5, 2)]];
    xtPriceGroupInfo.price2 = price2;
    long devideCount2 = (int)[self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(7, 3)]];
    xtPriceGroupInfo.devideCount2 = devideCount2;
    long price3 = [self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(10, 2)]];
    xtPriceGroupInfo.price3 = price3;
    long devideCount3 = (int)[self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(12, 3)]];
    xtPriceGroupInfo.devideCount3 = devideCount3;
    long price4 = [self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(15, 2)]];
    xtPriceGroupInfo.price4 = price4;
    long devideCount4 = (int)[self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(17, 3)]];
    xtPriceGroupInfo.devideCount4 = devideCount4;
    long price5 = [self positiveLongWithData:[priceGroupData subdataWithRange:NSMakeRange(20, 2)]];
    xtPriceGroupInfo.price5 = price5;
    return xtPriceGroupInfo;
}

/**
 价格组字符串<<16进制>>
 
 @param priceString 价格：0.010000;1;0.010000;2;0.010000;3;0.010000;4;0.010000
 @return 价格组字符串<<16进制>>：00010000010001000002000100000300010000040001
 */
+ (NSString *)priceGroupHexStringWithPriceString:(NSString *)priceString {
    NSArray *priceArray = [priceString componentsSeparatedByString:@";"];
    NSString *hexPrice1 = [self getPriceHex:priceArray[0]];
    NSString *hexDevideCount1 = [self getDevideCountHex:priceArray[1]];
    NSString *hexPrice2 = [self getPriceHex:priceArray[2]];
    NSString *hexDevideCount2 = [self getDevideCountHex:priceArray[3]];
    NSString *hexPrice3 = [self getPriceHex:priceArray[4]];
    NSString *hexDevideCount3 = [self getDevideCountHex:priceArray[5]];
    NSString *hexPrice4 = [self getPriceHex:priceArray[6]];
    NSString *hexDevideCount4 = [self getDevideCountHex:priceArray[7]];
    NSString *hexPrice5 = [self getPriceHex:priceArray[8]];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",hexPrice1,hexDevideCount1,hexPrice2,hexDevideCount2,hexPrice3,hexDevideCount3,hexPrice4,hexDevideCount4,hexPrice5];
}

//0.01 -> 0001
+ (NSString *)getPriceHex:(NSString *)dotPrice {
    long lprice = [dotPrice doubleValue] * 100;
    NSData *dprice = [XTUtils dataWithLong:lprice length:2];
    NSString *hexprice = [XTUtils hexStringWithData:dprice];
    return hexprice;
}

//1 -> 000001
+ (NSString *)getDevideCountHex:(NSString *)devideCount {
    long ldevideCount = [devideCount longLongValue];
    NSData *ddevideCount = [XTUtils dataWithLong:ldevideCount length:3];
    NSString *hexdevideCount = [XTUtils hexStringWithData:ddevideCount];
    return hexdevideCount;
}

/**
 价格启用循环<<16进制>>
 
 @param priceStartString 价格启用：1&1&1;2&1&1;3&1&1;4&18&2;5&1&1;6&1&1;7&1&1;8&1&1;9&1&1;10&1&1;11&1&1;12&1&1
 @return 价格启用循环<<16进制>>：
 */
+ (NSString *)priceStartRepeatHexStringWithPriceStartString:(NSString *)priceStartString {
    
    NSArray *priceArray = [priceStartString componentsSeparatedByString:@";"];
    NSMutableString *hex = [[NSMutableString alloc] init];
    for (int i = 0; i < priceArray.count; i ++) {
        NSString *tempHexStr = priceArray[i];
        NSArray *tempHexArray = [tempHexStr componentsSeparatedByString:@"&"];
        //月
        NSString *monthHex = [[XTUtils hexStringWithData:[XTUtils dataWithLong:[tempHexArray[0] longLongValue] length:1]] substringWithRange:NSMakeRange(1, 1)];
        //日
        NSString *dayHex = [XTUtils hexStringWithData:[XTUtils dataWithLong:[tempHexArray[1] longLongValue] length:1]];
        //价格编号
        NSString *priceNumHex = [[XTUtils hexStringWithData:[XTUtils dataWithLong:[tempHexArray[2] longLongValue] length:1]] substringWithRange:NSMakeRange(1, 1)];
        //生成
        NSString *hexStr = [NSString stringWithFormat:@"%@%@%@",monthHex,priceNumHex,dayHex];
        [hex appendString:hexStr];
    }
    
    return hex;
}


@end
