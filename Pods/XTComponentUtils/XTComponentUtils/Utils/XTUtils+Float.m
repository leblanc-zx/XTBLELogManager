//
//  XTUtils+Float.m
//  XTComponentUtils
//
//  Created by apple on 2019/2/27.
//  Copyright © 2019年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+Float.h"

@implementation XTUtils (Float)

/**
 去除无效小数点

 @param f 小数
 @return 去除无效小数点后的字符串
 */
+ (NSString *)stringWithOutInvalidDecimal:(float)f {
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

@end
