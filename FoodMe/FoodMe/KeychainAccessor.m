//
//  KeychainAccessor.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "KeychainAccessor.h"

#import "KeychainItemWrapper.h"

@interface KeychainAccessor ()
@property (strong) KeychainItemWrapper *keychainItem;
@end

@implementation KeychainAccessor

+ (KeychainAccessor *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"FoodMe" accessGroup:nil];
    }

    return self;
}

- (BOOL)hasCredentials {
    NSString *password = [self getPassword];
    NSString *email = [self getEmail];
    NSLog(@"password: %@ email: %@", password, email);
    if (password.length > 0 && email.length > 0) {
        return YES;
    }

    return NO;
}

- (void)clearKeychain {
    [_keychainItem resetKeychainItem];
}

- (void)saveEmail:(NSString *)email password:(NSString *)password {
    [_keychainItem setObject:password forKey:kSecValueData];
    [_keychainItem setObject:email forKey:kSecAttrAccount];
}

- (NSString *)getPassword {
    return (NSString *)[_keychainItem objectForKey:kSecValueData];
}

- (NSString *)getEmail {
        return (NSString *)[_keychainItem objectForKey:kSecAttrAccount];
}

@end
