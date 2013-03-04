//
//  YouGotFoodViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "YouGotFoodViewController.h"

@interface YouGotFoodViewController ()
@property (strong) IBOutlet UILabel *infoLabel;
- (IBAction)viewWasPressed:(id)sender;
@end

@implementation YouGotFoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_infoLabel performSelector:@selector(setText:) withObject:@"Scanning Menu..." afterDelay:2.0];
    [_infoLabel performSelector:@selector(setText:) withObject:@"Found Amazing Meal!" afterDelay:4.0];
//    [_infoLabel performSelector:@selector(setText:) withObject:@"You Got: 15 sides of fries" afterDelay:5.0];
//    [_infoLabel performSelector:@selector(setText:) withObject:@"Just kidding!" afterDelay:8.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
