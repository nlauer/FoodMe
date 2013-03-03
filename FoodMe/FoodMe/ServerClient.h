//
//  ServerClient.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerClient : NSObject

+ (ServerClient *)sharedInstance;
- (void)signInWithEmail:(NSString *)email password:(NSString *)password;
- (void)orderFood;

@end
