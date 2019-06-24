//
//  CGSingleDatePresenter.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/9.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGBaseDatePresenter.h"

@interface CGSingleDatePresenter : CGBaseDatePresenter

@property (nonatomic, strong) NSMutableArray *disableSelectDateArray;
@property (nonatomic, strong) NSDate         *selectedDate;
@property (nonatomic, copy) void(^selectDateHandle)(NSDate *date);


@end
