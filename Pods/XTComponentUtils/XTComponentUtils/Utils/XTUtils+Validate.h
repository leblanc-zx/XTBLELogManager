//
//  XTUtils+Validate.h
//  XTComponentUtils
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (Validate)

/**
 手机号验证
 
 @param mobile 手机号
 @return BOOL
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 验证身份证
 
 @param value 身份证号
 @return BOOL
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
