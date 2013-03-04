//
//  ServerClient.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "ServerClient.h"

#import "KeychainAccessor.h"
#import "OrderViewController.h"
#import "AppDelegate.h"
#import "KeychainAccessor.h"
#import "AFJSONRequestOperation.h"

#define kBaseUrl @"http://10.100.28.219:4567/"
//#define kBaseUrl @"http://www.food.me"
#define kOrderFoodPath @"/order"

#define kSaveShippingPath @"/shipping"
#define kGetShippingPath @"/all_shipping"

#define kGetCreditCardPath @"/all_credit_card"

@interface ServerClient () <NSURLConnectionDataDelegate>
@property (strong) AFHTTPClient *client;
@end

@implementation ServerClient

+ (ServerClient *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    }

    return self;
}

- (void)showOrderViewController {
    OrderViewController *orderViewController = [[OrderViewController alloc] init];
    [[AppDelegate appDelegate].navController presentViewController:orderViewController
                                                          animated:YES
                                                        completion:nil];
}

#pragma mark - Requests

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password {
    [[KeychainAccessor sharedInstance] saveEmail:email password:password];
    [self showOrderViewController];
}

- (void)orderFoodToAddress:(NSString *)address creditCard:(NSString *)card {
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    NSString *email = [[KeychainAccessor sharedInstance] getEmail];
    NSString *password = [[KeychainAccessor sharedInstance] getPassword];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:card forKey:@"cc_nick"];
    [params setObject:address forKey:@"addr_nick"];

    [_client postPath:kOrderFoodPath
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Ordered thy food");
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Failed to sign in: %@", error);
              }];

}

- (void)saveShippingAddress:(NSDictionary *)addressComponents success:(ServerClientSuccessResponse)successHandler {
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    NSString *email = [[KeychainAccessor sharedInstance] getEmail];
    NSString *password = [[KeychainAccessor sharedInstance] getPassword];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:addressComponents];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];

    [_client postPath:kSaveShippingPath
           parameters:params
              success:successHandler
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Failed to sign in: %@", error);
              }];
}

- (void)getAllShippingAddresses:(ServerClientSuccessResponse)successHandler {
    _client.parameterEncoding = AFJSONParameterEncoding;
    [_client setDefaultHeader:@"Accept" value:@"application/json"];
    [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSString *email = [[KeychainAccessor sharedInstance] getEmail];
    NSString *password = [[KeychainAccessor sharedInstance] getPassword];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];

    [_client getPath:kGetShippingPath
          parameters:params
             success:successHandler
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Failure: %@", error);
             }];
}

- (void)getAllCreditCards:(ServerClientSuccessResponse)successHandler {
    _client.parameterEncoding = AFJSONParameterEncoding;
    [_client setDefaultHeader:@"Accept" value:@"application/json"];
    [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];

    NSString *email = [[KeychainAccessor sharedInstance] getEmail];
    NSString *password = [[KeychainAccessor sharedInstance] getPassword];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];

    [_client getPath:kGetCreditCardPath
          parameters:params
             success:successHandler
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Failure: %@", error);
             }];
}

@end
