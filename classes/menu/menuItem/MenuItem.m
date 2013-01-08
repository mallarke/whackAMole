//
//  MenuItem.m
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "MenuItem.h"

static const CGFloat kPadding = 2;

#pragma mark - TitleItem extension -

@interface TitleItem()

@property (retain) UIButton *button;

@property (readonly) UIImage *backgroundImage;
@property (readonly) UIImage *downImage;

@property (readonly) UIFont *font;

- (void)onButtonPress;

@end

#pragma mark - TitleItem implementation -

@implementation TitleItem

@synthesize button = button_;

#pragma mark - Constructor/Destructor methods -

- (id)initTitleItem:(NSString *)title
{
    self = [super init];
    
    if(self)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:title forState:UIControlStateNormal];
        self.button.titleLabel.font = self.font;
        [self.button setBackgroundImage:self.backgroundImage forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.downImage forState:UIControlStateSelected];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.button.titleLabel.shadowColor = [UIColor whiteColor];
        self.button.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self.button addTarget:self action:@selector(onButtonPress) forControlEvents:UIControlEventTouchUpInside];
        
        self.button.userInteractionEnabled = false;
        [self addSubview:self.button];
    }
    
    return self;
}

+ (id)titleItem:(NSString *)title
{
    return [[[self alloc] initTitleItem:title] autorelease];
}

- (void)dealloc
{
    self.button = nil;
    [super dealloc];
}

#pragma mark - Private methods -

- (void)onButtonPress {}

#pragma mark - Protected methods -

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = self.size;
    self.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.button.frame = bounds;
}

#pragma mark - Getter/Setter methods -

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"titleBoard"];
}

- (UIImage *)downImage
{
    return nil;
}

- (CGSize)size
{
    return kMenuTitleSize;
}

- (UIFont *)font
{
    return kMenuTitleFont;
}

@end

#pragma mark - MenuItem extension -

@interface MenuItem()

@property (retain) UIImageView *ropes;
@property (assign) int index;

@end

#pragma mark - MenuItem implementation -

@implementation MenuItem

@synthesize delegate = delegate_;

@synthesize ropes = ropes_;
@synthesize index = index_;

#pragma mark - Constructor/Destructor methods -

- (id)initMenuItem:(NSString *)title index:(int)index delegate:(id<MenuItemDelegate>)delegate
{
    self = [super initTitleItem:title];

    if(self) 
	{
        self.delegate = delegate;
        self.index = index;
        
        self.button.userInteractionEnabled = true;
        
        self.ropes = [UIImageView object];
        self.ropes.image = [UIImage imageNamed:@"ropes"];
        [self insertSubview:self.ropes belowSubview:self.button];
    }

    return self;
}

+ (id)menuItem:(NSString *)title index:(int)index delegate:(id<MenuItemDelegate>)delegate
{
    return [[[self alloc] initMenuItem:title index:index delegate:delegate] autorelease];
}

- (void)dealloc
{    
	[super dealloc];
}

#pragma mark - Protected methods -

- (void)onButtonPress
{
    [self.delegate menuItemClicked:self.index];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGSize maxSize = bounds.size;
    
    [self.ropes sizeToFit];
    
    CGRect frame = self.ropes.frame;
    frame.origin.y = -kPadding;
    frame.origin.x = (maxSize.width - frame.size.width) / 2.0;
    self.ropes.frame = frame;
    
    CGFloat y = frame.size.height - (kPadding * 2);
    
    frame = self.button.frame;
    frame.origin.y = y;
    frame.size = kMenuItemSize;
    self.button.frame = frame;
}

#pragma mark - Getter/Setter methods -

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"menuItem"];
}

- (UIImage *)downImage
{
    return nil;
}

- (CGSize)size
{
    CGFloat height = self.ropes.image.size.height;
    CGSize size = kMenuItemSize;
    size.height += height;
    size.height -= kPadding * 2;
    
    return size;
}

- (UIFont *)font
{
    return kMenuItemFont;
}

@end
