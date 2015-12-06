//
//  RTDimension.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTDimension.h"

@implementation RTDimension

+ (instancetype)dimensionWithWidth:(double)width height:(double)height {
    
    RTDimension * dimension = [[RTDimension alloc] init];
    dimension.width = width;
    dimension.height = height;
    return [dimension autorelease];
}

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"width"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"width"] doubleValue] < 0.0)
        return NO;
    
    if(![representation[@"height"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"height"] doubleValue] < 0.0)
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _width = [representation[@"width"] doubleValue];
        _height = [representation[@"height"] doubleValue];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    return @{@"width":@(_width), @"height":@(_height)};
}

- (BOOL)containsPositionX:(double)x Y:(double)y {
    
    return (x >= 0.0 && x < _width) && (y >= 0.0 && y < _height);
}

@end

@implementation RTDimension (UIKit)

+ (instancetype)dimensionWithSize:(CGSize)size {
    return [self dimensionWithWidth:size.width height:size.height];
}

- (CGSize)size {
    return CGSizeMake(_width, _height);
}

@end
