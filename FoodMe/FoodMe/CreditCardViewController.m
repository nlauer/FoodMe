//
//  CreditCardViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-03.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "CreditCardViewController.h"

#import "CreditCardEditViewController.h"
#import "ServerClient.h"

#define kReuseIdentifier @"creditCardCell"

@interface CreditCardViewController ()

@end

@implementation CreditCardViewController {
    NSMutableArray *creditCards;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"CARDS";
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[ServerClient sharedInstance] getAllCreditCards:^(AFHTTPRequestOperation *operation, id responseObject) {
        creditCards = [[NSMutableArray alloc] init];
        [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [creditCards addObject:obj];
        }];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [creditCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kReuseIdentifier];
    }

    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Enter new card"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setText:[NSString stringWithFormat:@"***********%@", [[creditCards objectAtIndex:indexPath.row - 1] objectForKey:@"cc_last5"]]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        CreditCardEditViewController *editViewController = [[CreditCardEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:editViewController animated:YES];
    } else {
        [_delegate selectCreditCard:[creditCards objectAtIndex:indexPath.row - 1]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
