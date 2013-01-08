//
//  LaunchScreenViewController.m
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "LaunchScreenViewController.h"

#import "LaunchScreen.h"

#pragma mark - LaunchScreenViewController extension -

@interface LaunchScreenViewController()

@property (readonly) LaunchScreen *launchScreen;

@end

#pragma mark - LaunchScreenViewController implementation -

@implementation LaunchScreenViewController

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self)
	{
    }

    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - View lifecycle methods -

- (void)loadView
{
    self.view = [LaunchScreen object];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.launchScreen showMenu];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (LaunchScreen *)launchScreen
{
    return (LaunchScreen *)self.view;
}

@end
