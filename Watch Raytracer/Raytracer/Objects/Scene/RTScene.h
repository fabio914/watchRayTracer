//
//  RTScene.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"
#import "RTCamera.h"
#import "RTAbstractObject.h"
#import "RTLight.h"
#import "RTColour.h"
#import "RTRay.h"

@interface RTIntersection : NSObject

@property (nonatomic, retain) id<RTRayTracerObjectProtocol> object;
@property (nonatomic, assign) double distance;

+ (instancetype)intersectionWithObject:(id<RTRayTracerObjectProtocol>)object distance:(double)distance;

@end

@interface RTScene : Model

@property (nonatomic, retain) RTColour * background;
@property (nonatomic, retain) RTCamera * camera;

@property (nonatomic, retain) NSArray<RTAbstractObject *> * objects;
@property (nonatomic, retain) NSArray<RTLight *> * ligths;

+ (instancetype)sceneWithCamera:(RTCamera *)camera bakgroundColour:(RTColour *)background objects:(NSArray<RTAbstractObject *> *)objects lights:(NSArray<RTLight *> *)lights;

- (RTIntersection *)intersect:(RTRay *)ray;

@end
