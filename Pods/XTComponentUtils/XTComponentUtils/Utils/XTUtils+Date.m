//
//  XTUtils+Date.m
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+Date.h"

@implementation XTUtils (Date)

/**
 根据时间字符串获取date
 
 @param timeString 时间字符串
 @param formatter 时间格式
 @return NSDate
 */
+ (NSDate *)dateFromTimeString:(NSString *)timeString formatter:(NSString *)formatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *date = [dateformatter dateFromString:timeString];
    return date;
}

/**
 根据date获取时间字符串
 
 @param date NSDate
 @param formatter 时间格式
 @return 时间字符串
 */
+ (NSString *)timeStringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *timeStr = [dateformatter stringFromDate:date];
    return timeStr;
}

/**
 计算两个日期时间间隔 <<秒>>
 
 @param sinceTime 开始时间字符串
 @param toTime 结束时间字符串
 @param formatter 时间格式
 @return 时间间隔<<秒>>
 */
+ (long long)timeIntervalSinceTime:(NSString *)sinceTime toTime:(NSString *)toTime formatter:(NSString *)formatter {
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:formatter];
    NSDate *sinceDate = [dateFormate dateFromString:sinceTime];
    NSDate *toDate = [dateFormate dateFromString:toTime];
    long long time = (long long)[toDate timeIntervalSinceDate:sinceDate];
    return time;
}

/**
 计算两个日期时间间隔 <<秒>>
 
 @param sinceDate 开始时间Date
 @param toDate 结束时间Date
 @return 时间间隔<<秒>>
 */
+ (long long)timeIntervalSinceDate:(NSDate *)sinceDate toDate:(NSDate *)toDate {
    long long time = (long long)[toDate timeIntervalSinceDate:sinceDate];
    return time;
}

/**
 获取最新时间 = 时间间隔 + 开始时间
 
 @param timeInterval 时间间隔
 @param sinceTime 开始时间字符串
 @param formatter 时间格式
 @return 新时间字符串
 */
+ (NSString *)timeStringWithTimeInterval:(long long)timeInterval sinceTime:(NSString *)sinceTime formatter:(NSString *)formatter {
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:formatter];
    NSDate *sinceDate = [dateFormate dateFromString:sinceTime];
    NSDate *newDate = [sinceDate dateByAddingTimeInterval:timeInterval];
    return [dateFormate stringFromDate:newDate];
}

/**
 获取最新时间 = 时间间隔 + 1970年开始

 @param timeInterval 时间间隔
 @param formatter 时间格式
 @return 新时间字符串
 */
+ (NSString *)timeStringWithTimeIntervalSince1970:(long long)timeInterval formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:formatter];
    NSString *timeStr = [dateFormate stringFromDate:date];
    return timeStr;
}


/**
 获取某月月初&月末

 @param monthBegin 月初
 @param monthEnd 月末
 @param date 某月date
 */
+ (void)monthBegin:(NSDate **)monthBegin monthEnd:(NSDate **)monthEnd forDate:(NSDate *)date {
    
    NSDate *newDate = date;
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        *monthEnd = [beginDate dateByAddingTimeInterval:interval-1];
    } else {
        
    }
    *monthBegin = beginDate;
    
}

/**
 获取某日期的后几个月的日期

 @param month 月数
 @param date 某日期
 @return 结果日期
 */
+ (NSDate *)dateAfterMonth:(int)month forDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterMonth;
}

@end
