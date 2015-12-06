//
//  RTColour.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTColour.h"

@implementation RTColour

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"r"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"r"] doubleValue] > 255.0 || [representation[@"r"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"g"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"g"] doubleValue] > 255.0 || [representation[@"g"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"b"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"b"] doubleValue] > 255.0 || [representation[@"b"] doubleValue] < 0.0)
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

+ (instancetype)colourWithRed:(double)red green:(double)green blue:(double)blue {
    RTColour * colour = [[self alloc] init];
    colour.red = red;
    colour.green = green;
    colour.blue = blue;
    return [colour autorelease];
}

- (instancetype)multiplyByFactor:(double)factor {
    _red *= factor;
    _green *= factor;
    _blue *= factor;
    return self;
}

- (instancetype)colourByMultiplyingByFactor:(double)factor {
    return [RTColour colourWithRed:_red*factor green:_green*factor blue:_blue*factor];
}

- (instancetype)gammaCorrected {
    
    const double gamma = 1.1;
    double red, green, blue;
    
    red = MAX(MIN(self.red/255.0, 1.0), 0.0);
    green = MAX(MIN(self.green/255.0, 1.0), 0.0);
    blue = MAX(MIN(self.blue/255.0, 1.0), 0.0);
    
    red = exp(log(red)/gamma);
    green = exp(log(green)/gamma);
    blue = exp(log(blue)/gamma);
    
    red = (red * 255 + 0.5f);
    green = (green * 255 + 0.5f);
    blue = (blue * 255 + 0.5f);
    
    return [RTColour colourWithRed:red green:green blue:blue];
}

@end

@implementation RTColour (UIKit)

+ (instancetype)colourWithUIColor:(UIColor *)color {
    
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    return [RTColour colourWithRed:red * 255.0 green:green * 255.0 blue:blue * 255.0];
}

- (UIColor *)asUIColor {
    
    return [UIColor colorWithRed:self.red/255.f green:self.green/255.f blue:self.blue/255.f alpha:1.f];
}

@end
