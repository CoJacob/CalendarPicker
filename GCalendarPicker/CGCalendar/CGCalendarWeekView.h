//
//  CGCalendarWeekView.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CGCalendarWeekViewDelegate;


@interface CGCalendarWeekView : UIView

@property (nonatomic, weak) id<CGCalendarWeekViewDelegate> delegate;

/**
 *  The inner padding of week view.
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;   // the inner padding

/**
 *  Default line at the bottom of week view.
 */
@property (nonatomic, strong) CALayer *bottomLine;

/**
 *  reload week View manual
 */
- (void)reloadWeekView;

@end



@protocol CGCalendarWeekViewDelegate <NSObject>

@optional
/**
 *  用作工作日
 *
 *  @param weekView  self
 *  @param dayLabel  weekday label
 *  @param weekDay   integer of the weekday
 */
- (void)calendarWeekView:(CGCalendarWeekView *)weekView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay;

@end
