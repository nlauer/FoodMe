//
//  ShippingAddressEditViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "ShippingAddressEditViewController.h"

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ServerClient.h"

@interface ShippingAddressEditViewController ()

@end

@implementation ShippingAddressEditViewController {
    NSDictionary *_addressComponents;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"NEW ADDRESS";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;

    [[LocationManager sharedInstance] getStreetAddress:^(NSArray *placemark, NSError *error) {
        CLPlacemark *bestPlacemark = [placemark objectAtIndex:0];
        _addressComponents = [bestPlacemark addressDictionary];
        [self.tableView reloadData];
        [[self.view viewWithTag:1000] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1000 + indexPath.row];
        if (!textField) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 20)];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.returnKeyType = UIReturnKeyNext;
            textField.backgroundColor = [UIColor clearColor];
            textField.textAlignment = NSTextAlignmentLeft;
            textField.tag = 1000 + indexPath.row;

            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField setEnabled: YES];

            [cell.contentView addSubview:textField];
        }
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Street:"];
                [textField setText:[_addressComponents objectForKey:@"Name"]];
                break;
            case 1:
                [cell.textLabel setText:@"City:"];
                [textField setText:[_addressComponents objectForKey:@"City"]];
                break;
            case 2: {
                [cell.textLabel setText:@"State:"];
                NSArray *formattedAddress = [_addressComponents objectForKey:@"FormattedAddressLines"];
                NSString *cityState = [formattedAddress objectAtIndex:1];
                NSString *stateExtended = [[cityState componentsSeparatedByString:@", "] objectAtIndex:1];
                NSString *state = [stateExtended substringWithRange:NSMakeRange(0, 2)];
                [textField setText:state];
                break;
            }
            case 3:
                [cell.textLabel setText:@"ZIP:"];
                [textField setText:[_addressComponents objectForKey:@"ZIP"]];
                break;
        }
    } else if (indexPath.section == 1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell.textLabel setText:@"SAVE    "];
        [cell setIndentationLevel:12];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Post this to the server
    if(indexPath.section == 1) {
        NSMutableDictionary *addressComponents = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 4; i++) {
            UITextField *textField = (UITextField *)[self.view viewWithTag:1000 + i];
            NSString *key;
            switch (i) {
                case 0:
                    key = @"address";
                    break;
                case 1:
                    key = @"city";
                    break;
                case 2:
                    key = @"state";
                    break;
                case 3:
                    key = @"zip";
                    break;
            }
            [addressComponents setObject:textField.text forKey:key];
        }
        [addressComponents setObject:@"4155353812" forKey:@"phone_number"];
        [[ServerClient sharedInstance] saveShippingAddress:addressComponents
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }];
    }
}

@end