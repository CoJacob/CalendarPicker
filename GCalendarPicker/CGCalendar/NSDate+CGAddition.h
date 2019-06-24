//
//  NSDate+CGAddition.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CGAddition)

+ (NSCalendar *)gregorianCalendar;
//+ (NSLocale *)locale;

+ (NSDate *)today;
+ (NSInteger)numberOfMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth;
+ (NSInteger)numberOfDaysInMonth:(NSDate *)date;
+ (NSInteger)numberOfNightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)monthCountFromPreviousDate: (NSDate *)fromDate toDate: (NSDate *)toDate;
+ (NSDate *)zeroDateFormDate: (NSDate *)date;

- (NSDate *)firstDateOfMonth;
- (NSDate *)firstDateOfWeek;
- (NSDate *)lastDateOfMonth;

- (NSInteger)weekday;

- (BOOL)isToday;
- (BOOL)isWeekend;

- (BOOL)isSameMonthWithDate:(NSDate *)date;

@end
