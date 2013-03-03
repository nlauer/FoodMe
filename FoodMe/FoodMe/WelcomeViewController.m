//
//  ViewController.m
//  FoodMe
//
//  Created by Nick Lauer on 13-03-02.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "WelcomeViewController.h"

#import "ServerClient.h"

@interface WelcomeViewController ()
@property (strong) IBOutlet UITextField *emailTextField;
@property (strong) IBOutlet UITextField *passwordTextField;
@property (strong) IBOutlet UIButton *signInButton;

- (IBAction)signInPressed:(id)sender;
@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Login";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInPressed:(id)sender {
    NSLog(@"Sign In Pressed");
    NSString *email = _emailTextField.text;
    NSString *password = _passwordTextField.text;

    [[ServerClient sharedInstance] signInWithEmail:email
                                          password:password];
}



@end
