//
//  ViewController.m
//  SSOTester
//
//  Created by Andres El Ropero on 4/12/16.
//  Copyright © 2016 Proto. All rights reserved.
//

#import "ViewController.h"

// 3rd Party Libs
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Helpers
#import "SharedLoginManager.h"

static NSString * const kNotLoggedInText = @"Let's get you logged in bud";

@interface ViewController () <FBSDKLoginButtonDelegate>

@property IBOutlet FBSDKLoginButton *fbLoginButton;
@property IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [[NSBundle mainBundle] bundleIdentifier];
    
    self.fbLoginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
    [self lookupAccessToken];
}


- (void)lookupAccessToken

{
    // lookup the access token
    FBSDKAccessToken *token = [[SharedLoginManager sharedInstance] loadFacebookAccessToken];
    if (token) {
        NSLog(@"found access token with string: %@", token.tokenString);
        [FBSDKAccessToken setCurrentAccessToken:token];
        [self fetchUserInfo];
    }
    else {
        NSLog(@"not access token found");
        self.statusLabel.text = kNotLoggedInText;
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
}

- (void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"result is:%@",result);
                 self.statusLabel.text = [NSString stringWithFormat:@"Hey there, %@", result[@"name"]];
             }
             else
             {
                 NSLog(@"Error %@",error);
                 self.statusLabel.text = kNotLoggedInText;
             }
         }];
    }
    else {
        self.statusLabel.text = kNotLoggedInText;
    }
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    if (error) {
        NSLog(@"FB login error: %@", error);
    }
    else {
        NSLog(@"FB login success, token: %@", result.token);
        [[SharedLoginManager sharedInstance] storeFacebookAccessToken:result.token];
        [self fetchUserInfo];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"FB: logged out");
    
    [[SharedLoginManager sharedInstance] clearFacebookAccessToken];
}




@end
