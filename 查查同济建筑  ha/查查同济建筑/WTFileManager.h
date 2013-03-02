//
//  WTFileManager.h
//  查查同济建筑
//
//  Created by 吴 wuziqi on 13-3-2.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTFileManager : NSObject
+ (WTFileManager *)defaultManager;
- (void)loadFile:(NSString *)filename;
- (void)save;

@property (nonatomic, strong) NSMutableArray *historyArray;
@end
