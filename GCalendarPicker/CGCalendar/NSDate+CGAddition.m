//
//  NSDate+CGAddition.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "NSDate+CGAddition.h"
#import <objc/runtime.h>

const char * const GuoCalendarStoreKey = "guo.calendar";
const char * const GuoLocaleStoreKey = "guo.locale";

@implementation NSDate (CGAddition)

#pragma mark -
+ (void)setGregorianCalendar:(NSCalendar *)gregorianCalendar
{
    objc_setAssociatedObject(self, GuoCalendarStoreKey, gregorianCalendar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSCalendar *)gregorianCalendar
{
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    return cal;
}

+ (void)setLocal:(NSLocale *)locale
{
    objc_setAssociatedObject(self, GuoLocaleStoreKey, locale, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//+ (NSLocale *)locale
//{
//    NSLocale *locale  = objc_getAssociatedObject(self, GuoLocaleStoreKey);
//    if (nil == locale) {
//        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        [self setLocal:locale];
//    }
//    return locale;
//}

//+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
//{
//    if (anyDate) {
//        //设置源日期时区
//        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//        //设置转换后的目标日期时区
//        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
//        //得到源日期与世界标准时间的偏移量
//        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
//        //目标日期与本地时区的偏移量
//        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
//        //得到时间偏移量的差值
//        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//        //转为现在时间
//        NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
//        return destinationDateNow;
//    }else {
//        return anyDate;
//    }
//}

#pragma mark -
+ (NSDate *)today {
    NSDate *sourceDate = [NSDate date];
    
    NSTimeZone *sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return date;
}

+ (NSInteger)numberOfMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[fromDate firstDateOfMonth] toDate:[toDate lastDateOfMonth] options:NSCalendarMatchStrictly];
    return components.month + 1;
}

+ (NSInteger)numberOfDaysFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDate *firstDate = [fromMonth firstDateOfMonth];
    NSDate *lastDate = [toMonth lastDateOfMonth];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:firstDate toDate:lastDate options:NSCalendarMatchStrictly];
    return components.day + 1;
}

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date {
    NSCalendar *calendar = [self gregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSInteger)numberOfNightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlag = NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlag fromDate:fromDate toDate:toDate options:0];
    NSInteger days = [components day];
    return days;
}

+ (NSInteger)monthCountFromPreviousDate: (NSDate *)fromDate toDate: (NSDate *)toDate {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[fromDate firstDateOfMonth] toDate:toDate options:NSCalendarMatchStrictly];
    return components.month;
}

+ (NSDate *)zeroDateFormDate: (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [dateFormatter dateFromString:dateString];
}

#pragma mark -
- (NSDate *)firstDateOfMonth {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (NSDate *)firstDateOfWeek {
    
    NSInteger weekDay = self.weekday;
    
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    components.day = components.day - weekDay + 1;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (NSDate *)lastDateOfMonth {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.month = components.month + 1;
    components.day = 0;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (NSInteger)weekday {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *compoents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return compoents.weekday;
}

- (BOOL)isToday {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *otherDay = [calendar components:NSCalendarUnitEra | NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWeekend {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSUInteger weekdayOfDate = [components weekday];
    
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
        return YES;
    }
    return NO;
}

- (BOOL)isSameMonthWithDate:(NSDate *)date {
    NSCalendar *calendar = [self.class gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSDateComponents *toComponents = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    return components.month == toComponents.month;
}


@end
