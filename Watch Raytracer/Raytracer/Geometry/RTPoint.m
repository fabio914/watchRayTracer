//
//  RTPoint.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTPoint.h"

@implementation RTPoint

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

+ (instancetype)pointWithX:(double)x Y:(double)y Z:(double)z {
    RTPoint * point = [[self alloc] init];
    point.x = x;
    point.y = y;
    point.z = z;
    return [point autorelease];
}

@end
