//
//  CGRangeDateCollectionViewCell.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 日期选中状态 */
typedef CF_ENUM(NSInteger, CGRangeCalendarCellState) {
    CGRangeCalendarCellStateEmpty,
    CGRangeCalendarCellStateDisabled,
    CGRangeCalendarCellStateAvaible,
    CGRangeCalendarCellStateSelectedStart,
    CGRangeCalendarCellStateSelectedMiddle,
    CGRangeCalendarCellStateSelectedEnd
};

@interface CGRangeDateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGRangeCalendarCellState cellState;
@property (nonatomic, assign) BOOL   isChoosedRangeDate;

@end
