//
//  RangeDateViewController.m
//  GCalendarPicker
//
//  Created by Caoguo on 2019/6/24.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import "RangeDateViewController.h"
#import "CGCalendar.h"

@interface RangeDateViewController () <CGCalendarPickerDelegate>

@property (nonatomic, strong) UIButton *calendarButton;
@property (nonatomic, strong) CGCalendarPicker                     *calendarPicker;

@end

@implementation RangeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *baritem = [[UIBarButtonItem alloc] initWithCustomView:self.calendarButton];
    self.navigationItem.rightBarButtonItem = baritem;
}

#pragma mark - Getter

- (CGCalendarPicker *)calendarPicker {
    if (!_calendarPicker) {
        _calendarPicker = [[CGCalendarPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64 - 84)];
        _calendarPicker.originFameY = 64;
        _calendarPicker.selectionMode = CGSelectionModeRange;
        _calendarPicker.delegate = self;
        _calendarPicker.firstDate = [self defaultStartDate];
        _calendarPicker.lastDate = [self defaultEndDate];
        //        __weak __typeof__(self) weakSelf = self;
        _calendarPicker.closeCallback = ^{
            
        };
    }
    return _calendarPicker;
}

- (UIButton *)calendarButton {
    if (!_calendarButton) {
        _calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _calendarButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 8, 20, 44, 44);
        _calendarButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:24.f];
        [_calendarButton setTitle:@"📅" forState:UIControlStateNormal];
        [_calendarButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_calendarButton addTarget:self action:@selector(calendarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calendarButton;
}


#pragma mark - Private

- (NSDate *)defaultStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:@"2019-01-01"];
}

- (NSDate *)defaultEndDate {
    return [NSDate date];
}

#pragma mark - IBAction

- (void)calendarButtonAction: (UIButton *)button {
//    self.calendarPicker.defaultSelectDateInSingleMode = self.date;
    [self.calendarPicker showInView:self.view];
}

#pragma mark - CGCalendarPickerDelegate

- (void)calendarPicker:(CGCalendarPicker *)picker didSelectedRangeModeDateWithStartDate: (NSDate *)startDate endDate: (NSDate *)endDate {
    
}


@end
