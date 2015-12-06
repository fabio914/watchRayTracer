//
//  RTRay.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTRay.h"

@implementation RTRay

+ (instancetype)rayWithOrigin:(RTPoint *)origin direction:(RTVector *)direction {

    return [self rayWithOrigin:origin direction:direction energy:1.0];
}

+ (instancetype)rayWithOrigin:(RTPoint *)origin direction:(RTVector *)direction energy:(double)energy {
    
    RTRay * ray = [[self alloc] init];
    ray.origin = origin;
    ray.direction = direction;
    ray.energy = energy;
    return [ray autorelease];
}

- (void)dealloc {
    
    [_origin release], _origin = nil;
    [_direction release], _direction = nil;
    [super dealloc];
}

@end
