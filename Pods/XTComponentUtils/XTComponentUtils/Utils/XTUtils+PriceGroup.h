//
//  XTUtils+PriceGroup.h
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"
#import "XTPriceGroupInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (PriceGroup)

/**
 价格组信息<<4阶5价>>
 
 @param priceGroupData 价格组Data
 @return 价格组信息<<4阶5价>>
 */
+ (XTPriceGroupInfo *)xtPriceGroupInfoWithPriceGroupData:(NSData *)priceGroupData;

/**
 价格组字符串<<16进制>>
 
 @param priceString 价格：0.010000;1;0.010000;2;0.010000;3;0.010000;4;0.010000
 @return 价格组字符串<<16进制>>：00010000010001000002000100000300010000040001
 */
+ (NSString *)priceGroupHexStringWithPriceString:(NSString *)priceString;

/**
 价格启用循环<<16进制>>
 
 @param priceStartString 价格启用：1&1&1;2&1&1;3&1&1;4&18&2;5&1&1;6&1&1;7&1&1;8&1&1;9&1&1;10&1&1;11&1&1;12&1&1
 @return 价格启用循环<<16进制>>：110121013101421251016101710181019101a101b101c101
 */
+ (NSString *)priceStartRepeatHexStringWithPriceStartString:(NSString *)priceStartString;

@end

NS_ASSUME_NONNULL_END
