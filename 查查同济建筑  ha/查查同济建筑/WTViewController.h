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

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longtitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)startSearchingBuildingName:(id)sender;
- (IBAction)save:(id)sender;

@end
