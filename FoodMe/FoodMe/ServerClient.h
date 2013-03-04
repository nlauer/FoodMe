//
//  ServerClient.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@interface ServerClient : NSObject

typedef void (^ServerClientSuccessResponse)(AFHTTPRequestOperation *operation, id responseObject);

+ (ServerClient *)sharedInstance;
- (void)signInWithEmail:(NSString *)email password:(NSString *)password;
- (void)orderFoodToAddress:(NSString *)address
                creditCard:(NSString *)card
                     price:(NSString *)price;

- (void)saveShippingAddress:(NSDictionary *)addressComponents success:(ServerClientSuccessResponse)successHandler;
- (void)getAllShippingAddresses:(ServerClientSuccessResponse)successHandler;

- (void)getAllCreditCards:(ServerClientSuccessResponse)successHandler;

@end
