//
//  LaunchScreen.h
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Menu;
@class GameView;

@interface LaunchScreen : UIView
{
    Menu *menu_;
    GameView *gameView_;
}

- (void)showMenu;
- (void)dismissMenu;

@end
