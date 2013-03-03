//
//  LocationManager.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>
@property (strong) CLLocationManager *locationManager;
@end

@implementation LocationManager {
    CLGeocodeCompletionHandler _completionHandler;
}

+ (LocationManager *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }

    return self;
}

- (void)getStreetAddress:(CLGeocodeCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    [_locationManager startUpdatingLocation];
}

- (void)getAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:_completionHandler];
    _completionHandler = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocation *lastLocation = [locations lastObject];
    [self getAddressFromLocation:lastLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

}

@end
