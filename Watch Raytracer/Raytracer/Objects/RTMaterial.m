//
//  RTMaterial.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTMaterial.h"

@implementation RTComponent

+ (instancetype)componentWithRed:(double)red green:(double)green blue:(double)blue {
    
    RTComponent * component = [[self alloc] init];
    component.red = red;
    component.green = green;
    component.blue = blue;
    return [component autorelease];
}

- (void)setRed:(double)red {
    
    if(red > 1.0)
        _red = 1.0;
    
    else if(red < 0.0)
        _red = 0.0;
    
    else
        _red = red;
}

- (void)setGreen:(double)green {
    
    if(green > 1.0)
        _green = 1.0;
    
    else if(green < 0.0)
        _green = 0.0;
    
    else
        _green = green;
}

- (void)setBlue:(double)blue {
    
    if(blue > 1.0)
        _blue = 1.0;
    
    else if(blue < 0.0)
        _blue = 0.0;
    
    else
        _blue = blue;
}

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"r"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"r"] doubleValue] > 1.0 || [representation[@"r"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"g"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"g"] doubleValue] > 1.0 || [representation[@"g"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"b"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"b"] doubleValue] > 1.0 || [representation[@"b"] doubleValue] < 0.0)
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _red = [representation[@"r"] doubleValue];
        _green = [representation[@"g"] doubleValue];
        _blue = [representation[@"b"] doubleValue];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    return @{@"r":@(_red), @"g":@(_green), @"b":@(_blue)};
}

@end

@implementation RTMaterial

+ (instancetype)materialWithAmbient:(RTComponent *)ambient diffuse:(RTComponent *)diffuse specular:(RTComponent *)specular shininess:(double)shininess reflection:(double)reflection transparency:(double)transparency {
    
    RTMaterial * material = [[self alloc] init];
    material.ambient = ambient;
    material.diffuse = diffuse;
    material.specular = specular;
    material.shininess = shininess;
    material.reflection = reflection;
    material.transparency = transparency;
    return [material autorelease];
}

+ (instancetype)material {
    return [self materialWithAmbient:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5] diffuse:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5] specular:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5] shininess:1.0 reflection:1.0 transparency:0.0];
}

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"shininess"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"shininess"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"reflection"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"reflection"] doubleValue] < 0.0 || [representation[@"reflection"] doubleValue] > 1.0)
        return NO;
    
    if(![representation[@"transparency"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"transparency"] doubleValue] < 0.0 || [representation[@"transparency"] doubleValue] > 1.0)
        return NO;
    
    if(![RTComponent isValidWithRepresentation:representation[@"ambient"]])
        return NO;
    
    if(![RTComponent isValidWithRepresentation:representation[@"diffuse"]])
        return NO;
    
    if(![RTComponent isValidWithRepresentation:representation[@"specular"]])
        return NO;
    
    return YES;
}

- (NSDictionary *)asRepresentation {
    
    return @{@"shininess":@(_shininess), @"reflection":@(_reflection), @"transparency":@(_transparency), @"ambient":[_ambient asRepresentation], @"diffuse":[_diffuse asRepresentation], @"specular":[_specular asRepresentation]};
}

- (void)setShininess:(double)shininess {
    
    if(shininess < 0.0)
        _shininess = 0.0;
    
    _shininess = shininess;
}

- (void)setReflection:(double)reflection {
    
    if(reflection > 1.0)
        _reflection = 1.0;
    
    else if(reflection < 0.0)
        _reflection = 0.0;
    
    else
        _reflection = reflection;
}

- (void)setTransparency:(double)transparency {
    
    if(transparency > 1.0)
        _transparency = transparency;
    
    if(transparency < 0.0)
        _transparency = 0.0;
    
    else
        _transparency = transparency;
}

- (void)dealloc {
    
    [_ambient release], _ambient = nil;
    [_diffuse release], _diffuse = nil;
    [_specular release], _specular = nil;
    [super dealloc];
}

@end
