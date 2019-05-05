//
//  XTUtils+UIKit.m
//  XTComponentUtils
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+UIKit.h"

@implementation XTUtils (UIKit)

/**
 获取自适应size
 
 @param size size
 @param font font
 @param text text
 @return 适应的size
 */
+ (CGSize)sizeThatFits:(CGSize)size font:(UIFont *)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.numberOfLines = 0;
    label.text = text;
    return [label sizeThatFits:size];
}

/**
 绘制虚线

 @param lineView 绘制视图
 @param lineViewSize 视图的宽高
 @param lineLength 虚线宽
 @param lineSpacing 虚线间距
 @param lineColor 虚线颜色
 */
+ (void)drawDashLine:(UIView *)lineView lineViewSize:(CGSize)lineViewSize lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, lineViewSize.width, lineViewSize.height)];
    [shapeLayer setPosition:CGPointMake(lineViewSize.width / 2, lineViewSize.height / 2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:MIN(lineViewSize.height, lineViewSize.width)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (lineViewSize.width > lineViewSize.height) {
        CGPathAddLineToPoint(path, NULL, lineViewSize.width, 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, lineViewSize.height);
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


@end
