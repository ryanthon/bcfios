//
//  LoginVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 2/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "WelcomeVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

static NSString *kClientID = @"721838208355-n2mvqa3p2rc7te8antv6vnrknabat9ka.apps.googleusercontent.com";

@interface WelcomeVC ()

@property (retain, nonatomic) GPPSignInButton *signInButton;

@end

@implementation WelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[ @"profile" ];
    
    signIn.delegate = self;
    
    self.signInButton = [[GPPSignInButton alloc] initWithFrame:CGRectMake(60, 200, 200, 40)];
    [self.view addSubview:self.signInButton];
    
    self.guestButton.layer.cornerRadius = 10;
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if( !error )
    {
        GPPSignIn *gPlusSignIn = [GPPSignIn sharedInstance];
        
        [[NSUserDefaults standardUserDefaults] setObject:gPlusSignIn.authentication.userEmail forKey:@"UserEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"First Launch"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[APIManager sharedManager] addNewUserWithEmail:gPlusSignIn.authentication.userEmail
        response:^(NSError *error, id response)
        {
            [[APIManager sharedManager] getUIDForEmail:gPlusSignIn.authentication.userEmail
            response:^(NSError *error, id response)
            {
                NSString *uid = [response[@"uid"][0][@"uid"] stringValue];
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    }
}

@end
