//
//  RTPoint.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

@interface RTPoint : Model

@property (nonatomic, assign) double x, y, z;

+ (instancetype)pointWithX:(double)x Y:(double)y Z:(double)z;

@end
