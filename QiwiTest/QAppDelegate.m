//
//  QAppDelegate.m
//  QiwiTest
//
//  Created by Константин Тупицин on 10.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QAppDelegate.h"
#import "QUserListViewController.h"
#import "QUserBalancesViewController.h"
#import "QUserViewModel.h"

@interface QAppDelegate() <UISplitViewControllerDelegate>

@end

@implementation QAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rootVC = nil;
    if(IS_PAD) {
        UISplitViewController *splitVC = [UISplitViewController new];
        [splitVC setViewControllers:@[[QUserListViewController new], [QUserBalancesViewController new]]];
        splitVC.delegate = self;
        rootVC = splitVC;
    } else {
        rootVC = [[UINavigationController alloc] initWithRootViewController:[QUserListViewController new]];
    }
    
    self.window.rootViewController = rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

@end
