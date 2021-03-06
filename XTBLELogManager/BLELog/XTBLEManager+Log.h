//
//  XTBLEManager+Log.h
//  XTComponentBLE
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 新天科技股份有限公司. All rights reserved.
//

#import "XTBLEManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTBLEManager (Log)

@property (nonatomic, strong, readonly) NSString *methodName;   //方法名
@property (nonatomic, strong, readonly) NSString *startFileter; //开头过滤条件
@property (nonatomic, strong, readonly) NSString *endFilter;    //结尾过滤条件

/**
 在请求方法中添加该函数

 @param method 方法名
 @param startFilter 开头过滤条件
 @param endFileter 结尾过滤条件
 */
- (void)log_method:(NSString *)method startFilter:(NSString *)startFilter endFilter:(NSString *)endFileter;

/**
 自定义日志
 
 @param custom 自定义日志字符串
 */
- (void)log_custom:(NSString *)custom;

/**
 获取日志列表
 
 @param months 月份 例：@[@"2019-02", @"2019-03", @"2019-04" ...]
 @return 日志列表
 */
- (NSArray *)getFileListWithMonths:(NSArray <NSString *>*)months;

/**
 获取日志文件
 
 @param day 日期 yyyy-MM-dd
 @param password 密码
 @return 日志字符串
 */
- (NSString *)getFileWithDay:(NSString *)day password:(NSString *__nullable)password;

/**
 获取带颜色的日志文件
 
 @param day 日期 yyyy-MM-dd
 @param password 密码
 @return 日志字符串
 */
- (NSAttributedString *)getColorFileWithDay:(NSString *)day password:(NSString *__nullable)password;

/**
 删除某一天的蓝牙日志
 
 @param day 天
 @param password 密码
 @param error 错误
 */
- (void)deleteBLELogWithDay:(NSString *)day password:(NSString *__nullable)password error:(NSError **)error ;

/**
 删除所有蓝牙日志
 
 @param password 密码
 @param error 错误
 */
- (void)deleteAllBLELogWithPassword:(NSString *__nullable)password error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
