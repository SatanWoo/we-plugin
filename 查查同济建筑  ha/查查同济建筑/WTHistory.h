//
//  WTHistory.h
//  查查同济建筑
//
//  Created by Wu Ziqi on 13-3-1.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHistory : NSObject
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, copy) NSString *name;

- (BOOL)isValidHistory;
+ (WTHistory *)createHistoryWithLatitude:(double)latitde
                              longtitude:(double)longtitude
                                    name:(NSString *)name;
@end
