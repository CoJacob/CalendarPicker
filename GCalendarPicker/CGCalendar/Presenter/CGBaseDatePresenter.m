//
//  CGBaseDatePresenter.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGBaseDatePresenter.h"

@implementation CGBaseDatePresenter

- (void)setCalendarView:(CGCalendarView *)calendarView {
    _calendarView = calendarView;
    [self setUpCalendarView];
}

- (void)setUpCalendarView {
//    // 获取当前日期
//    NSDate *today = [NSDate today];
//    // 获取12个月后的最后一天
//    NSCalendar *calendar = [NSDate gregorianCalendar];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
//    
//    NSDate *firstDate = [calendar dateFromComponents:components];
//    
//    components.month = components.month + 12;
//    components.day = 0;
//    NSDate *lastDate = [calendar dateFromComponents:components];
//
//    self.calendarView.firstDate = firstDate;
//    self.calendarView.lastDate = lastDate;
}

- (void)clearSelectedDate {
    
}

@end
