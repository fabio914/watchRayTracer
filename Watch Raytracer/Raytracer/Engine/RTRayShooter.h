//
//  RTRayShooter.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCamera.h"
#import "RTDimension.h"
#import "RTRay.h"

@interface RTRayShooter : NSObject

+ (instancetype)rayShooterWithCamera:(RTCamera *)camera dimension:(RTDimension *)dimension;
- (RTRay *)rayAtX:(double)x Y:(double)y;

@end
