//
//  GRangeDatePresenter.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGRangeDatePresenter.h"
#import "CGRangeDateCollectionViewCell.h"
#import "CGDateHeaderView.h"

typedef CF_ENUM(NSInteger, CGCalendarSelectedState) {
    CGCalendarStateSelectedNone,
    CGCalendarStateSelectedStart,
    CGCalendarStateSelectedRange,
};

@interface CGRangeDatePresenter () <CGCalendarDataSource, CGCalendarDelegate>

//@property (nonatomic, assign) CGCalendarSelectedState selectedState;

@end

@implementation CGRangeDatePresenter

- (void)setUpCalendarView {
    [super setUpCalendarView];
    self.calendarView.delegate   = self;
    self.calendarView.dataSource = self;
    [self.calendarView registerCellClass:[CGRangeDateCollectionViewCell class] withReuseIdentifier:@"cell"];
    self.startDate = nil;
    self.endDate = nil;
    [self.calendarView reloadData];
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    [self.calendarView reloadData];
}

#pragma mark - Public

- (void)clearSelectedDate {
    self.startDate = nil;
    self.endDate   = nil;
    [self.calendarView reloadData];
}

- (void)updateSelectRangeDateStatus {
    self.isChoosedRangeDate = (self.startDate && self.endDate);
}

#pragma mark - CGCalendarDataSource
- (void)calendarView:(CGCalendarView *)calendarView configureCell:(CGRangeDateCollectionViewCell *)cell forDate:(NSDate *)date {
    CGRangeCalendarCellState cellState = CGRangeCalendarCellStateAvaible;
    cell.date = date;
    if (date)
    {
        if ([cell.date compare:self.calendarView.firstDate] == NSOrderedAscending || [cell.date compare:self.calendarView.lastDate] == NSOrderedDescending)
        {
            cellState = CGRangeCalendarCellStateDisabled;
        }else if (self.startDate && self.endDate && [[date dateByAddingTimeInterval:86400.0 - 1] compare:self.endDate] == NSOrderedAscending && [date compare:self.startDate] == NSOrderedDescending)
        {
            // 判断是否为Middle
            cellState = CGRangeCalendarCellStateSelectedMiddle;
        }else if (cell.date == self.startDate && self.startDate)
        {
            cellState = CGRangeCalendarCellStateSelectedStart;
        }else if (cell.date == self.endDate && self.endDate)
        {
            cellState = CGRangeCalendarCellStateSelectedEnd;
        }
    }else
    {
        cell.cellState = CGRangeCalendarCellStateEmpty;
    }
    
    cell.cellState = cellState;
    cell.isChoosedRangeDate = self.isChoosedRangeDate;
}

- (void)calendarView:(CGCalendarView *)calendarView configureSectionHeaderView:(CGDateHeaderView *)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth {
    headerView.firstDateOfMonth = firstDateOfMonth;
}

- (void)calendarView:(CGCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay {
    dayLabel.font = [UIFont systemFontOfSize:13];
    if (weekDay == 0 || weekDay == 6) {
        dayLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - CGCalendarDelegate
- (void)calendarView:(CGCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(CGRangeDateCollectionViewCell *)cell {
    if (!date || cell.cellState == CGRangeCalendarCellStateDisabled)
    {
        return;
    }
    if (!self.startDate && !self.endDate)
    {
        // 都未选中
        self.startDate = date;
        cell.cellState = CGRangeCalendarCellStateSelectedStart;
    }else if (self.startDate && !self.endDate)
    {
        // 未选中结束时间
        if ([[date dateByAddingTimeInterval:86400.0 - 1] compare:self.startDate] == NSOrderedDescending || date == self.startDate)
        {
            self.endDate = date;
            cell.cellState = CGRangeCalendarCellStateSelectedEnd;
        }else
        {
            self.startDate = date;
            cell.cellState = CGRangeCalendarCellStateSelectedStart;
        }
    }else if (self.endDate && !self.startDate)
    {
        // 未选中开始时间
        if (date == self.endDate || [date compare:self.endDate] == NSOrderedAscending)
        {
            self.startDate = date;
            cell.cellState = CGRangeCalendarCellStateSelectedStart;
        }else if ([date compare:self.endDate] == NSOrderedDescending)
        {
            self.startDate = date;
            cell.cellState = CGRangeCalendarCellStateSelectedStart;
            self.endDate   = nil;
        }
    }else if (self.startDate && self.endDate)
    {
        self.endDate = nil;
        self.startDate = date;
        cell.cellState = CGRangeCalendarCellStateSelectedStart;
    }
    self.isChoosedRangeDate = (self.startDate && self.endDate);
    [calendarView reloadData];
    if (self.selectDateHandle)
    {
        self.selectDateHandle(self.startDate, self.endDate);
    }
}



@end
