//
//  RTRayTracer.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCanvas.h"
#import "RTScene.h"

#define kRayTracerMinEnergy 0.001
#define kRayTracerEpsilon   0.001
#define kRayTracerMaxSteps  5

@interface RTRayTracer : NSObject

+ (RTCanvas *)rayTraceScene:(RTScene *)scene dimension:(RTDimension *)dimension;

@end
