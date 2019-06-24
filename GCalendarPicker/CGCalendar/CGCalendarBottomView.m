//
//  CGCalendarBottomView.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGCalendarBottomView.h"

@interface CGCalendarBottomView ()

@property (nonatomic, strong) UIButton *cleanDateButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *switchToTodayButton;
@property (nonatomic, strong) UIView   *topSeperatorView;

@end

@implementation CGCalendarBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cleanDateButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.switchToTodayButton];
        [self addSubview:self.topSeperatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cleanDateButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 49);
    self.topSeperatorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f);
}

- (void)setIsSingleSelectMode:(BOOL)isSingleSelectMode {
    _isSingleSelectMode = isSingleSelectMode;
    [self.cleanDateButton setHidden:_isSingleSelectMode];
    [self.switchToTodayButton setHidden:!_isSingleSelectMode];
}

#pragma mark - Getter

- (UIView *)topSeperatorView {
    if (!_topSeperatorView) {
        _topSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f)];
        _topSeperatorView.backgroundColor = [UIColor colorWithRed:(245/255.f) green:(245/255.f) blue:(245/255.f) alpha:1.00f];
    }
    return _topSeperatorView;
}

- (UIButton *)cleanDateButton {
    if (!_cleanDateButton) {
        _cleanDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleanDateButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 49);
        if (@available(iOS 8.2, *)) {
            _cleanDateButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        }
        [_cleanDateButton setTitleColor:[UIColor colorWithRed:(153/255.f) green:(153/255.f) blue:(153/255.f) alpha:1.00f] forState:UIControlStateNormal];
        [_cleanDateButton setBackgroundColor:[UIColor whiteColor]];
        [_cleanDateButton setTitle:@"清空" forState:UIControlStateNormal];
        [_cleanDateButton addTarget:self
                             action:@selector(cleanDateButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanDateButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame)/2, 0, CGRectGetWidth(self.frame)/2, 49);
        if (@available(iOS 8.2, *)) {
            _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        }
        [_confirmButton setBackgroundColor:[UIColor colorWithRed:0.08f green:0.47f blue:0.94f alpha:1.00f]];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)switchToTodayButton {
    if (!_switchToTodayButton) {
        _switchToTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchToTodayButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 49);
        if (@available(iOS 8.2, *)) {
            _switchToTodayButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        }
        [_switchToTodayButton setTitleColor:[UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.00f] forState:UIControlStateNormal];
        [_switchToTodayButton setTitle:@"回到今日" forState:UIControlStateNormal];
        _switchToTodayButton.hidden = YES;
        [_switchToTodayButton addTarget:self
                           action:@selector(switchToTodayButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchToTodayButton;
}

#pragma mark - IBActions

- (void)cleanDateButtonAction: (UIButton *)button {
    !self.cleanDateButtonHandle?:self.cleanDateButtonHandle();
}

- (void)confirmButtonAction: (UIButton *)button {
    !self.confirmButtonHandle?:self.confirmButtonHandle();
}

- (void)switchToTodayButtonAction: (UIButton *)button {
    !self.switchToTodayButtonHandle?:self.switchToTodayButtonHandle();
}

@end
