//
//  ShippingAddressViewController.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShippingDelegate <NSObject>
- (void)selectAddress:(NSDictionary *)address;
@end

@interface ShippingAddressViewController : UIViewController

@property (assign) id <ShippingDelegate> delegate;

@end
