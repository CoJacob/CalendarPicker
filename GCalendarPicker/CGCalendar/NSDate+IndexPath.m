//
//  NSDate+IndexPath.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "NSDate+IndexPath.h"
#import <UIKit/UIKit.h>
#import "NSDate+CGAddition.h"

@implementation NSDate (IndexPath)

+ (NSDate *)dateForFirstDayInSection:(NSInteger)section firstDate:(NSDate *)firstDate {
    NSCalendar *calendar = [NSDate gregorianCalendar];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = section;
    NSDate *date = [calendar dateByAddingComponents:dateComponents toDate:[firstDate firstDateOfMonth] options:0];
//    NSDate *targetDate = [self getNowDateFromatAnDate:date];
    
    return date;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    if (anyDate) {
        //设置源日期时区
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
        //设置转换后的目标日期时区
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
        //得到源日期与世界标准时间的偏移量
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
        //目标日期与本地时区的偏移量
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
        //得到时间偏移量的差值
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        //转为现在时间
        NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
        return destinationDateNow;
    }else {
        return anyDate;
    }
}

+ (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath firstDate:(NSDate *)firstDate {
    NSDate *firstDay = [NSDate  dateForFirstDayInSection:indexPath.section firstDate:firstDate];
    NSInteger weekDay = [firstDay weekday];
    NSDate *dateToReturn = nil;
    
    if (indexPath.row < (weekDay - 1) || indexPath.row > weekDay - 1 + [NSDate numberOfDaysInMonth:firstDay] - 1) {
        dateToReturn = nil;
    } else {
        NSCalendar *calendar = [NSDate gregorianCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
        [components setDay:indexPath.row - (weekDay - 1)];
        [components setMonth:indexPath.section];
        dateToReturn = [calendar dateByAddingComponents:components toDate:[firstDate firstDateOfMonth] options:0];
    }
//    NSDate *targetDate = [self getNowDateFromatAnDate:dateToReturn];
    return dateToReturn;
}

+ (NSIndexPath *)indexPathAtDate:(NSDate *)date firstDate:(NSDate *)firstDate {
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *firstDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDate];
    
    NSDate *firstDateOfMonth = [date firstDateOfMonth];
    NSDateComponents *firstDateOfMonthComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDateOfMonth];
    
    NSInteger section = (components.year - firstDateComponents.year) * 12 + components.month - firstDateComponents.month;
    NSInteger index = firstDateOfMonthComponents.weekday + components.day - 2;
    
    return [NSIndexPath indexPathForItem:index inSection:section];
}


@end
