//
//  MenuItem.h
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

@interface TitleItem : UIView
{
    UIButton *button_;
}

@property (readonly) CGSize size;

- (id)initTitleItem:(NSString *)title;
+ (id)titleItem:(NSString *)title;

@end

@protocol MenuItemDelegate;

@interface MenuItem : TitleItem
{
    id<MenuItemDelegate> delegate_;

    UIImageView *ropes_;
    int index_;
}

@property (assign) id<MenuItemDelegate> delegate;

- (id)initMenuItem:(NSString *)title index:(int)index delegate:(id<MenuItemDelegate>)delegate;
+ (id)menuItem:(NSString *)title index:(int)index delegate:(id<MenuItemDelegate>)delegate;

@end

@protocol MenuItemDelegate <NSObject>

- (void)menuItemClicked:(int)index;

@end