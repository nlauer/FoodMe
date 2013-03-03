//
//  ServerClient.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "ServerClient.h"

#import "AFHTTPClient.h"

#define kBaseUrl @"http://www.food.me"
#define kSignInPath @"signin"

@interface ServerClient () <NSURLConnectionDataDelegate>
@property (strong) AFHTTPClient *client;
@end

@implementation ServerClient

static id sharedInstance;

+ (ServerClient *)sharedInstance {
    static dispatch_once_t once;
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

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password {
    NSDictionary *params = @{email: email,
                             password: password};
    
    [_client postPath:kSignInPath
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"successfully signed in");
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Failed to sign in: %@", error);
              }];
}

@end
