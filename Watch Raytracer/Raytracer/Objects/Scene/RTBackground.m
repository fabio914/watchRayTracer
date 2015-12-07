//
//  RTBackground.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/6/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTBackground.h"

@interface RTBackground ()
@property (nonatomic, assign) double width, height;
@end

@implementation RTBackground

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(representation[@"colour"]) {
        
        if(![RTColour isValidWithRepresentation:representation[@"colour"]])
            return NO;
    }
    
#warning TODO Read image from representation...
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        if(representation[@"colour"]) {
            
            _backgroundColour = [[RTColour alloc] initWithRepresentation:representation[@"colour"]];
        }
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    if(_backgroundColour) {
        
        return @{@"colour":[_backgroundColour asRepresentation]};
    }
    
    return @{};
}

+ (instancetype)backgroundWithCanvas:(RTCanvas *)canvas {
    
    RTBackground * background = [[self alloc] init];
    background.canvas = canvas;
    background.width = [[canvas dimension] width];
    background.height = [[canvas dimension] height];
    return [background autorelease];
}

+ (instancetype)backgroundWithColour:(RTColour *)colour {
    
    RTBackground * background = [[self alloc] init];
    background.backgroundColour = colour;
    return [background autorelease];
}

- (RTColour *)colourForRay:(RTRay *)ray {
    
    if(_backgroundColour) {
        
        return [_backgroundColour colourByMultiplyingByFactor:ray.energy];
    }
    
    else if(_canvas) {
        
        RTVector * direction = ray.direction;
        double theta = atan2(direction.x, direction.z);
        double phi = -M_PI_2 + acos(direction.y/[direction norm]);
        
        double x = (theta/M_PI + 1.0) * floor((_width - 1.0)/2.0);
        double y = (phi/M_PI_2 + 1.0) * floor((_height - 1.0)/2.0);
        
        return [[_canvas pixelAtX:floor(x) Y:floor(y)] colourByMultiplyingByFactor:ray.energy];
    }
    
    return [RTColour colourWithRed:0 green:0 blue:0];
}

- (void)dealloc {
    
    [_canvas release], _canvas = nil;
    [_backgroundColour release], _backgroundColour = nil;
    [super dealloc];
}

@end
