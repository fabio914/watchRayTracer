//
//  RTLight.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTLight.h"

@implementation RTLight

+ (instancetype)light {

    RTLight * light = [[self alloc] init];
    light.position = [RTPoint pointWithX:100.0 Y:100.0 Z:0.0];
    light.ambient = [RTColour colourWithRed:125.0 green:125.0 blue:125.0];
    light.diffuse = [RTColour colourWithRed:255.0 green:255.0 blue:255.0];
    light.specular = [RTColour colourWithRed:255.0 green:255.0 blue:255.0];
    return [light autorelease];
}

+ (instancetype)lightAtPosition:(RTPoint *)position withAmbient:(RTColour *)ambient diffuse:(RTColour *)diffuse specular:(RTColour *)specular {
    
    RTLight * light = [[self alloc] init];
    light.position = position;
    light.ambient = ambient;
    light.diffuse = diffuse;
    light.specular = specular;
    return [light autorelease];
}

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![RTPoint isValidWithRepresentation:representation[@"position"]])
        return NO;
    
    if(![RTColour isValidWithRepresentation:representation[@"ambient"]])
        return NO;
    
    if(![RTColour isValidWithRepresentation:representation[@"diffuse"]])
        return NO;
    
    if(![RTColour isValidWithRepresentation:representation[@"specular"]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _position = [[RTPoint alloc] initWithRepresentation:representation[@"position"]];
        _ambient = [[RTColour alloc] initWithRepresentation:representation[@"ambient"]];
        _diffuse = [[RTColour alloc] initWithRepresentation:representation[@"diffuse"]];
        _specular = [[RTColour alloc] initWithRepresentation:representation[@"specular"]];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    return @{@"position":[_position asRepresentation], @"ambient":[_ambient asRepresentation], @"diffuse":[_diffuse asRepresentation], @"specular":[_specular asRepresentation]};
}

- (void)dealloc {
    
    [_position release], _position = nil;
    [_ambient release], _ambient = nil;
    [_diffuse release], _diffuse = nil;
    [_specular release], _specular = nil;
    [super dealloc];
}

@end
