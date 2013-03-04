//
//  CreditCardEditViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-03.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "CreditCardEditViewController.h"

@interface CreditCardEditViewController ()

@end

@implementation CreditCardEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        self.title = @"NEW CARD";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
            return 6;
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
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 155, 30)];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.returnKeyType = UIReturnKeyNext;
            textField.backgroundColor = [UIColor clearColor];
            textField.textAlignment = NSTextAlignmentLeft;
            textField.tag = 1000 + indexPath.row;
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];

            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField setEnabled: YES];

            [cell.contentView addSubview:textField];
        }
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"First name"];
                break;
            case 1:
                [cell.textLabel setText:@"Last name"];
                break;
            case 2:
                [cell.textLabel setText:@"Expiry month"];
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 3:
                [cell.textLabel setText:@"Expiry year"];
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 4:
                [cell.textLabel setText:@"Card no."];
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 5:
                [cell.textLabel setText:@"Cvc"];
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 6:
                [cell.textLabel setText:@"Address"];
                break;

            default:
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end