//
//  LoginVC.h
//  Bulletin
//
//  Created by Ryan Khalili on 2/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@interface WelcomeVC : UIViewController <GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet UIButton *guestButton;

@end