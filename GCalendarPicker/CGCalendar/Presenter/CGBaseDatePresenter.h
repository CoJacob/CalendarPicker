//
//  CGBaseDatePresenter.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGCalendar.h"

@interface CGBaseDatePresenter : NSObject

@property (nonatomic, strong) CGCalendarView *calendarView;

- (void)setUpCalendarView;
- (void)clearSelectedDate;

@end
