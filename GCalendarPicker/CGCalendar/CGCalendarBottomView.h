//
//  CGCalendarBottomView.h
//  CGCalendar
//
//  Created by Caoguo on 2018/3/8.
//  Copyright © 2018年 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCalendarBottomView : UIView

@property (nonatomic, copy) void(^cleanDateButtonHandle)(void);
@property (nonatomic, copy) void(^confirmButtonHandle)(void);
@property (nonatomic, copy) void(^switchToTodayButtonHandle)(void);
@property (nonatomic, assign) BOOL isSingleSelectMode;

@end
