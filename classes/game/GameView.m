//
//  GameView.m
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "GameView.h"

#import "Menu.h"
#import "Mole.h"

typedef enum
{
    MenuIndex_RESUME,
    MenuIndex_QUIT
} MenuIndex;

#pragma mark - RootView extension -

@interface GameView() <MenuDelegate, MoleDatasource, MoleDelegate>
{
    int lastIndex_;
    Mole *currentMole_;
}

@property (retain) NSArray *moles;
@property (nonatomic, retain) NSTimer *timer;

@property (retain) Menu *menu;
@property (retain) UIButton *menuButton;

@property (assign) int lastIndex;
@property (readonly) int randomIndex;

@property (retain) Mole *currentMole;

@property (retain) NSArray *images;
@property (retain) NSArray *bonkedImages;
@property (assign) int currentImageIndex;
@property (readonly) int randomImageIndex;

@property (assign) BOOL isPaused;

- (void)startCountdown;

- (void)startShowTimer;
- (void)startShowTimer:(int)delay;

- (void)startDismissTimer;

- (void)stopTimer;

- (void)showMole;
- (void)dismissMole;

- (void)showMenu;

@end

#pragma mark - GameView implementation -

@implementation GameView

@synthesize delegate = delegate_;

@synthesize moles = moles_;
@synthesize timer = timer_;

@synthesize menu = menu_;
@synthesize menuButton = menuButton_;

@synthesize lastIndex = lastIndex_;
@synthesize currentMole = currentMole_;

@synthesize images = images_;
@synthesize bonkedImages = bonkedImages_;
@synthesize currentImageIndex = currentImageIndex_;

@synthesize isPaused = isPaused_;

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
        
        NSMutableArray *moles = [NSMutableArray arrayWithCapacity:kMoleCount];
        for(int i = 0; i < kMoleCount; i++)
        {
            Mole *mole = [Mole mole:self delegate:self];
            [moles addObject:mole];
            [self addSubview:mole];
        }
        
        self.moles = moles;
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.menuButton setTitle:@"b" forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
        
        NSArray *names = [NSArray arrayWithObjects:@"backpack", @"cow", @"dora", @"doraAndMonkey", @"monkey", nil];

        NSMutableArray *images = [NSMutableArray arrayWithCapacity:names.count];
        NSMutableArray *bonkedImages = [NSMutableArray arrayWithCapacity:names.count];
        
        for(NSString *name in names)
        {
            NSString *bonked = [name stringByAppendingString:@"_bonked"];
            
            UIImage *image = [UIImage imageNamed:name];
            UIImage *bonkedImage = [UIImage imageNamed:bonked];
            
            [images addObject:image];
            [bonkedImages addObject:bonkedImage];
        }
        
        self.images = images;
        self.bonkedImages = bonkedImages;
    }

    return self;
}

- (void)dealloc
{
    self.moles = nil;
    self.timer = nil;
    
    self.menu.delegate = nil;
    self.menu = nil;
    self.menuButton = nil;
    
    self.currentMole = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)startGame
{
    [self startCountdown];
}

- (void)resume
{
    self.isPaused = false;
    [self startShowTimer:kPauseTimer];
}

- (void)pause
{
    [self stopTimer];
    self.isPaused = true;
    
    [self.currentMole animateOut];
    self.currentMole = nil;
}

- (void)stop
{
    [self stopTimer];
    [self removeFromSuperview];
    [self.delegate gameViewDidDissmiss:self];
}

#pragma mark - Private methods -

- (void)startCountdown
{
    [self startShowTimer:kPauseTimer];
}

- (void)startShowTimer
{
    int delay = arc4random() % kMaxTimer;
    delay = (delay < kMinTimer ? kMinTimer : delay);
    
    [self startShowTimer:delay];
}

- (void)startShowTimer:(int)delay
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(showMole) userInfo:nil repeats:false];
}

- (void)startDismissTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDismissTimer target:self selector:@selector(dismissMole) userInfo:nil repeats:false];
}

- (void)stopTimer
{
    self.timer = nil;
}

- (void)showMole
{
    [self stopTimer];
    
    int index = self.randomIndex;
    
    self.currentMole = [self.moles objectAtIndex:index];
    [self.currentMole invalidate];
    [self.currentMole animateIn];
}

- (void)dismissMole
{
    [self stopTimer];
    
    [self.currentMole animateOut];
    self.currentMole = nil;
}

- (void)showMenu
{
    [self pause];
    
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:kResume];
    [titles addObject:kQuit];
    
    self.menu = [Menu menu:kInGameMenuTitle items:titles delegate:self];
    [self addSubview:self.menu];

    [self setNeedsLayout];
}

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGSize maxSize = bounds.size;

    for(int i = 0; i < self.moles.count; i++)
    {
        Mole *mole = [self.moles objectAtIndex:i];
        
        [mole sizeToFit];
        mole.origin = kMoleLocations[i];
    }
    
    [self.menu sizeToFit];
    [self.menu centerView];
    
    CGRect frame = self.menuButton.frame;
    frame.size = kMenuItemButtonSize;
    frame.origin.x = maxSize.width - frame.size.width;
    self.menuButton.frame = frame;
}

#pragma mark - Getter/Setter methods -

- (void)setTimer:(NSTimer *)timer
{
    if([self.timer isValid])
    {
        [self.timer invalidate];
    }
    
    [[timer_ retain] autorelease];
    timer_ = [timer retain];
}

- (int)randomIndex
{
    int index = arc4random() % kMoleCount;
    if(index == self.lastIndex)
    {
        index = [self randomIndex];
    }
    
    self.lastIndex = index;
    return index;
}

- (int)randomImageIndex
{
    if(self.images.count == 0)
    {
        return 0;
    }
    
    int index = arc4random() % (self.images.count - 1);
    if(index == self.currentImageIndex)
    {
        index = [self randomImageIndex];
    }
    
    return index;
}

#pragma mark - MenuDelegate methods -

- (void)menu:(Menu *)menu clickedAtIndex:(int)index
{
    [menu dismiss];

    switch(index)
    {
        case MenuIndex_RESUME:
            [self resume];
            break;
            
        case MenuIndex_QUIT:
            [self stop];
            break;
    }
}

- (void)menuDidDismiss:(Menu *)menu
{
    self.menu = nil;
}

#pragma mark - MoleDatasource methods -

- (UIImage *)defaultImage
{
    self.currentImageIndex = self.randomImageIndex;
    return [self.images objectAtIndex:self.currentImageIndex];
}

- (UIImage *)bonkedImage
{
    return [self.bonkedImages objectAtIndex:self.currentImageIndex];
}

#pragma mark - MoleDelegate methods -

- (void)userBonkedMole:(Mole *)mole
{
    self.currentMole = nil;
    [self startShowTimer:kPauseTimer];
}

- (void)moleWillAppear
{
    
}

- (void)moleDidAppear
{
    if(!self.isPaused)
    {
        [self startDismissTimer];
    }
}

- (void)moleWillDismiss:(BOOL)fromClick
{
    self.currentMole = nil;
}

- (void)moleDidDismiss:(BOOL)fromClick
{
    if(fromClick || self.isPaused)
    {
        return;
    }
    
    [self startShowTimer:kPauseTimer];
}

@end
