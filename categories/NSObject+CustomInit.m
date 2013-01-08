//
//  NSObject+CustomInit.m
//  whackAMole
//
//  Created by mallarke on 12/23/12.
//  Copyright (c) 2012 bob, Inc. All rights reserved.
//

#import "NSObject+CustomInit.h"

@implementation NSObject (CustomInit)

+ (id)object
{
    return [[[self alloc] init] autorelease];
}

@end
