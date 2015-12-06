//
//  RTAbstractObject.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

#import "RTPoint.h"
#import "RTVector.h"
#import "RTMaterial.h"
#import "RTRay.h"

@protocol RTRayTracerObjectProtocol <NSObject>

@required
- (double)intersect:(RTRay *)ray;
- (RTVector *)normal:(RTPoint *)point;
- (RTMaterial *)material;
- (RTPoint *)position;

@end

@interface RTAbstractObject : Model <RTRayTracerObjectProtocol>

@property (nonatomic, retain) RTMaterial * material;
@property (nonatomic, retain) RTPoint * position;

- (instancetype)initWithMaterial:(RTMaterial *)material position:(RTPoint *)position;

@end
