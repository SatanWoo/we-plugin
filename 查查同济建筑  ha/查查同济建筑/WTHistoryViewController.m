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
#import "WTFileManager.h"

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
}

- (IBAction)editTableView:(id)sender
{
    if ([self.historyTableView isEditing]) {
        [self.historyTableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"编辑"];
    } else {
        [self.historyTableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"完成"];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WTFileManager defaultManager].historyArray count];
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
    
    WTHistory *history = [[WTFileManager defaultManager].historyArray objectAtIndex:indexPath.row];
    cell.locationLabel.text = [NSString stringWithFormat:@"%f\n\n%f",history.latitude,history.longtitude];
    cell.nameLabel.text = history.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[WTFileManager defaultManager].historyArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView reloadData];
}

@end
