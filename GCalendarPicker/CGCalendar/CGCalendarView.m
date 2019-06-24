//
//  CGCalendarView.m
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import "CGCalendarView.h"
#import "NSDate+CGAddition.h"
#import "NSDate+IndexPath.h"

@interface CGCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate, CGCalendarWeekViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *sectionHeaderIdentifier;
@property (nonatomic, strong) NSString *sectionFooterIdentifier;

@end


@implementation CGCalendarView

#pragma  mark - Override
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.weekView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // weekViewFrame
    if (self.weekViewHeight > 0) {
        self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.weekViewHeight);
    } else {
        self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 35);
    }
    
    // collecitonViewFrame
    self.collectionView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.weekView.frame),
                                           [UIScreen mainScreen].bounds.size.width,
                                           CGRectGetHeight(self.frame) - CGRectGetMaxY(self.weekView.frame));
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    // cellSize
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame)/7, 45);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
//    if (KScreenWidth == 320.f) {
//        self.collectionView.frame = CGRectMake(0,
//                                               CGRectGetMaxY(self.weekView.frame),
//                                               KScreenWidth,
//                                               CGRectGetHeight(self.frame) - CGRectGetMaxY(self.weekView.frame));
//        layout.itemSize = CGSizeMake(45, 45);
//    }
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - public method
- (void)registerCellClass:(id)clazz withReuseIdentifier:(NSString *)identifier {
    self.cellIdentifier = identifier;
    [self.collectionView registerClass:clazz forCellWithReuseIdentifier:identifier];
}

- (void)registerSectionHeader:(id)clazz withReuseIdentifier:(NSString *)identifier{
    self.sectionHeaderIdentifier = identifier;
    [self.collectionView registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerSectionFooter:(id)clazz withReuseIdentifier:(NSString *)identifier{
    self.sectionFooterIdentifier = identifier;
    [self.collectionView registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)scrollToSlectedMonthOrCurrentMonthSectionWithAnimated: (BOOL )animated {
    NSInteger monthCount = [NSDate monthCountFromPreviousDate:self.firstDate toDate:self.defaultEffectScrollDate ? self.defaultEffectScrollDate :[NSDate zeroDateFormDate:[NSDate date]]];
    if (monthCount > [self numberOfSectionsInCollectionView:self.collectionView] || monthCount < 0) {
        return;
    }
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:monthCount];
    if (self.collectionView.contentSize.height == 0) {
        __weak __typeof__(self) weakSelf = self;
        [self cg_performHandleBlock:^{
            [weakSelf scrollToIndexWhenFinishReloadCollectionView:cellIndexPath animated:animated];
        } afterDelay:0.05];
    }else {
        [self scrollToIndexWhenFinishReloadCollectionView:cellIndexPath animated:animated];
    }
}

- (void)cg_performHandleBlock:(void(^)(void))handle afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !handle?:handle();
    });
}

- (void)scrollToIndexWhenFinishReloadCollectionView: (NSIndexPath *)cellIndexPath animated: (BOOL )animated {
    if (cellIndexPath.section >= [self numberOfSectionsInCollectionView:self.collectionView])
    {
        return;
    }
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:cellIndexPath];
    CGRect rect = attributes.frame;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.origin.x, rect.origin.y - 45) animated:animated];
}

- (void)scrollToSectionHeaderView {
    CGFloat _offSetY = self.collectionView.contentOffset.y;
    _offSetY -= 52;
    [self.collectionView setContentOffset:CGPointMake(0, _offSetY) animated:YES];
}

- (void)setWeekViewHeight:(CGFloat)weekViewHeight {
    _weekViewHeight = weekViewHeight;
    self.weekView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _weekViewHeight);
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _minimumLineSpacing = minimumLineSpacing;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (_minimumLineSpacing > 0) {
        layout.minimumLineSpacing = _minimumLineSpacing;
    } else {
        layout.minimumLineSpacing = 0;
    }
    self.collectionView.collectionViewLayout = layout;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.collectionView.backgroundColor = backgroundColor;
    self.weekView.backgroundColor = backgroundColor;
}

- (void)setAllowsSelection:(BOOL)allowsSelection {
    _allowsSelection = allowsSelection;
    self.collectionView.allowsSelection = _allowsSelection;
}

- (void)setDataSource:(id<CGCalendarDataSource>)dataSource {
    _dataSource = dataSource;
    self.weekView.delegate = self;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (id)cellAtDate:(NSDate *)date {
    NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)reloadItemsAtDates:(NSSet<NSDate *> *)dates {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSDate *date in dates) {
        NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
        [indexPaths addObject:indexPath];
    }
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)reloadItemsAtMonths:(NSSet<NSDate *> *)months {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSDate *date in months) {
        NSIndexPath *indexPath = [NSDate indexPathAtDate:date firstDate:self.firstDate];
        [indexSet addIndex:indexPath.section];
    }
    [self.collectionView reloadSections:indexSet];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    [self.collectionView setContentOffset:_contentOffset];
}


- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    _contentOffset = contentOffset;
    CGPoint origin = CGPointMake(_contentOffset.x - self.contentInsets.left, _contentOffset.y - self.contentInsets.top);
    [self.collectionView setContentOffset:origin animated:YES];
}

- (CGSize)contentSize {
    return self.collectionView.contentSize;
}

#pragma mark - private methods
- (NSDate *)dateForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = nil;
    
    // if headStyle is `CGCalendarViewHeadStyleCurrentWeek`, the first month is special
    if (self.headStyle == CGCalendarViewHeadStyleCurrentWeek && indexPath.section == 0) {
        NSDate *firstDay = [self.firstDate firstDateOfWeek];
        NSDate *lastDateOfMonth = [self.firstDate lastDateOfMonth];
        NSInteger items = [NSDate numberOfNightsFromDate:firstDay toDate:lastDateOfMonth];
        if (indexPath.row > items) {
        } else {
            
            NSCalendar *calendar = [NSDate gregorianCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDay];
            [components setDay:indexPath.row];
            [components setMonth:indexPath.section];
            date = [calendar dateByAddingComponents:components toDate:firstDay options:0];
            
            if (![self.firstDate isSameMonthWithDate:date]) {
                date = nil;
            }
        }
    } else { // normal logic
        date = [NSDate dateAtIndexPath:indexPath firstDate:self.firstDate];
    }
    
    return date;
}

#pragma mark UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *firstDateOfMonth = [NSDate dateForFirstDayInSection:indexPath.section firstDate:self.firstDate];
    
    if (self.sectionHeaderIdentifier && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.sectionHeaderIdentifier forIndexPath:indexPath];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureSectionHeaderView:firstDateOfMonth:)]) {
            [self.dataSource calendarView:self configureSectionHeaderView:headerView firstDateOfMonth:firstDateOfMonth];
        }
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    } else if (self.sectionFooterIdentifier && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UIView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.sectionFooterIdentifier forIndexPath:indexPath];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureSectionFooterView:lastDateOfMonth:)]) {
            [self.dataSource calendarView:self configureSectionFooterView:footerView lastDateOfMonth:[firstDateOfMonth lastDateOfMonth]];
        }
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
    
    return NULL;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // if headStyle is `CGCalendarViewHeadStyleCurrentWeek`, the first month is special
    if (self.headStyle == CGCalendarViewHeadStyleCurrentWeek && section == 0) {
        NSInteger weekDay = [self.firstDate weekday];
        NSDate *lastDateOfMonth = [self.firstDate lastDateOfMonth];
        NSInteger lastDateOfMonthWeekDay = [lastDateOfMonth weekday];
        NSInteger items = weekDay + [NSDate numberOfNightsFromDate:self.firstDate toDate:lastDateOfMonth] + 7 - lastDateOfMonthWeekDay;
        return items;
    }
    
    // normal logic
    NSDate *firstDay = [NSDate dateForFirstDayInSection:section firstDate:self.firstDate];
    NSInteger weekDay = [firstDay weekday] -1;
    
    NSDate *lastDateOfMonth = [firstDay lastDateOfMonth];
    NSInteger lastWeekDay = [lastDateOfMonth weekday];
    
    NSInteger items =  weekDay + [NSDate numberOfDaysInMonth:firstDay] + 7 - lastWeekDay;    return items;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger months = [NSDate numberOfMonthsFromDate:self.firstDate toDate:self.lastDate];
    return months;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureCell:forDate:)]) {
        [self.dataSource calendarView:self configureCell:cell forDate:date];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
        return [self.delegate calendarView:self shouldSelectDate:date];
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = [self dateForCollectionView:collectionView atIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:ofCell:)]) {
        id cell = [collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate calendarView:self didSelectDate:date ofCell:cell];
    }
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.sectionHeaderIdentifier) {
        if (self.sectionHeaderHeight > 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), self.sectionHeaderHeight);
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), 52);
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (self.sectionFooterIdentifier) {
//        if (self.sectionFooterIdentifier > 0) {
//            return CGSizeMake(CGRectGetWidth(collectionView.frame), self.sectionFooterHeight);
//        } else {
//            return CGSizeMake(CGRectGetWidth(collectionView.frame), 13);
//        }
//    }
    return CGSizeZero;
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //  `contentOffset.x` = `collectionView.contentOffset.x` + `collectionView.contentInset.left`
    //  `contentOffset.y` = `collectionView.contentOffset.y` + `collectionView.contentInset.top`
    _contentOffset = CGPointMake(scrollView.contentOffset.x + self.collectionView.contentInset.left, scrollView.contentOffset.y + self.collectionView.contentInset.top);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - CGCalendarWeekViewDelegate
- (void)calendarWeekView:(CGCalendarWeekView *)weekView configureWeekDayLabel:(UILabel *)dayLabel atWeekDay:(NSInteger)weekDay {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:configureWeekDayLabel:atWeekDay:)]) {
        [self.dataSource calendarView:self configureWeekDayLabel:dayLabel atWeekDay:weekDay];
    }
}

#pragma mark - getters

- (CGCalendarWeekView *)weekView {
    if (!_weekView) {
        _weekView = [[CGCalendarWeekView alloc] init];
    }
    return _weekView;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

#pragma mark - setters
- (void)setSelectionMode:(CGSelectionMode)selectionMode {
    _selectionMode = selectionMode;
    switch (_selectionMode) {
        case CGSelectionModeSingle: {
            self.collectionView.allowsSelection = YES;
            self.collectionView.allowsMultipleSelection = NO;
            break;
        }
        case CGSelectionModeRange: {
            self.collectionView.allowsSelection = YES;
            self.collectionView.allowsMultipleSelection = YES;
            break;
        }
        default: {
            self.collectionView.allowsSelection = NO;
            self.collectionView.allowsMultipleSelection = NO;
            break;
        }
    }
}

@end
