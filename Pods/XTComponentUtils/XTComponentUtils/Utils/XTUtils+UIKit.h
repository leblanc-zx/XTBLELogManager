//
//  XTUtils+UIKit.h
//  XTComponentUtils
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XTUtils (UIKit)

/**
 获取自适应size

 @param size size
 @param font font
 @param text text
 @return 适应的size
 */
+ (CGSize)sizeThatFits:(CGSize)size font:(UIFont *)font text:(NSString *)text;

/**
 绘制虚线
 
 @param lineView 绘制视图
 @param lineViewSize 视图的宽高
 @param lineLength 虚线宽
 @param lineSpacing 虚线间距
 @param lineColor 虚线颜色
 */
+ (void)drawDashLine:(UIView *)lineView lineViewSize:(CGSize)lineViewSize lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end

NS_ASSUME_NONNULL_END
