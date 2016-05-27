//
//  RMMapLocation.m
//  StaffManagement
//
//  Created by Raymon on 16/4/14.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import "RMMapLocation.h"

@interface RMMapLocation ()<CLLocationManagerDelegate>
@property (strong, nonatomic)CLLocationManager *locManager;

@end

@implementation RMMapLocation

+ (instancetype)sharedGpsManager
{
    static id mapLocation;    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!mapLocation) {
            mapLocation = [[RMMapLocation alloc] init];
        }
    });
    return mapLocation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getCurrentLocation];
    }
    return self;
}

- (void)getCurrentLocation
{
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 10.0;
    [self.locManager startUpdatingLocation];
}

- (void)getGps:(void (^)(double lat, double lng))gps
{
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        return;
    }
    saveGpsCallBack = [gps copy];
    [self.locManager stopUpdatingLocation];
    [self.locManager startUpdatingLocation];
}

+ (void)getGps:(void (^)(double, double))block
{
    [[RMMapLocation sharedGpsManager] getGps:block];
}

- (void)stop
{
    [self.locManager stopUpdatingLocation];
}

+ (void)stop
{
    [[RMMapLocation sharedGpsManager] stop];
}

#pragma mark - locationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    RMLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    if (saveGpsCallBack) {
        saveGpsCallBack(latitude,longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    RMLog(@"%@",error);
    [RMUtils showMessage:@"请先打开定位"];
}



@end
