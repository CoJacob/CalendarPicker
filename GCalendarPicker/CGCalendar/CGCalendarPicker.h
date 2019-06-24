//
//  CGCalendarPicker.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CF_ENUM(NSInteger, CGSelectionMode) {
    CGSelectionModeDisable = 0,     // Can not select
    CGSelectionModeSingle,          // Single selection mode
    CGSelectionModeRange,           // Range selection mode
};

@protocol CGCalendarPickerDelegate;

@interface CGCalendarPicker : UIView

@property (nonatomic, weak)   id<CGCalendarPickerDelegate>delegate;
@property (nonatomic )        CGFloat         originFameY;                         // 起始位置Y坐标
@property (nonatomic)         BOOL            matchBottomBarForIphoneX;            // 底栏适配iPhone X系列机型
@property (nonatomic, assign) CGSelectionMode selectionMode;                       // 选取模式
@property (nonatomic, strong) NSArray         *singleModeDisableSelectDateArray;   // DisableSlectDateArray in singleMode
@property (nonatomic, strong) NSDate          *firstDate;                          // 开始时间
@property (nonatomic, strong) NSDate          *lastDate;                           // 结束时间
@property (nonatomic, strong) NSDate          *defaultSelectDateInSingleMode;      // 默认选中的时间
@property (nonatomic, strong) NSDate          *defaultSlectEndDateInRangeMode;     // 默认选中的结束时间
@property (nonatomic, copy)   void(^closeCallback)(void);                          // 关闭回调block

/**
 弹窗日历面板

 @param superView superView
 */
- (void)showInView: (UIView *)superView;


/**
 关闭弹窗
 */
- (void)close;


/**
 动画滚动到当月或者选中日期对应的月份
 */
- (void)scrollToSlectedMonthOrCurrentMonthSection;

/* 是否正在在当前页面展示 */
- (BOOL)isShow;

- (void)showInView:(UIView *)superView  belowSubview:(UIView *)belowSubview;

@end


@protocol CGCalendarPickerDelegate <NSObject>

@optional

/**
 弹窗消失后选中了某个日期(单选模式)

 @param picker picker
 @param date 选中的日期
 */
- (void)calendarPicker: (CGCalendarPicker *)picker didSelectedSingleModeDate: (NSDate *)date;


/**
 弹窗消失后选中了某个日期(区间模式)

 @param picker picker
 @param startDate 开始时间
 @param endDate 结束时间
 */
- (void)calendarPicker:(CGCalendarPicker *)picker didSelectedRangeModeDateWithStartDate: (NSDate *)startDate endDate: (NSDate *)endDate;

@end


