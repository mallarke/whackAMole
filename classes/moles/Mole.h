//
//  Mole.h
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoleDatasource;
@protocol MoleDelegate;

@interface Mole : UIView
{
    id<MoleDatasource> datasource_;
    id<MoleDelegate> delegate_;
    
    NSTimer *dismissTimer_;
    
    UIImageView *imageView_;
    
    UIImage *defaultImage_;
    UIImage *bonkedImage_;
}

@property (assign) id<MoleDatasource> datasource;
@property (assign) id<MoleDelegate> delegate;

@property (assign) CGPoint origin;

- (id)initMole:(id<MoleDatasource>)datasource delegate:(id<MoleDelegate>)delegate;
+ (id)mole:(id<MoleDatasource>)datasource delegate:(id<MoleDelegate>)delegate;

- (void)invalidate;

- (void)animateIn;
- (void)animateOut;

@end

@protocol MoleDatasource <NSObject>

- (UIImage *)defaultImage;
- (UIImage *)bonkedImage;

@end

@protocol MoleDelegate <NSObject>

- (void)userBonkedMole:(Mole *)mole;

- (void)moleWillAppear;
- (void)moleDidAppear;

- (void)moleWillDismiss:(BOOL)fromClick;
- (void)moleDidDismiss:(BOOL)fromClick;

@end