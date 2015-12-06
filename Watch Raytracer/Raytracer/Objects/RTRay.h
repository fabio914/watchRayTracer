//
//  RTRay.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTPoint.h"
#import "RTVector.h"

@interface RTRay : NSObject

@property (nonatomic, retain) RTPoint * origin;
@property (nonatomic, retain) RTVector * direction;
@property (nonatomic, assign) double energy;

+ (instancetype)rayWithOrigin:(RTPoint *)origin direction:(RTVector *)direction;
+ (instancetype)rayWithOrigin:(RTPoint *)origin direction:(RTVector *)direction energy:(double)energy;

@end
