//
//  KeychainAccessor.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainAccessor : NSObject

+ (KeychainAccessor *)sharedInstance;

- (BOOL)hasCredentials;
- (void)clearKeychain;
- (void)saveEmail:(NSString *)email password:(NSString *)password;
- (NSString *)getPassword;
- (NSString *)getEmail;

@end
