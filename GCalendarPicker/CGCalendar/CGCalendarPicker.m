//
//  CGCalendarPicker.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGCalendarPicker.h"
#import "CGCalendar.h"
#import "CGDateHeaderView.h"
#import "CGCalendarBottomView.h"
#import "CGSingleDatePresenter.h"
#import "CGRangeDatePresenter.h"

#define kCGDevice_IPhoneXSeries (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size))

@interface CGCalendarPicker ()

@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIButton              *chooseDateButton;
@property (nonatomic, strong) UIButton              *endDateButton;
@property (nonatomic, strong) UIView                *translucentView;
@property (nonatomic, strong) UIView                *topClearColorView;
@property (nonatomic, strong) CGCalendarView        *calendarView;
@property (nonatomic, strong) CGCalendarBottomView  *bottomView;
@property (nonatomic, strong) CGSingleDatePresenter *singlePresenter;
@property (nonatomic, strong) CGRangeDatePresenter  *rangePresenter;

@property (nonatomic, strong) NSDate *singleModeSelectedDate;
@property (nonatomic, strong) NSDate *rangeModeSelectedStartDate;
@property (nonatomic, strong) NSDate *rangeModeSelectedEndDate;
@property (nonatomic, assign) CGFloat superViewHeight;

@end

@implementation CGCalendarPicker

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originFameY = 0;
        self.superViewHeight = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.chooseDateButton];
        [self addSubview:self.endDateButton];
        [self _setUpBottomHandle];
        [self addSubview:self.calendarView];
        [self addSubview:self.bottomView];
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            [self.translucentView addGestureRecognizer:tapGesture];
            UITapGestureRecognizer *topBgViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            [self.topClearColorView addGestureRecognizer:topBgViewGesture];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenRotateNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.superViewHeight = (CGRectGetHeight(self.frame) > 0) ? CGRectGetHeight(self.frame) : CGRectGetHeight(self.superview.frame);
    self.chooseDateButton.frame = CGRectMake(15, 39.5, (CGRectGetWidth(self.frame)-45)/2, 45);
    self.endDateButton.frame = CGRectMake(30 + (CGRectGetWidth(self.frame)-45)/2, 39.5, (CGRectGetWidth(self.frame)-45)/2, 45);
    self.topClearColorView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.originFameY);
    self.translucentView.frame = CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, [self translucentViewFrameHeight]);
    [self updateSelectionModeUI];
    [self.calendarView reloadData];
}

#pragma mark - Public

- (void)showInView: (UIView *)superView {
    if (self.superview) {
        return;
    }
    self.superViewHeight = (CGRectGetHeight(self.frame) > 0) ? CGRectGetHeight(self.frame) : CGRectGetHeight(superView.frame);
    [superView addSubview:self.translucentView];
    [superView addSubview:self];
    self.frame = CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, 0.1);
    CGFloat _frameHeight = ([self maxFrameHeight] < 478.5 ) ? [self maxFrameHeight] : 478.5;
    self.frame = (self.selectionMode == CGSelectionModeRange) ?
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, _frameHeight):
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, self.superViewHeight);
    [self layoutSubviews];
    [self setUpData];
    [self showWithAnimation];
}

- (void)showInView:(UIView *)superView  belowSubview:(UIView *)belowSubview{
    if (self.superview) {
        return;
    }
    self.superViewHeight = (CGRectGetHeight(self.frame) > 0) ? CGRectGetHeight(self.frame) : CGRectGetHeight(superView.frame);
    [superView insertSubview:self.translucentView belowSubview:belowSubview];
    [superView insertSubview:self belowSubview:belowSubview];
    self.frame = CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, 0.1);
    CGFloat _frameHeight = ([self maxFrameHeight] < 478.5 ) ? [self maxFrameHeight] : 478.5;
    self.frame = (self.selectionMode == CGSelectionModeRange) ?
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, _frameHeight):
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, self.superViewHeight);
    [self layoutSubviews];
    [self setUpData];
    [self showWithAnimation];
}

- (void)close {
    [self removeFromSuperviewWithAnimation];
    !self.closeCallback?:self.closeCallback();
}

- (void)scrollToSlectedMonthOrCurrentMonthSection {
    [self.calendarView scrollToSlectedMonthOrCurrentMonthSectionWithAnimated:YES];
}

- (BOOL)isShow {
    return (self.superview && self.transform.a == 1);
}

- (void)showWithAnimation {
    CGRect rect = self.translucentView.frame;
    rect.size.height = [self translucentViewFrameHeight];
    rect.origin.y = (-CGRectGetHeight(self.frame) + self.originFameY);
    self.translucentView.frame = rect;
    CGRect rect1 = self.frame;
    rect1.origin.y = (-CGRectGetHeight(self.frame) + self.originFameY);
    self.frame = rect1;
    self.translucentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.translucentView.alpha = 0.1f;
    self.alpha = 0.4f;
    [self.calendarView scrollToSlectedMonthOrCurrentMonthSectionWithAnimated:NO];
    [UIView animateWithDuration:0.35
                          delay:0.05
         usingSpringWithDamping:1.0f
          initialSpringVelocity:15
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                         self.translucentView.alpha = 1;
                         
                         CGRect originRect = self.frame;
                         originRect.origin.y = self.originFameY;
                         if (CGRectEqualToRect(originRect,self.frame)) {
                             return ;
                         }
                         self.frame = (originRect);
                     } completion:^(BOOL finished) {
                         {
//                             [self.calendarView scrollToSlectedMonthOrCurrentMonthSection];
                         }
                     }];
}

- (void)removeFromSuperviewWithAnimation
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.translucentView.alpha  = 0;
                         CGRect rect = self.frame;
                         rect.origin.y = -CGRectGetHeight(self.frame)-20;
                         self.frame = rect;
                     } completion:^(BOOL finished) {
                         [self.translucentView removeFromSuperview];
                         [self removeFromSuperview];
                         self.alpha = 1.0f;
                         self.translucentView.alpha = 1.0f;
                     }];
}

- (CGFloat )maxFrameHeight {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) {
        CGRect rect = [self convertRect:self.bounds toView:keyWindow];
        return [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    }else {
        return [UIScreen mainScreen].bounds.size.height - self.originFameY;
    }
}

- (CGFloat )translucentViewFrameHeight {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) {
        CGRect rect = [self convertRect:self.bounds toView:keyWindow];
        return [UIScreen mainScreen].bounds.size.height-rect.origin.y;
    }else {
        return [UIScreen mainScreen].bounds.size.height-self.originFameY;
    }
}

#pragma mark - Setter

- (void)setSelectionMode:(CGSelectionMode)selectionMode {
    _selectionMode = selectionMode;
    self.calendarView.selectionMode = _selectionMode;
    [self registerCalanederViewCells];
    [self updateSelectionModeUI];
}

- (void)setFirstDate:(NSDate *)firstDate {
    _firstDate = firstDate;
    NSDate *zeroDate = [NSDate zeroDateFormDate:_firstDate];
    self.calendarView.firstDate = zeroDate;
}

- (void)setLastDate:(NSDate *)lastDate {
    _lastDate = lastDate;
    NSDate *zeroDate = [NSDate zeroDateFormDate:_lastDate];
    self.calendarView.lastDate = zeroDate;
}

- (void)setSingleModeDisableSelectDateArray:(NSArray *)singleModeDisableSelectDateArray {
    _singleModeDisableSelectDateArray = singleModeDisableSelectDateArray;
    if (self.selectionMode == CGSelectionModeSingle) {
        self.singlePresenter.disableSelectDateArray = [NSMutableArray arrayWithArray:_singleModeDisableSelectDateArray];
    }
}

- (void)setDefaultSelectDateInSingleMode:(NSDate *)defaultSelectDateInSingleMode {
    _defaultSelectDateInSingleMode = defaultSelectDateInSingleMode;
    _defaultSelectDateInSingleMode = [NSDate zeroDateFormDate:_defaultSelectDateInSingleMode];
    self.singleModeSelectedDate    = _defaultSelectDateInSingleMode;
    self.singlePresenter.selectedDate = _defaultSelectDateInSingleMode;
    [self updateDateTitleWithSelectDate];
}

- (void)setDefaultSlectEndDateInRangeMode:(NSDate *)defaultSlectEndDateInRangeMode {
    _defaultSlectEndDateInRangeMode = defaultSlectEndDateInRangeMode;
    _defaultSlectEndDateInRangeMode = [NSDate zeroDateFormDate:_defaultSlectEndDateInRangeMode];
    self.rangeModeSelectedEndDate = _defaultSlectEndDateInRangeMode;
    self.rangeModeSelectedEndDate = _defaultSlectEndDateInRangeMode;
    self.rangePresenter.endDate = _defaultSlectEndDateInRangeMode;
    [self updateDateTitleWithSelectDate];
}

#pragma mark - Getter

- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.originFameY)];
        _translucentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _translucentView;
}

- (UIView *)topClearColorView {
    if (!_topClearColorView) {
        _topClearColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.originFameY)];
        _topClearColorView.backgroundColor = [UIColor clearColor];
    }
    return _topClearColorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, 90, 22)];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1.0f];
        _titleLabel.text = @"自定义日期";
    }
    return _titleLabel;
}

- (UIButton *)chooseDateButton {
    if (!_chooseDateButton) {
        _chooseDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseDateButton.frame = CGRectMake(15, 39.5, (CGRectGetWidth(self.frame)-45)/2, 45);
        _chooseDateButton.clipsToBounds = YES;
        _chooseDateButton.layer.cornerRadius = 3.f;
        _chooseDateButton.layer.borderWidth = 1.f;
        _chooseDateButton.layer.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f].CGColor;
        [_chooseDateButton setBackgroundColor:[UIColor whiteColor]];
        if (@available(iOS 8.2, *)) {
            _chooseDateButton.titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
        }
        [_chooseDateButton setTitleColor:[UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.00f] forState:UIControlStateNormal];
        [_chooseDateButton setTitle:@"选择日期" forState:UIControlStateNormal];
    }
    return _chooseDateButton;
}

- (UIButton *)endDateButton {
    if (!_endDateButton) {
        _endDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _endDateButton.frame = CGRectMake(30 + (CGRectGetWidth(self.frame)-45)/2, 39.5, (CGRectGetWidth(self.frame)-45)/2, 45);
        _endDateButton.clipsToBounds = YES;
        _endDateButton.layer.cornerRadius = 3.f;
        _endDateButton.layer.borderWidth = 1.f;
        _endDateButton.layer.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f].CGColor;
        [_endDateButton setBackgroundColor:[UIColor whiteColor]];
        if (@available(iOS 8.2, *)) {
            _endDateButton.titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
        }
        [_endDateButton setTitleColor:[UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.00f] forState:UIControlStateNormal];
        [_endDateButton setTitle:@"" forState:UIControlStateNormal];
    }
    return _endDateButton;
}

#pragma mark -
- (CGCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[CGCalendarView alloc] initWithFrame:CGRectMake(0, 94.5, CGRectGetWidth(self.frame), 335)];
        [_calendarView registerSectionHeader:[CGDateHeaderView class] withReuseIdentifier:@"sectionHeader"];
        _calendarView.backgroundColor = [UIColor whiteColor];
        _calendarView.contentInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        _calendarView.sectionHeaderHeight = 55;
        _calendarView.weekViewHeight = 35;
        _calendarView.backgroundColor = [UIColor whiteColor];
        
    }
    return _calendarView;
}

- (CGCalendarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CGCalendarBottomView alloc] initWithFrame:CGRectMake(0, 429.5, CGRectGetWidth(self.frame), 49)];
    }
    return _bottomView;
}

- (CGSingleDatePresenter *)singlePresenter {
    if (!_singlePresenter) {
        _singlePresenter = [[CGSingleDatePresenter alloc] init];
    }
    return _singlePresenter;
}

- (CGRangeDatePresenter *)rangePresenter {
    if (!_rangePresenter) {
        _rangePresenter = [[CGRangeDatePresenter alloc] init];
    }
    return _rangePresenter;
}

#pragma mark - Private

- (void) _resetButtonTitle {
    [self.chooseDateButton setTitle:(self.selectionMode == CGSelectionModeSingle) ? @"选择日期" : @"开始时间" forState:(UIControlState)UIControlStateNormal];
    [self.endDateButton setTitle:(self.selectionMode == CGSelectionModeSingle) ? @"" : @"结束时间" forState:UIControlStateNormal];
}

- (void) _setUpBottomHandle {
    __weak typeof(self) weakSelf = self;
    self.bottomView.cleanDateButtonHandle = ^{
        [weakSelf clearSelectDate];
    };
    self.bottomView.confirmButtonHandle = ^{
        [weakSelf close];
        [weakSelf sendDateCallback];
    };
    self.bottomView.switchToTodayButtonHandle = ^{
        weakSelf.defaultSelectDateInSingleMode = [NSDate zeroDateFormDate:[NSDate date]];
        weakSelf.calendarView.defaultEffectScrollDate = weakSelf.defaultSelectDateInSingleMode;
        [weakSelf.calendarView reloadData];
        [weakSelf scrollToSlectedMonthOrCurrentMonthSection];
    };
}

- (void)clearSelectDate {
    [self.singlePresenter clearSelectedDate];
    [self.rangePresenter clearSelectedDate];
    [self _resetButtonTitle];
}

- (void)sendDateCallback {
    if (self.selectionMode == CGSelectionModeSingle) {
        self.singleModeSelectedDate = self.singlePresenter.selectedDate;
        if ([_delegate respondsToSelector:@selector(calendarPicker:didSelectedSingleModeDate:)]) {
            [_delegate calendarPicker:self didSelectedSingleModeDate:self.singleModeSelectedDate];
        }
    }else if (self.selectionMode == CGSelectionModeRange) {
        self.rangeModeSelectedStartDate = self.rangePresenter.startDate;
        self.rangeModeSelectedEndDate   = self.rangePresenter.endDate;
        if ([_delegate respondsToSelector:@selector(calendarPicker:didSelectedRangeModeDateWithStartDate:endDate:)]) {
            [_delegate calendarPicker:self didSelectedRangeModeDateWithStartDate:self.rangeModeSelectedStartDate endDate:self.rangeModeSelectedEndDate];
        }
    }
}

- (void) setUpData
{
    self.calendarView.defaultEffectScrollDate = nil;
    if (self.selectionMode == CGSelectionModeSingle) {
        self.singlePresenter.selectedDate = self.singleModeSelectedDate;
        self.calendarView.defaultEffectScrollDate = self.singleModeSelectedDate;
    }else if (self.selectionMode == CGSelectionModeRange) {
        self.rangePresenter.startDate = self.rangeModeSelectedStartDate;
        self.rangePresenter.endDate = self.rangeModeSelectedEndDate;
        [self.rangePresenter updateSelectRangeDateStatus];
        self.calendarView.defaultEffectScrollDate = self.rangeModeSelectedStartDate ? self.rangeModeSelectedStartDate : self.rangeModeSelectedEndDate;
    }
    [self updateDateTitleWithSelectDate];
    [self.calendarView reloadData];
}

- (void)updateSelectionModeUI
{
    BOOL _isSingleMode = (_selectionMode == CGSelectionModeSingle);
    [self.chooseDateButton setHidden:_isSingleMode];
    [self.endDateButton setHidden:_isSingleMode];
    self.bottomView.isSingleSelectMode = _isSingleMode;
    if (_isSingleMode)
    {  // 单选
        CGFloat _tabbarHeight = kCGDevice_IPhoneXSeries ? 83.f : 49.f;
        self.calendarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.superViewHeight - (self.matchBottomBarForIphoneX ? _tabbarHeight : 49));
    }else {
        self.calendarView.frame = CGRectMake(0, 94.5, [UIScreen mainScreen].bounds.size.width,CGRectGetHeight(self.frame) - 49 - 94.5);
    }
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.calendarView.frame), [UIScreen mainScreen].bounds.size.width, 49);
}

- (void)registerCalanederViewCells {
    __weak typeof(self) weakSelf = self;
    if (self.selectionMode == CGSelectionModeSingle)
    {
        self.singlePresenter.calendarView = self.calendarView;
        self.singlePresenter.selectDateHandle = ^(NSDate *date) {
            [weakSelf updateDateTitleWithSelectDate];
        };
    }else
    {
        self.rangePresenter.calendarView = self.calendarView;
        self.rangePresenter.selectDateHandle = ^(NSDate *statDate, NSDate *endDate) {
            [weakSelf updateDateTitleWithSelectDate];
        };
    }
}

- (void)updateDateTitleWithSelectDate
{
    if (self.selectionMode == CGSelectionModeSingle)
    {
        if (self.singlePresenter.selectedDate) {
            [self.endDateButton setTitle:[self stringFromDate:self.singlePresenter.selectedDate] forState:UIControlStateNormal];
        }else {
            [self.endDateButton setTitle:@"" forState:UIControlStateNormal];
        }
    }else if (self.selectionMode == CGSelectionModeRange)
    {
        if (self.rangePresenter.startDate)
        {
            [self.chooseDateButton setTitle:[self stringFromDate:self.rangePresenter.startDate] forState:UIControlStateNormal];
        }else
        {
            [self.chooseDateButton setTitle:@"开始时间" forState:UIControlStateNormal];
        }
        if (self.rangePresenter.endDate)
        {
            [self.endDateButton setTitle:[self stringFromDate:self.rangePresenter.endDate] forState:UIControlStateNormal];
        }else
        {
            [self.endDateButton setTitle:@"结束时间" forState:UIControlStateNormal];
        }
    }
}

- (NSString *)stringFromDate: (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - Gesture

- (void)tapGestureHandle: (UITapGestureRecognizer *)tapGesture {
    [self close];
}

#pragma mark - Notification

- (void)screenRotateNotification: (NSNotification *)notification {
    self.frame = (self.selectionMode == CGSelectionModeRange) ?
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width, 478.5):
    CGRectMake(0, self.originFameY, [UIScreen mainScreen].bounds.size.width,self.superViewHeight);
}

@end
