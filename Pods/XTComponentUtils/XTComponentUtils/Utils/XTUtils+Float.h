//
//  XTUtils+Float.h
//  XTComponentUtils
//
//  Created by apple on 2019/2/27.
//  Copyright © 2019年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (Float)

/**
 去除无效小数点
 
 @param f 小数
 @return 去除无效小数点后的字符串
 */
+ (NSString *)stringWithOutInvalidDecimal:(float)f;

@end

NS_ASSUME_NONNULL_END
