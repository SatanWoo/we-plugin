//
//  WTViewController.h
//  查查同济建筑
//
//  Created by 吴 wuziqi on 13-2-28.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WTViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)startSearchingBuildingName:(id)sender;
- (IBAction)save:(id)sender;

@end
