//
//  ShippingAddressViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "ShippingAddressViewController.h"

#import "ShippingAddressEditViewController.h"
#import "ServerClient.h"

#define kReuseIdentifier @"shippingAddressCell"

@interface ShippingAddressViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong) IBOutlet UITableView *tableView;
@end

@implementation ShippingAddressViewController {
    NSMutableArray *addresses;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"DELIVERY";
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[ServerClient sharedInstance] getAllShippingAddresses:^(AFHTTPRequestOperation *operation, id responseObject) {
        addresses = [[NSMutableArray alloc] init];
        [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [addresses addObject:obj];
        }];
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kReuseIdentifier];
    }

    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Enter new address"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setText:[[addresses objectAtIndex:indexPath.row - 1] objectForKey:@"addr"]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ShippingAddressEditViewController *editViewController = [[ShippingAddressEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:editViewController animated:YES];
    } else {
        [_delegate selectAddress:[addresses objectAtIndex:indexPath.row - 1]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
