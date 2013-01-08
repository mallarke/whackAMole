//
//  GameView.h
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

@class Menu;

@protocol GameViewDelegate;

@interface GameView : UIView
{
    id<GameViewDelegate> delegate_;
    
    NSArray *moles_;
    NSTimer *timer_;

    UIButton *menuButton_;
    
    NSArray *images_;
    NSArray *bonkedImages_;
    int currentImageIndex_;
    
    BOOL isPaused_;
}

@property (assign) id<GameViewDelegate> delegate;

- (void)startGame;

- (void)resume;
- (void)pause;
- (void)stop;

@end

@protocol GameViewDelegate <NSObject>

- (void)gameViewDidDissmiss:(GameView *)gameView;

@end