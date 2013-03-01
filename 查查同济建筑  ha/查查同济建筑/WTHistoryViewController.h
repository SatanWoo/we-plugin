//
//  WTHistoryViewController.h
//  查查同济建筑
//
//  Created by Wu Ziqi on 13-3-1.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *historyArray;
@end
