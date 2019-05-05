//
//  XTUtils+DES.h
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (DES)

/**
 获取密文口令
 
 @param command 明文
 @param random 随机数
 @return 密文
 */
+ (NSString *)desWithCommand:(NSString *)command random:(NSString *)random;

@end

NS_ASSUME_NONNULL_END
