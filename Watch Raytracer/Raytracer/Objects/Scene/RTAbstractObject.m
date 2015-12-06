//
//  RTAbstractObject.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTAbstractObject.h"

@implementation RTAbstractObject

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![RTMaterial isValidWithRepresentation:representation[@"material"]])
        return NO;
    
    if(![RTPoint isValidWithRepresentation:representation[@"point"]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _material = [[RTMaterial alloc] initWithRepresentation:representation[@"material"]];
        _position = [[RTPoint alloc] initWithRepresentation:representation[@"point"]];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    return @{@"material":[_material asRepresentation], @"position":[_position asRepresentation]};
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        _material = [[RTMaterial material] retain];
        _position = [[RTPoint pointWithX:0 Y:0 Z:0] retain];
    }
    
    return self;
}

- (instancetype)initWithMaterial:(RTMaterial *)material position:(RTPoint *)position {
    
    if(self = [super init]) {
        
        _material = [material retain];
        _position = [position retain];
    }
    
    return self;
}

- (double)intersect:(RTRay *)ray {
    return 0.0;
}

- (RTVector *)normal:(RTPoint *)point {
    return [RTVector vectorWithX:0 Y:0 Z:0];
}

- (void)dealloc {
    
    [_material release], _material = nil;
    [_position release], _position = nil;
    [super dealloc];
}

@end
