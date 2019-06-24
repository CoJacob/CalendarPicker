//
//  CGSingleDateCollectionViewCell.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGSingleDateCollectionViewCell.h"
#import "NSDate+CGAddition.h"

@interface CGSingleDateCollectionViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UILabel *todaySignLabel;

@end


@implementation CGSingleDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.todaySignLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    self.todaySignLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 15);
}


- (void)setDate:(NSDate *)date {
    _date = date;
    if (_date) {
        self.dateLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_date]];
    } else {
        self.dateLabel.text = nil;
    }
}

- (void)setCellState:(CGCalendarCellState)cellState {
    _cellState = cellState;
    self.dateLabel.font = [UIFont systemFontOfSize:15];
    switch (_cellState) {
        case CGCalendarCellStateEmpty: {
            self.dateLabel.text = nil;
            self.dateLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.00f];
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            break;
        }
        case CGCalendarCellStateNormal: {
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.00f];
            break;
        }
        case CGCalendarCellStateSelected: {
            self.dateLabel.backgroundColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
            self.dateLabel.layer.cornerRadius = 22.5f;
            if (@available(iOS 8.2, *)) {
                self.dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            }
            self.dateLabel.textColor = [UIColor whiteColor];
            break;
        }
        case CGCalendarCellStateDisable: {
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.textColor = [UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.00f];
            break;
        }
        default:
            break;
    }
    [self.todaySignLabel setHidden:![self.date isToday]];
    [self updateLabelColorIfIsTodayForCellStatus:_cellState];
    [self layoutSubviews];
}

- (void)updateLabelColorIfIsTodayForCellStatus: (CGCalendarCellState )cellStatus {
    if ([self.date isToday])
    {
        switch (cellStatus) {
            case CGCalendarCellStateSelected:
            {
                self.dateLabel.textColor = [UIColor whiteColor];
                self.dateLabel.backgroundColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
                self.todaySignLabel.backgroundColor = [UIColor whiteColor];
            }
                break;
            default:
            {
                self.dateLabel.textColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
                self.dateLabel.backgroundColor = [UIColor clearColor];
                self.todaySignLabel.backgroundColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
            }
                break;
        }
    }
}

#pragma mark - getters
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = [UIColor colorWithRed:0.26f green:0.26f blue:0.26f alpha:1.00f];
        _dateLabel.clipsToBounds = YES;
    }
    return _dateLabel;
}

- (UILabel *)todaySignLabel {
    if (!_todaySignLabel) {
        _todaySignLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _todaySignLabel.clipsToBounds = YES;
        _todaySignLabel.layer.cornerRadius = 2.5f;
        _todaySignLabel.backgroundColor = [UIColor colorWithRed:(230/255.f) green:(46/255.f) blue:(77/255.f) alpha:1.00f];
    }
    return _todaySignLabel;
}

@end
