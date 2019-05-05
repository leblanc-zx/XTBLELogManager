//
//  XTUtils+Image.m
//  XTComponentUtils
//
//  Created by apple on 2019/2/27.
//  Copyright © 2019年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+Image.h"

@implementation XTUtils (Image)

/**
 压缩图片到指定文件大小

 @param image 目标图片
 @param size 目标大小（最大值
 @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


/**
 给图片添加文字水印

 @param originalImage 目标图片
 @param text 文字
 @param point 位置
 @param attributed 文字的样式
 @return 水印图片
 */
+ (UIImage *)waterImageWithOriginalImage:(UIImage *)originalImage text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed {
    return [self waterImageWithOriginalImage:originalImage toSize:CGSizeMake(originalImage.size.width, originalImage.size.height) text:text textPoint:point attributedString:attributed];
}

/**
 给图片添加文字水印
 
 @param originalImage 目标图片
 @param toSize 新图片尺寸
 @param text 文字
 @param point 位置
 @param attributed 文字的样式
 @return 水印图片
 */
+ (UIImage *)waterImageWithOriginalImage:(UIImage *)originalImage toSize:(CGSize)toSize text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(toSize, NO, 0);
    //2.绘制图片
    [originalImage drawInRect:CGRectMake(0, 0, toSize.width, toSize.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

@end
