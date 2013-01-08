//
//  Utility.m
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "Utility.h"

CATransform3D makeScale(CGFloat scale)
{
    return CATransform3DMakeScale(scale, scale, 1.0);
}

CAAnimationGroup *makeAnimation(CGFloat fromScale, CGFloat toScale, CGFloat fromAlpha, CGFloat toAlpha, id delegate)
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSValue valueWithCATransform3D:makeScale(fromScale)];
    scale.toValue = [NSValue valueWithCATransform3D:makeScale(toScale)];
    scale.duration = kAnimationDuration;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = [NSNumber numberWithFloat:fromAlpha];
    fade.toValue = [NSNumber numberWithFloat:toAlpha];
    fade.duration = kAnimationDuration;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = [NSArray arrayWithObjects:scale, fade, nil];
    animation.duration = kAnimationDuration;
    animation.delegate = delegate;
    
    return animation;
}
