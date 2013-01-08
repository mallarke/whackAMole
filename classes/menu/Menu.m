//
//  Menu.m
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "Menu.h"

#import "MenuItem.h"

static const CGFloat kTitleY = 35;

static const CGFloat kPaddingX = 110;
static const CGFloat kPaddingWidth = 145;
static const CGFloat kPaddingHeight = 70;

static const CGFloat kMenuItemPadding = 12;

static const int kOffsetMenuItemMin = 2;
static const int kOffsetMenuItemMax = 3;

#pragma mark - Menu extension -

@interface Menu() <MenuItemDelegate>

@property (assign) BOOL isAnimatingIn;
@property (assign) BOOL isAnimatingOut;

@property (retain) TitleItem *title;
@property (retain) NSArray *menuItems;

@end

#pragma mark - Menu implementation -

@implementation Menu

@synthesize delegate = delegate_;

@synthesize isAnimatingIn = isAnimatingIn_;
@synthesize isAnimatingOut = isAnimatingOut_;

@synthesize title = title_;
@synthesize menuItems = menuItems_;

#pragma mark - Constructor/Destructor methods -

- (id)initMenu:(NSString *)title items:(NSArray *)titles delegate:(id<MenuDelegate>)delegate
{
    self = [super init];

    if(self) 
	{
        self.delegate = delegate;
        self.layer.contents = (id)[UIImage imageNamed:@"menu"].CGImage;
        
        self.title = [TitleItem titleItem:title];
        [self addSubview:self.title];
        
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
        for(int i = 0; i < titles.count; i++)
        {
            NSString *title = [titles objectAtIndex:i];
            
            MenuItem *item = [MenuItem menuItem:title index:i delegate:self];
            [items addObject:item];
            [self addSubview:item];
        }
        
        self.menuItems = items;
    }

    return self;
}

+ (id)menu:(NSString *)title items:(NSArray *)menuItems delegate:(id<MenuDelegate>)delegate
{
    return [[[self alloc] initMenu:title items:menuItems delegate:delegate] autorelease];
}

- (void)dealloc
{
    self.title = nil;
    self.menuItems = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)show
{
    self.isAnimatingIn = true;
    
    CAAnimationGroup *animation = makeAnimation(kMinScale, 1.0, kMinAlpha, 1.0, self);
    [self.layer addAnimation:animation forKey:nil];
}

- (void)dismiss
{
    self.isAnimatingOut = true;
    
    CAAnimationGroup *animation = makeAnimation(1.0, kMinScale, 1.0, kMinAlpha, self);
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)centerView
{
    [super centerView];
    
    CGRect frame = self.frame;
    frame.origin.y = 130;
    self.frame = frame;
}

- (void)sizeToFit
{
    CGSize size = self.title.size;
    
    for(MenuItem *item in self.menuItems)
    {
        size.height+= item.size.height;
    }
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

    if(self.isAnimatingIn || self.isAnimatingOut)
    {
        return;
    }
    
	CGRect bounds = self.bounds;
	CGSize maxSize = bounds.size;
    
    [self.title sizeToFit];
    
    CGFloat y = self.title.size.height;
    
    for(MenuItem *item in self.menuItems)
    {
        [item sizeToFit];
        
        CGRect frame = item.frame;
        frame.origin.x = (maxSize.width - frame.size.width) / 2.0;
        frame.origin.y = y;
        item.frame = frame;
        
        y += item.size.height;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.isAnimatingOut)
    {
        if([self.delegate respondsToSelector:@selector(menuDidDismiss:)])
        {
            [self.delegate menuDidDismiss:self];
        }
        
        self.hidden = true;
        [self removeFromSuperview];
    }
    
    self.isAnimatingIn = false;
    self.isAnimatingOut = false;
}

#pragma mark - MenuItemDelegate methods -

- (void)menuItemClicked:(int)index
{
    [self.delegate menu:self clickedAtIndex:index];
}

@end
