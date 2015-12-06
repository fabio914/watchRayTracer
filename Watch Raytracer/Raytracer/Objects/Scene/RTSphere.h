//
//  RTSphere.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTAbstractObject.h"

@interface RTSphere : RTAbstractObject

@property (nonatomic, assign) double radius;

+ (instancetype)sphereWithMaterial:(RTMaterial *)material position:(RTPoint *)position radius:(double)radius;

@end
