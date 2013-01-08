//
//  Menu.h
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

@class TitleItem;

@protocol MenuDelegate;

@interface Menu : UIView
{
    id<MenuDelegate> delegate_;
    
    BOOL isAnimatingIn_;
    BOOL isAnimatingOut_;
    
    TitleItem *title_;
    NSArray *menuItems_;
}

@property (assign) id<MenuDelegate> delegate;

- (id)initMenu:(NSString *)title items:(NSArray *)titles delegate:(id<MenuDelegate>)delegate;
+ (id)menu:(NSString *)title items:(NSArray *)menuItems delegate:(id<MenuDelegate>)delegate;

- (void)show;
- (void)dismiss;

@end

@protocol MenuDelegate <NSObject>

- (void)menu:(Menu *)menu clickedAtIndex:(int)index;

@optional

- (void)menuDidDismiss:(Menu *)menu;

@end