//
//  WTHistoryViewController.m
//  查查同济建筑
//
//  Created by Wu Ziqi on 13-3-1.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import "WTHistoryViewController.h"
#import "WTHistoryTableViewCell.h"
#import "WTHistory.h"

@interface WTHistoryViewController ()

@end

@implementation WTHistoryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[WTHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    WTHistory *history = [self.historyArray objectAtIndex:indexPath.row];
    cell.locationLabel.text = [NSString stringWithFormat:@"%f\n\n%f",history.latitude,history.longtitude];
    cell.nameLabel.text = history.name;
    
    return cell;
}

@end
