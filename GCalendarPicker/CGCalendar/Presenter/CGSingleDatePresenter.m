//
//  CGSingleDatePresenter.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGSingleDatePresenter.h"
#import "CGSingleDateCollectionViewCell.h"
#import "CGDateHeaderView.h"


@interface CGSingleDatePresenter () <CGCalendarDataSource, CGCalendarDelegate>

@end

@implementation CGSingleDatePresenter

- (void)setUpCalendarView {
    [super setUpCalendarView];
    self.calendarView.delegate   = self;
    self.calendarView.dataSource = self;
    [self.calendarView registerCellClass:[CGSingleDateCollectionViewCell class] withReuseIdentifier:@"singleCell"];
    self.selectedDate = nil;
    {
        
    }
    [self.calendarView reloadData];
}

#pragma mark - Setter

//- (void)setDisableSelectDateArray:(NSMutableArray *)disableSelectDateArray {
//    _disableSelectDateArray = disableSelectDateArray;
//}

#pragma mark - Public

- (void)clearSelectedDate {
    self.selectedDate = nil;
    [self.calendarView reloadData];
}


#pragma mark - CGCalendarDataSource
- (void)calendarView:(CGCalendarView *)calendarView configureCell:(CGSingleDateCollectionViewCell *)cell forDate:(NSDate *)date {
    cell.date = date;
    if (date) {
        if ([cell.date compare:self.calendarView.firstDate] == NSOrderedAscending || [cell.date compare:self.calendarView.lastDate] == NSOrderedDescending || [self.disableSelectDateArray containsObject:cell.date]) {
            cell.cellState = CGCalendarCellStateDisable;
        }else if ([date isEqualToDate:self.selectedDate]) {
            cell.cellState = CGCalendarCellStateSelected;
        }else {
            cell.cellState = CGCalendarCellStateNormal;
        }
    } else {
        cell.cellState = CGCalendarCellStateEmpty;
    }
}

- (void)calendarView:(CGCalendarView *)calendarView configureSectionHeaderView:(CGDateHeaderView *)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth {
    headerView.firstDateOfMonth = firstDateOfMonth;
}

- (void)calendarView:(CGCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay
{
//    dayLabel.font = [UIFont systemFontOfSize:13];
//    if (weekDay == 0 || weekDay == 6)
//    {
//        dayLabel.textColor = [UIColor lightGrayColor];
//    }
}

#pragma mark - CGCalendarDelegate
- (void)calendarView:(CGCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(CGSingleDateCollectionViewCell *)cell
{
    if (!date || cell.cellState == CGCalendarCellStateDisable)
    {
        return;
    }
    NSDate *oldDate = [self.selectedDate copy];
    self.selectedDate = date;
    cell.cellState = CGCalendarCellStateSelected;
    [calendarView reloadItemsAtDates:[NSMutableSet setWithObjects:oldDate, self.selectedDate, nil]];
    if (self.selectDateHandle)
    {
        self.selectDateHandle(self.selectedDate);
    }
}

@end
