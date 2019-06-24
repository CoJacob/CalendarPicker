# CalendarPicker
一款轻量级的日历选择器(iOS Objective-C)
A lightweight calendar Picker for the iOS platform


# Usage

1. create picker _calendarPicker = [[CGCalendarPicker alloc] initWithFrame:CGRectMake(0, 0, width,height)];
2. set mode      _calendarPicker.selectionMode = CGSelectionModeRange;
3. show            [self.calendarPicker showInView:self.view];
4. callback 
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
@param endDate 介绍时间
*/
- (void)calendarPicker:(CGCalendarPicker *)picker didSelectedRangeModeDateWithStartDate: (NSDate *)startDate endDate: (NSDate *)endDate;

@end


# Preview

![img](https://github.com/Winerywine/CalendarPicker/blob/master/Calendar_record.gif)
