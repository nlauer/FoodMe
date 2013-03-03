//
//  LocationManager.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CLGeocodeCompletionHandler)(NSArray *placemark, NSError *error);

@interface LocationManager : NSObject

+ (LocationManager *)sharedInstance;

- (void)getStreetAddress:(CLGeocodeCompletionHandler)handler;

@end
