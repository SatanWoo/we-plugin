//
//  WTViewController.m
//  查查同济建筑
//
//  Created by 吴 wuziqi on 13-2-28.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import "WTViewController.h"
#import "WTHistory.h"
#import "WTHistoryViewController.h"
#import "WTFileManager.h"


@interface WTViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) CLLocation* previousLocation;
@end

@implementation WTViewController
@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize fileName = _fileName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configurePlist];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

#pragma mark - Private
- (CLLocation *)shiftLocation:(CLLocation *)oldLocation
{
    id sharedLocationManager = [NSClassFromString(@"MKLocationManager") performSelector:@selector(sharedLocationManager)];
    SEL theSelector = @selector(_applyChinaLocationShift:);
    
    if (![sharedLocationManager respondsToSelector:theSelector]) {
        return nil;
    }
    
    return [sharedLocationManager performSelector:theSelector withObject:oldLocation];
}

- (void)disableUserInteraction
{
    self.latitudeTextField.text = @"Updating";
    self.longtitudeTextField.text = @"Updating";
    self.nameTextField.text = @"Updating";
    [self.startButton setEnabled:NO];
}

- (void)resumeUserInteraction
{
    [self.startButton setEnabled:YES];
}

- (void)configurePlist
{
    [[WTFileManager defaultManager] loadFile:@"data.plist"];
}

- (void)cancelKeyboard
{
    [self.latitudeTextField resignFirstResponder];
    [self.longtitudeTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

- (void)saveData
{
    WTHistory *history = [WTHistory createHistoryWithLatitude:[self.latitudeTextField.text doubleValue]
                                              longtitude:[self.longtitudeTextField.text doubleValue]
                                                    name:self.nameTextField.text];
    
    if ([history isValidHistory]) {
        [[WTFileManager defaultManager].historyArray addObject:history];
    }
}

- (BOOL)isValidLocation:(CLLocation *)location
{
    if (location.coordinate.latitude == 0 && location.coordinate.longitude == 0) {
        return  false;
    }
    
    return true;
}

- (void)restartUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - IBAction
- (IBAction)startSearchingBuildingName:(id)sender
{
    [self disableUserInteraction];
    [self.locationManager startUpdatingLocation];
}

- (IBAction)save:(id)sender
{
    [self saveData];
    [[WTFileManager defaultManager] save];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *shiftLocation = [self shiftLocation:self.locationManager.location];
    if (![self isValidLocation:shiftLocation]) {
        [self restartUpdatingLocation];
        return ;
    }
    
    [self.geocoder reverseGeocodeLocation:shiftLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.locationManager stopUpdatingLocation];
        [self resumeUserInteraction];
        
        CLPlacemark *mark = [placemarks lastObject];
        self.nameTextField.text = mark.name;
        self.latitudeTextField.text = [NSString stringWithFormat:@"%f", shiftLocation.coordinate.latitude];
        self.longtitudeTextField.text = [NSString stringWithFormat:@"%f", shiftLocation.coordinate.longitude];
    }];
}
@end
