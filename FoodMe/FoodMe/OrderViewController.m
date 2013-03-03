//
//  OrderViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "OrderViewController.h"

#import "ServerClient.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "YouGotFoodViewController.h"

@interface OrderViewController () <UITextFieldDelegate>
@property (strong) IBOutlet UITextField *streetTextField;
@property (strong) IBOutlet UITextField *cityTextField;
@property (strong) IBOutlet UITextField *stateTextField;
@property (strong) IBOutlet UITextField *postalCodeTextField;
@property (strong) IBOutlet UIButton *foodMeButton;

- (IBAction)foodMePressed:(id)sender;
@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Order";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[LocationManager sharedInstance] getStreetAddress:^(NSArray *placemark, NSError *error) {
        CLPlacemark *bestPlacemark = [placemark objectAtIndex:0];
        NSDictionary *addressComponents = [bestPlacemark addressDictionary];
        [self setupTextFieldsWithAddressComponents:addressComponents];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextFieldsWithAddressComponents:(NSDictionary *)addressComponents {
    [_streetTextField setText:[addressComponents objectForKey:@"Name"]];
    [_cityTextField setText:[addressComponents objectForKey:@"City"]];
    [_stateTextField setText:[addressComponents objectForKey:@"State"]];
    [_postalCodeTextField setText:[addressComponents objectForKey:@"ZIP"]];

    [self fadeInTextFields];
}

- (void)fadeInTextFields {
    [_streetTextField becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_streetTextField setAlpha:1.0];
        [_cityTextField setAlpha:1.0];
        [_stateTextField setAlpha:1.0];
        [_postalCodeTextField setAlpha:1.0];
    }];
}

- (IBAction)foodMePressed:(id)sender {
    NSDictionary *addressComponents = @{@"Street": _streetTextField.text,
                                        @"City": _cityTextField.text,
                                        @"State": _stateTextField.text,
                                        @"ZIP": _postalCodeTextField.text};
    [[ServerClient sharedInstance] orderFoodToAddress:addressComponents];

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

@end
