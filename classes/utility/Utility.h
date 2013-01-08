//
//  Utility.h
//  whackAMole
//
//  Created by mallarke on 12/24/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

CATransform3D makeScale(CGFloat scale);
CAAnimationGroup *makeAnimation(CGFloat fromScale, CGFloat toScale, CGFloat fromAlpha, CGFloat toAlpha, id delegate);