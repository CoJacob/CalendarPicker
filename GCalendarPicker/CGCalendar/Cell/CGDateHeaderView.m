//
//  CGSingleDateHeaderView.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGDateHeaderView.h"
#import "CGCalendar.h"

@interface CGDateHeaderView ()

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, assign) NSInteger weekday;

@end

@implementation CGDateHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.monthLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.monthLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-45-CGRectGetWidth(self.monthLabel.frame),18.5 , CGRectGetWidth(self.monthLabel.frame), 28);
}

#pragma mark - setters
- (void)setFirstDateOfMonth:(NSDate *)firstDateOfMonth {
    _firstDateOfMonth = firstDateOfMonth;
    NSCalendar *calendar = [NSDate gregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:firstDateOfMonth];
    self.weekday = components.weekday;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)components.year ,(long)components.month];
    [self.monthLabel sizeToFit];
    [self layoutSubviews];
}


#pragma mark - Getter
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        if (@available(iOS 8.2, *)) {
            _monthLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightMedium];
        }
        _monthLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1];
    }
    return _monthLabel;
}

@end
