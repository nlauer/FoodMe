//
//  UITableViewCell+AccountSettings.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "UITableViewCell+AccountSettings.h"

@implementation UITableViewCell (AccountSettings)

- (void)setupAsShippingAddressCell {
    [self.textLabel setText:@"Delivery:"];
}

- (void)setupAsPreferencesCell {
    [self.textLabel setText:@"Preferences:"];
}

- (void)setupAsCreditCardCell {
    [self.textLabel setText:@"Credit Card:"];
}

@end
