//
//  CGCalendarView.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCalendarWeekView.h"
#import "CGCalendarPicker.h"

typedef CF_ENUM(NSInteger, CGCalendarViewHeadStyle) {
    CGCalendarViewHeadStyleCurrentMonth = 0,    // Show current month of the first day.
    CGCalendarViewHeadStyleCurrentWeek,        // Show current week of the first day, the days before current will hiden.
};

@protocol CGCalendarDataSource, CGCalendarDelegate;

@interface CGCalendarView : UIView

@property (nonatomic, weak) id<CGCalendarDataSource> dataSource;
@property (nonatomic, weak) id<CGCalendarDelegate> delegate;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) NSDate *defaultEffectScrollDate;
@property (nonatomic, strong) CGCalendarWeekView *weekView;
@property (nonatomic, assign) CGSelectionMode selectionMode; // 选取模式(单个/区间)

@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, assign) CGCalendarViewHeadStyle headStyle;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat weekViewHeight;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign, readonly) CGSize contentSize;

- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)registerSectionHeader:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)registerSectionFooter:(id)clazz withReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
- (id)cellAtDate:(NSDate *)date;
- (void)reloadItemsAtDates:(NSSet<NSDate *> *)dates;
- (void)reloadItemsAtMonths:(NSSet<NSDate *> *)months;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollToSlectedMonthOrCurrentMonthSectionWithAnimated: (BOOL )animated;

@end


@protocol CGCalendarDataSource <NSObject>

@required
/**
 *  配置cell
 *
 *
 *  @param calendarView  self
 *  @param cell          current reuse cell
 *  @param date          current date
 */
- (void)calendarView:(CGCalendarView *)calendarView configureCell:(id)cell forDate:(NSDate *)date;

@optional
/**
 *  配置headerView
 *
 *  @param calendarView self
 *  @param headerView   current reuse section header or footer view
 *  @param firstDateOfMonth & lastDateOfMonth
 */
- (void)calendarView:(CGCalendarView *)calendarView configureSectionHeaderView:(id)headerView firstDateOfMonth:(NSDate *)firstDateOfMonth;
- (void)calendarView:(CGCalendarView *)calendarView configureSectionFooterView:(id)headerView lastDateOfMonth:(NSDate *)lastDateOfMonth;

/**
 *  返回weekView
 *
 *  @param calendarView self
 *  @param dayLabel     week day label
 *  @param weekDay      current week day
 */
- (void)calendarView:(CGCalendarView *)calendarView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay;
@end

@protocol CGCalendarDelegate <NSObject>

@optional
/**
 *  是否可以选中
 *
 *  @param calendarView self
 *  @param date         current date
 *
 *  @return selectable of the calendarView cell
 */
- (BOOL)calendarView:(CGCalendarView *)calendarView shouldSelectDate:(NSDate *)date;

/**
 *  选中某个日期
 *
 *  @param calendarView self
 *  @param date         current date
 */
- (void)calendarView:(CGCalendarView *)calendarView didSelectDate:(NSDate *)date ofCell:(id)cell;

/**
 *  ScrollView滑动方法
 *
 *  @param scrollView UICollectionView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
