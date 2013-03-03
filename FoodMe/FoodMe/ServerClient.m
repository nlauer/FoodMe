//
//  ServerClient.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "ServerClient.h"

#import "AFHTTPClient.h"
#import "KeychainAccessor.h"
#import "OrderViewController.h"
#import "AppDelegate.h"
#import "KeychainAccessor.h"

//#define kBaseUrl @"http://10.100.16.238:4567/"
#define kBaseUrl @"http://www.food.me"
#define kSignInPath @"signin/"
#define kOrderFoodPath @"order/"

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

- (void)orderFoodToAddress:(NSDictionary *)addressComponents {
    NSString *email = [[KeychainAccessor sharedInstance] getEmail];
    NSString *password = [[KeychainAccessor sharedInstance] getPassword];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:addressComponents];
    [params setObject:email forKey:@"Email"];
    [params setObject:password forKey:@"Password"];

    [_client postPath:kOrderFoodPath
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Ordered thy food");
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Failed to sign in: %@", error);
              }];

}

@end
