//
//  AppDelegate.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelcomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

+ (AppDelegate *)appDelegate;

@end
