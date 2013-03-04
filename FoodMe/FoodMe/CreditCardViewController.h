//
//  CreditCardViewController.h
//  FoodMe
//
//  Created by Nick Lauer on 13-03-03.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreditCardDelegate <NSObject>
- (void)selectCreditCard:(NSDictionary *)creditCard;
@end

@interface CreditCardViewController : UITableViewController

@property (assign) id <CreditCardDelegate> delegate;

@end
