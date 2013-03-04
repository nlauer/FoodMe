//
//  UITableViewCell+AccountSettings.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (AccountSettings)

- (void)setupAsShippingAddressCell;
- (void)setupAsPreferencesCell;
- (void)setupAsCreditCardCell;

@end
