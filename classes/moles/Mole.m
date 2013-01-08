//
//  Mole.m
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "Mole.h"

typedef enum
{
    MoleState_HIDDEN,
    MoleState_ANIMATING_IN,
    MoleState_ANIMATING_OUT,
    MoleState_CLICKED,
    MoleState_IDLE
} MoleState;

#pragma mark - Mole extension -

@interface Mole()
{
    MoleState state_;
    BOOL fromClick_;
}

@property (nonatomic, retain) NSTimer *dismissTimer;

@property (retain) UIImageView *imageView;

@property (retain) UIImage *defaultImage;
@property (retain) UIImage *bonkedImage;

@property (nonatomic, assign) MoleState state;
@property (assign) BOOL fromClick;

- (void)onTap;

@end

#pragma mark - Mole implementation -

@implementation Mole

@synthesize datasource = datasource_;
@synthesize delegate = delegate_;

@synthesize dismissTimer = dismissTimer_;

@synthesize imageView = imageView_;

@synthesize defaultImage = defaultImage_;
@synthesize bonkedImage = bonkedImage_;

@synthesize state = state_;
@synthesize fromClick = fromClick_;

#pragma mark - Constructor/Destructor methods -

- (id)initMole:(id<MoleDatasource>)datasource delegate:(id<MoleDelegate>)delegate
{
    self = [super init];

    if(self) 
	{
        self.datasource = datasource;
        self.delegate = delegate;
        
        self.imageView = [UIImageView object];
        self.imageView.hidden = true;
        [self addSubview:self.imageView];
        
        self.state = MoleState_HIDDEN;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tap];
        [tap release];
    }

    return self;
}

+ (id)mole:(id<MoleDatasource>)datasource delegate:(id<MoleDelegate>)delegate
{
    return [[[self alloc] initMole:datasource delegate:delegate] autorelease];
}

- (void)dealloc
{
    self.dismissTimer = nil;
    
    self.imageView = nil;
    
    self.defaultImage = nil;
    self.bonkedImage = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)invalidate
{
    self.defaultImage = [self.datasource defaultImage];
    self.bonkedImage = [self.datasource bonkedImage];
}

- (void)animateIn
{
    self.state = MoleState_ANIMATING_IN;
    
    [self.delegate moleWillAppear];
    
    self.imageView.image = self.defaultImage;
    
    self.imageView.hidden = false;
    
    CAAnimationGroup *animation = makeAnimation(kMinScale, kMaxScale, kMinAlpha, kMaxAlpha, self);
    CATransform3D transform = makeScale(kMaxScale);
    
    [self.imageView.layer addAnimation:animation forKey:nil];
    self.imageView.layer.transform = transform;
}

- (void)animateOut
{
    self.dismissTimer = nil;
    self.state = MoleState_ANIMATING_OUT;
    
    [self.delegate moleWillDismiss:self.fromClick];
    
    CAAnimationGroup *animation = makeAnimation(kMaxScale, kMinScale, kMaxAlpha, kMinAlpha, self);
    CATransform3D transform = makeScale(kMinScale);
    
    [self.imageView.layer addAnimation:animation forKey:nil];
    self.imageView.layer.transform = transform;

}

#pragma mark - Private methods -

- (void)onTap
{
    self.state = MoleState_CLICKED;
    self.fromClick = true;
    
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:kDismissDelay target:self selector:@selector(animateOut) userInfo:nil repeats:false];
    
    self.imageView.image = self.bonkedImage;
    [self.delegate userBonkedMole:self];
}

#pragma mark - Protected methods -

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = kMoleSize;
    self.frame = frame;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
 
    CGRect bounds = self.bounds;
    
    switch(self.state)
    {
        case MoleState_ANIMATING_IN:
        case MoleState_ANIMATING_OUT:
            return;
            
        default:
            break;
    }
    
    self.imageView.frame = bounds;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch(self.state)
    {
        case MoleState_ANIMATING_IN:
            [self.delegate moleDidAppear];
            self.state = MoleState_IDLE;
            break;
            
        case MoleState_ANIMATING_OUT:
            [self.delegate moleDidDismiss:self.fromClick];
            self.imageView.hidden = true;
            self.state = MoleState_HIDDEN;
            break;
            
        default:
            break;
            
    }
    
    self.fromClick = false;
}

#pragma mark - Getter/Setter methods -

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setDismissTimer:(NSTimer *)dismissTimer
{
    if([self.dismissTimer isValid])
    {
        [self.dismissTimer invalidate];
    }
    
    [[dismissTimer_ retain] autorelease];
    dismissTimer_ = [dismissTimer retain];
}

@end
