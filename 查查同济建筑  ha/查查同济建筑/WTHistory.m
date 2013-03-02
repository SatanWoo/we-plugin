//
//  WTHistory.m
//  查查同济建筑
//
//  Created by Wu Ziqi on 13-3-1.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import "WTHistory.h"

#define kLatitude @"latitude"
#define kLongtitude @"longtitude"
#define kName @"name"

@implementation WTHistory
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeDouble:self.latitude forKey:kLatitude];
    [coder encodeDouble:self.longtitude forKey:kLongtitude];
    [coder encodeObject:self.name forKey:kName];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    
    if (self) {
        self.latitude = [coder decodeDoubleForKey:kLatitude];
        self.longtitude = [coder decodeDoubleForKey:kLongtitude];
        self.name = [coder decodeObjectForKey:kName];
    }
    
    return self;
}

+ (WTHistory *)createHistoryWithLatitude:(double)latitde
                              longtitude:(double)longtitude
                                    name:(NSString *)name
{
    WTHistory *history = [[WTHistory alloc] init];
    history.latitude = latitde;
    history.longtitude = longtitude;
    history.name = name;
    
    return history;
}

- (BOOL)isValidHistory
{
    if (self.latitude == 0 || self.longtitude == 0 || self.name == NULL) {
        return  false;
    }
    
    return true;
}

@end
