//
//  LaunchScreen.m
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "LaunchScreen.h"

#import "Menu.h"
#import "GameView.h"

typedef enum
{
    MenuIndex_PLAYGAME
} MenuIndex;

#pragma mark - LaunchScreen extension -

@interface LaunchScreen() <MenuDelegate, GameViewDelegate>

@property (retain) Menu *menu;
@property (retain) GameView *gameView;

- (void)startGame;

@end

#pragma mark - LaunchScreen implementation -

@implementation LaunchScreen

@synthesize menu = menu_;
@synthesize gameView = gameView_;

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
        
        NSMutableArray *titles = [NSMutableArray array];
        [titles addObject:@"Play game"];
        
        self.menu = [Menu menu:kLaunchMenuTitle items:titles delegate:self];
        [self addSubview:self.menu];
    }

    return self;
}

- (void)dealloc
{
    self.menu = nil;
    self.gameView = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)showMenu
{
    [self.menu show];
}

- (void)dismissMenu
{
    [self.menu dismiss];
}

#pragma mark - Private methods -

- (void)startGame
{
    self.gameView = [GameView object];
    self.gameView.frame = self.bounds;
    self.gameView.delegate = self;
    [self addSubview:self.gameView];
    
    [self.gameView startGame];
}

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];

    [self.menu sizeToFit];
    [self.menu centerView];
}

#pragma mark - MenuDelegate methods -

- (void)menu:(Menu *)menu clickedAtIndex:(int)index
{
    switch(index)
    {
        case MenuIndex_PLAYGAME:
            [self startGame];
            break;
    }
}

#pragma mark - GameViewDelegate methods -

- (void)gameViewDidDissmiss:(GameView *)gameView
{
    self.gameView = nil;
}

@end
