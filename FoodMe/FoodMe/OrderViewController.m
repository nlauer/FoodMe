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

@interface OrderViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, ShippingDelegate, CreditCardDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong) IBOutlet UILabel *priceSliderLabel;
@property (strong) IBOutlet UISlider *priceSlider;
@property (strong) IBOutlet UITableView *tableView;
@property (strong) IBOutlet UIButton *foodMeButton;

- (IBAction)foodMePressed:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
@end

@implementation OrderViewController {
    NSDictionary *selectedAddress;
    NSDictionary *selectedCreditCard;
    NSString *price;
    UIPickerView *picker;
    UIActionSheet *sheet;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"FEEDME";
        price = @"15.00";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)foodMePressed:(id)sender {
    [[ServerClient sharedInstance] orderFoodToAddress:[selectedAddress objectForKey:@"nick"]
                                           creditCard:[selectedCreditCard objectForKey:@"nick"]
                                                price:price];
    YouGotFoodViewController *youGotFoodViewController = [[YouGotFoodViewController alloc] initWithNibName:@"YouGotFoodViewController" bundle:nil];
    [self.navigationController presentViewController:youGotFoodViewController animated:YES completion:nil];
}

-(IBAction)sliderValueChanged:(id)sender {
    [_priceSliderLabel setText:[NSString stringWithFormat:@"$%i", (int)round(_priceSlider.value)]];
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

#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 86;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"$%i.00", row + 15];
}

- (void)dismissActionSheet {
    price = [NSString stringWithFormat:@"%i.00", [picker selectedRowInComponent:0] + 15];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

enum TableViewCellType : NSUInteger {
    TableViewCellShippingAddress = 0,
    TableViewCellCreditCard= 1,
    TableViewCellPreferences = 2,
    TableViewCellPrice = 3
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
            [cell.detailTextLabel setText:@"Omnivore"];
            break;
        case TableViewCellCreditCard:
            [cell setupAsCreditCardCell];
            if (selectedCreditCard) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"***********%@", [selectedCreditCard objectForKey:@"cc_last5"]]];
            }
            break;
        case TableViewCellPrice:
            [cell.textLabel setText:@"Price:"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%@", price]];
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
        case TableViewCellPrice: {
            sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                delegate:nil
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil];

            [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];

            CGRect pickerFrame = CGRectMake(0, 40, 0, 0);

            picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
            picker.showsSelectionIndicator = YES;
            picker.dataSource = self;
            picker.delegate = self;

            [sheet addSubview:picker];

            UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
            closeButton.momentary = YES;
            closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
            closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
            closeButton.tintColor = [UIColor blackColor];
            [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
            [sheet addSubview:closeButton];
            
            [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
            
            [sheet setBounds:CGRectMake(0, 0, 320, 485)];
        }
    }
}

@end
