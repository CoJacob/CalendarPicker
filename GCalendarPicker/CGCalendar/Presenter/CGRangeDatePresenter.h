//
//  CGRangeDatePresenter.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGBaseDatePresenter.h"

@interface CGRangeDatePresenter : CGBaseDatePresenter

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) BOOL   isChoosedRangeDate;
@property (nonatomic, copy) void(^selectDateHandle)(NSDate *statDate, NSDate *endDate);

- (void)updateSelectRangeDateStatus;

@end
