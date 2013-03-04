//
//  OrderViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "OrderViewController.h"

#import "ServerClient.h"
#import "YouGotFoodViewController.h"
#import "UITableViewCell+AccountSettings.h"
#import "ShippingAddressViewController.h"
#import "CreditCardViewController.h"
#import "FoodPreferencesViewController.h"

#define kReuseIdentifier @"accountSettingCell"

@interface OrderViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, ShippingDelegate, CreditCardDelegate>
@property (strong) IBOutlet UITextField *streetTextField;
@property (strong) IBOutlet UITextField *cityTextField;
@property (strong) IBOutlet UITextField *stateTextField;
@property (strong) IBOutlet UITextField *postalCodeTextField;
@property (strong) IBOutlet UITableView *tableView;
@property (strong) IBOutlet UIButton *foodMeButton;

- (IBAction)foodMePressed:(id)sender;
@end

@implementation OrderViewController {
    NSDictionary *selectedAddress;
    NSDictionary *selectedCreditCard;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"FEEDME";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)foodMePressed:(id)sender {
    [[ServerClient sharedInstance] orderFoodToAddress:[selectedAddress objectForKey:@"nick"] creditCard:[selectedCreditCard objectForKey:@"nick"]];
    YouGotFoodViewController *youGotFoodViewController = [[YouGotFoodViewController alloc] initWithNibName:@"YouGotFoodViewController" bundle:nil];
    [self.navigationController presentViewController:youGotFoodViewController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{
        [_foodMeButton setAlpha:1.0];
    }];
    return YES;
}

#pragma mark - Shipping Delegate

- (void)selectAddress:(NSDictionary *)address {
    selectedAddress = address;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Shipping Delegate

- (void)selectCreditCard:(NSDictionary *)creditCard {
    selectedCreditCard = creditCard;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

enum TableViewCellType : NSUInteger {
    TableViewCellShippingAddress = 0,
    TableViewCellCreditCard= 1,
    TableViewCellPreferences = 2,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kReuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    switch (indexPath.row) {
        case TableViewCellShippingAddress:
            [cell setupAsShippingAddressCell];
            [cell.detailTextLabel setText:[selectedAddress objectForKey:@"addr"]];
            break;
        case TableViewCellPreferences:
            [cell setupAsPreferencesCell];
            [cell.detailTextLabel setText:@"Vegetarian"];
            break;
        case TableViewCellCreditCard:
            [cell setupAsCreditCardCell];
            if (selectedCreditCard) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"***********%@", [selectedCreditCard objectForKey:@"cc_last5"]]];
            }
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case TableViewCellShippingAddress: {
            ShippingAddressViewController *controller = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:nil];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case TableViewCellPreferences: {
            FoodPreferencesViewController *controller = [[FoodPreferencesViewController alloc] initWithNibName:@"FoodPreferencesViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case TableViewCellCreditCard: {
            CreditCardViewController *controller = [[CreditCardViewController alloc] initWithNibName:@"CreditCardViewController" bundle:nil];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

@end
