//
//  RTVector.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTVector.h"

@implementation RTVector

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"x"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if(![representation[@"y"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if(![representation[@"z"] isKindOfClass:[NSNumber class]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _x = [representation[@"x"] doubleValue];
        _y = [representation[@"y"] doubleValue];
        _z = [representation[@"z"] doubleValue];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    return @{@"x": @(_x), @"y": @(_y), @"z":@(_z)};
}

+ (instancetype)vectorWithX:(double)x Y:(double)y Z:(double)z {
    RTVector * vector = [[self alloc] init];
    vector.x = x;
    vector.y = y;
    vector.z = z;
    return [vector autorelease];
}

+ (instancetype)vectorWithBeginning:(RTPoint *)beginning endPoint:(RTPoint *)end {
    RTVector * vector = [[self alloc] init];
    vector.x = end.x - beginning.x;
    vector.y = end.y - beginning.y;
    vector.z = end.z - beginning.z;
    return [vector autorelease];
}

- (double)norm {
    return sqrt(_x * _x + _y * _y + _z * _z);
}

- (instancetype)normalize {

    double norm = [self norm];
    
    if(norm != 0.f) {
        
        _x /= norm;
        _y /= norm;
        _z /= norm;
    }
    
    else {
        
        _x = 0.0;
        _y = 0.0;
        _z = 0.0;
    }
    
    return self;
}

- (instancetype)multiplyByScalar:(double)scalar {
    
    _x *= scalar;
    _y *= scalar;
    _z *= scalar;
    return self;
}

- (instancetype)sum:(RTVector *)vector {
    
    _x += vector.x;
    _y += vector.y;
    _z += vector.z;
    return self;
}

+ (double)scalarProductWithVector:(RTVector *)first vector:(RTVector *)second {
    
    return first.x * second.x + first.y * second.y + first.z * second.z;
}

+ (RTVector *)crossProductWithVector:(RTVector *)first vector:(RTVector *)second {
    
    return [self vectorWithX:first.y * second.z - first.z * second.y
                           Y:first.z * second.x - first.x * second.z
                           Z:first.x * second.y - first.y * second.x];
}

- (double)scalarProductWithVector:(RTVector *)vector {
    
    return [RTVector scalarProductWithVector:self vector:vector];
}

- (RTVector *)crossProductWithVector:(RTVector *)vector {
    
    return [RTVector crossProductWithVector:self vector:vector];
}

@end
