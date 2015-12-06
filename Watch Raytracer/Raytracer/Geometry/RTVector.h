//
//  RTVector.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"
#import "RTPoint.h"

@interface RTVector : Model

@property (nonatomic, assign) double x, y, z;

+ (instancetype)vectorWithX:(double)x Y:(double)y Z:(double)z;
+ (instancetype)vectorWithBeginning:(RTPoint *)beginning endPoint:(RTPoint *)end;

- (double)norm;
- (instancetype)normalize;
- (instancetype)multiplyByScalar:(double)scalar;
- (instancetype)sum:(RTVector *)vector;

+ (double)scalarProductWithVector:(RTVector *)first vector:(RTVector *)second;
+ (RTVector *)crossProductWithVector:(RTVector *)first vector:(RTVector *)second;

- (double)scalarProductWithVector:(RTVector *)vector;
- (RTVector *)crossProductWithVector:(RTVector *)vector;

@end
