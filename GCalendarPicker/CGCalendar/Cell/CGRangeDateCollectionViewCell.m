//
//  CGRangeDateCollectionViewCell.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGRangeDateCollectionViewCell.h"
#import "NSDate+CGAddition.h"

@interface CGRangeDateCollectionViewCell ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UILabel    *dateLabel;
@property (nonatomic, strong) UIView     *leftLayerView;
@property (nonatomic, strong) UIView     *rightLayerView;
@property (nonatomic, strong) UILabel    *todaySignLabel;

@end

@implementation CGRangeDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.leftLayerView];
        [self.contentView addSubview:self.rightLayerView];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.todaySignLabel];
        self.calendar = [NSDate gregorianCalendar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    self.leftLayerView.frame  = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 45);
    self.rightLayerView.frame = CGRectMake(CGRectGetWidth(self.frame)/2, 0, CGRectGetWidth(self.frame)/2, 45);
    self.todaySignLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 15);
}


#pragma mark - setters

- (void)setIsChoosedRangeDate:(BOOL)isChoosedRangeDate {
    _isChoosedRangeDate = isChoosedRangeDate;
    [self.leftLayerView setHidden:YES];
    [self.rightLayerView setHidden:YES];
    if (_isChoosedRangeDate && self.date) {
        if (self.cellState == CGRangeCalendarCellStateSelectedStart) {
            [self.rightLayerView setHidden:NO];
        }else if (self.cellState == CGRangeCalendarCellStateSelectedEnd) {
            [self.leftLayerView setHidden:NO];
        }
    }
}

- (void)setDate:(NSDate *)date {
    _date = date;
    if (_date) {
        self.dateLabel.text = [NSString stringWithFormat:@"%ld", [self.calendar component:NSCalendarUnitDay fromDate:_date]];
    } else {
        self.dateLabel.text = nil;
    }
}

- (void)setCellState:(CGRangeCalendarCellState)cellState {
    _cellState = cellState;
    if (@available(iOS 8.2, *)) {
        self.dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    switch (_cellState) {
        case CGRangeCalendarCellStateDisabled: {
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.textColor = [UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.00f];
            [self changeContentViewStatusWithSelected:NO];
            break;
        }
        case CGRangeCalendarCellStateAvaible: {
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.00f];
            [self changeContentViewStatusWithSelected:NO];
            break;
        }
        case CGRangeCalendarCellStateSelectedStart: {
            self.dateLabel.backgroundColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
            self.dateLabel.layer.cornerRadius = 22.5f;
            self.dateLabel.textColor = [UIColor whiteColor];
            [self changeContentViewStatusWithSelected:NO];
            break;
        }
        case CGRangeCalendarCellStateSelectedMiddle: {
            self.dateLabel.backgroundColor    =  [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:9.0/255.0 blue:26.0/255.0 alpha:1.0];
            [self changeContentViewStatusWithSelected:YES];
            break;
        }
        case CGRangeCalendarCellStateSelectedEnd: {
            self.dateLabel.backgroundColor = [UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f];
            self.dateLabel.layer.cornerRadius = 22.5f;
            self.dateLabel.textColor = [UIColor whiteColor];
            if (@available(iOS 8.2, *)) {
                self.dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            }
            [self changeContentViewStatusWithSelected:NO];
            break;
        }
        case CGRangeCalendarCellStateEmpty: {
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.text = nil;
            [self changeContentViewStatusWithSelected:NO];
            break;
        }
        default: {
            break;
        }
            
    }
    [self.todaySignLabel setHidden:![self.date isToday]];
    [self updateLabelColorIfIsTodayForCellStatus:_cellState];
    [self layoutSubviews];
}

- (void)changeContentViewStatusWithSelected: (BOOL )selected {
    if (selected) {
//        self.contentView.backgroundColor = [UIColor colorWithRed:0.91f green:0.95f blue:1.00f alpha:1.00f];
        self.contentView.backgroundColor = [UIColor colorWithRed:(20/255.f) green:(120/255.f) blue:(240/255.f) alpha:1.00f];
    }else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)updateLabelColorIfIsTodayForCellStatus: (CGRangeCalendarCellState )cellStatus {
    if ([self.date isToday])
    {
        switch (cellStatus) {
            case CGRangeCalendarCellStateSelectedStart:
            case CGRangeCalendarCellStateSelectedEnd:
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
        _dateLabel.textColor = [UIColor darkTextColor];
        _dateLabel.clipsToBounds = YES;
    }
    return _dateLabel;
}

- (UIView *)leftLayerView {
    if (!_leftLayerView) {
        _leftLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//        _leftLayerView.backgroundColor = [UIColor colorWithRed:0.91f green:0.95f blue:1.00f alpha:1.00f];
        _leftLayerView.backgroundColor = [UIColor colorWithRed:(20/255.f) green:(120/255.f) blue:(240/255.f) alpha:1.00f];
        _leftLayerView.hidden = YES;
    }
    return _leftLayerView;
}

- (UIView *)rightLayerView {
    if (!_rightLayerView) {
        _rightLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//        _rightLayerView.backgroundColor = [UIColor colorWithRed:0.91f green:0.95f blue:1.00f alpha:1.00f];
        _rightLayerView.backgroundColor = [UIColor colorWithRed:(20/255.f) green:(120/255.f) blue:(240/255.f) alpha:1.00f];
        _rightLayerView.hidden = YES;
    }
    return _rightLayerView;
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
