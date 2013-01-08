//
//  AppDelegate.h
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LaunchScreenViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window_;
    LaunchScreenViewController *rootViewController_;
}

@property (nonatomic, retain) UIWindow *window;
@property (retain) LaunchScreenViewController *viewController;

@end
