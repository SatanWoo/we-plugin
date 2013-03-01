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
#define kData @"data"

@interface WTViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, strong) CLLocation* previousLocation;
@end

@implementation WTViewController
@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize fileName = _fileName;
@synthesize historyArray = _historyArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configurePlist];
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

- (NSString *)fileName
{
    if (_fileName == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        _fileName = [path stringByAppendingPathComponent:@"data.plist"];
    }
    
    return _fileName;
}

- (NSMutableArray *)historyArray
{
    if (_historyArray == nil) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    
    return _historyArray;
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
    self.locationLabel.text = @"Updating";
    self.nameLabel.text = @"Updating";
    [self.startButton setEnabled:NO];
}

- (void)resumeUserInteraction
{
    [self.startButton setEnabled:YES];
}

- (void)configurePlist
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:self.fileName]) {
      [manager createFileAtPath:self.fileName contents:nil attributes:nil];
    }
    
    [self configureHistory];
}

- (void)configureHistory
{
    NSData *data = [NSData dataWithContentsOfFile:self.fileName];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    self.historyArray = [[NSMutableArray alloc]initWithArray:[unarchiver decodeObjectForKey:kData]];
}

- (void)saveData:(WTHistory *)history
{
    [self.historyArray addObject:history];
    [self save:nil];
}

- (void)createHistoryWithLatitude:(double)latitde
                              longtitude:(double)longtitude
                                    name:(NSString *)name
{
    WTHistory *history = [[WTHistory alloc] init];
    history.latitude = latitde;
    history.longtitude = longtitude;
    history.name = name;
    
    if ([self isValidHistory:history]) {
        [self saveData:history];
    }
}

- (BOOL)isValidHistory:(WTHistory *)history
{
    if (history.latitude == 0 || history.longtitude == 0 || history.name == NULL) {
        return  false;
    }
    
    return true;
}


- (BOOL)isValidLocation:(CLLocation *)location
{
    if (location.coordinate.latitude == 0 && location.coordinate.longitude == 0) {
        return  false;
    }
    
    return true;
}

#pragma mark - IBAction
- (IBAction)startSearchingBuildingName:(id)sender
{
    [self disableUserInteraction];
    [self.locationManager startUpdatingLocation];
}

- (IBAction)save:(id)sender
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.historyArray forKey: kData];
    [archiver finishEncoding];
    
    [data writeToFile:self.fileName atomically:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Update");
    
    CLLocation *shiftLocation = [self shiftLocation:self.locationManager.location];
    if (![self isValidLocation:shiftLocation]) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
        return ;
    }
    
    [self.geocoder reverseGeocodeLocation:shiftLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.locationManager stopUpdatingLocation];
        [self resumeUserInteraction];
        
        CLPlacemark *mark = [placemarks lastObject];
        self.nameLabel.text = mark.name;
        
        self.locationLabel.text = [NSString stringWithFormat:@"%f\n\n%f",shiftLocation.coordinate.latitude,shiftLocation.coordinate.longitude];
        
        [self createHistoryWithLatitude:shiftLocation.coordinate.latitude
                             longtitude:shiftLocation.coordinate.longitude
                                   name:mark.name];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WTHistoryViewController *vc = segue.destinationViewController;
    vc.historyArray = [NSArray arrayWithArray:self.historyArray];
}

@end
