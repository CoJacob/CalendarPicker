//
//  CGSingleDateCollectionViewCell.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CF_ENUM(NSInteger, CGCalendarCellState) {
    CGCalendarCellStateEmpty,
    CGCalendarCellStateNormal,
    CGCalendarCellStateDisable,
    CGCalendarCellStateSelected,
};

@interface CGSingleDateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGCalendarCellState cellState;

@end
