//
//  ViewController.m
//  singleView
//
//  Created by Dhanush Balachandran on 10/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SignUpSignInViewController.h"
#import "UserProfileViewController.h"
#import "SurveyViewController.h"
#import "SchedulesTableViewController.h"
#import <BridgeSDK/BridgeSDK.h>

@interface ViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreBarButtonItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (((AppDelegate*)[UIApplication sharedApplication].delegate).isLoggedIn) {
        [self didTouchMoreBarButtonitem:nil];
    }
    else
    {
        // show sign up/sign in screen, and upon successful completion call uponLogin
        UIStoryboard *sus = [UIStoryboard storyboardWithName:@"SignUpSignIn" bundle:nil];
        SignUpSignInViewController *suvc = [sus instantiateInitialViewController];
        [self.navigationController pushViewController:suvc animated:YES];
    }
}


- (IBAction)didTouchMoreBarButtonitem:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do what?"
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Sign Up/Sign In", @"Sign Up/Sign In"),
                                  NSLocalizedString(@"Sign Out", @"Sign Out"),
                                  NSLocalizedString(@"Profile & Consent", @"Profile & Consent"),
                                  NSLocalizedString(@"Survey", @"Survey"),
                                  NSLocalizedString(@"Upload", @"Upload"),
                                  NSLocalizedString(@"Schedule", @"Schedule"),
                                  nil];
    [actionSheet showFromBarButtonItem:self.moreBarButtonItem animated:YES];
}

typedef NS_ENUM(NSInteger, _ActionButtons) {
  asCancel = -1,
  asSignUpSignIn,
  asSignOut,
  asProfileConsent,
  asSurvey,
  asUpload,
  asSchedule
};

#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case asCancel:
            break;
            
        case asSignUpSignIn:
        {
            UIStoryboard *sus = [UIStoryboard storyboardWithName:@"SignUpSignIn" bundle:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                SignUpSignInViewController *suvc = [sus instantiateInitialViewController];
                [self.navigationController pushViewController:suvc animated:YES];
            });
        }
            break;
            
        case asSignOut:
        {
            [SBBComponent(SBBAuthManager) signOutWithCompletion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ((AppDelegate*)[UIApplication sharedApplication].delegate).loggedIn = NO;
                    UIStoryboard *sus = [UIStoryboard storyboardWithName:@"SignUpSignIn" bundle:nil];
                    SignUpSignInViewController *suvc = [sus instantiateInitialViewController];
                    [self.navigationController pushViewController:suvc animated:YES];
                });
            }];
        }
            break;
            
        case asProfileConsent:
        {
            UIStoryboard *ups = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
            UserProfileViewController *upvc = [ups instantiateInitialViewController];
            [self.navigationController pushViewController:upvc animated:YES];
        }
            break;
            
        case asSurvey:
        {
            UIStoryboard *ss = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
            SurveyViewController *svc = [ss instantiateInitialViewController];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
            
        case asUpload:
        {
            NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"cat" withExtension:@"jpg"];
            [SBBComponent(SBBUploadManager) uploadFileToBridge:fileUrl contentType:@"image/jpeg" completion:^(NSError *error) {
                if (error) {
                    NSLog(@"Error uploading file:\n%@", error);
                } else {
                    NSLog(@"Uploaded file");
                }
            }];
        }
            break;
            
      case asSchedule:
      {
        UIStoryboard *ss = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
        SchedulesTableViewController *stvc = [ss instantiateInitialViewController];
        [self.navigationController pushViewController:stvc animated:YES];
      }
        break;
        
        default:
            break;
    }
}

@end