//
//  RTCanvas.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTCanvas.h"

@interface RTCanvas ()
@property (nonatomic, assign) RTColour *** pixels;
@property (nonatomic, assign) unsigned width, height;
@property (nonatomic, retain) RTDimension * dimension;
@end

@implementation RTCanvas

- (instancetype)initWithDimension:(RTDimension *)dimension {
    
    if(self = [super init]) {
        
        _dimension = [dimension retain];
        _width = (unsigned)floor(dimension.width);
        _height = (unsigned)floor(dimension.height);
        
        _pixels = calloc((size_t)_height, sizeof(RTColour **));
        
        if(_pixels == NULL) {
            
            [self autorelease];
            return nil;
        }
        
        for(unsigned i = 0; i < _height; i++) {
            
            _pixels[i] = calloc((size_t)_width, sizeof(RTColour *));
            
            if(_pixels[i] == NULL) {
        
                [self autorelease];
                return nil;
            }
        }
    }
    
    return self;
}

+ (instancetype)canvasWithDimension:(RTDimension *)dimension {
    return [[[self alloc] initWithDimension:dimension] autorelease];
}

- (RTColour *)pixelAtX:(double)x Y:(double)y {
    
    if(![_dimension containsPositionX:x Y:y]) {
        
        return [RTColour colourWithRed:0.0 green:0.0 blue:0.0];
    }
    
    unsigned indexX = (unsigned)floor(x), indexY = (unsigned)floor(y);
    
    if(_pixels[indexY][indexX] == NULL) {
        
        return [RTColour colourWithRed:0.0 green:0.0 blue:0.0];
    }
    
    return _pixels[indexY][indexX];
}

- (void)setPixel:(RTColour *)colour atX:(double)x y:(double)y {
    
    if([_dimension containsPositionX:x Y:y]) {
        
        unsigned indexX = (unsigned)floor(x), indexY = (unsigned)floor(y);
        
        if(_pixels[indexY][indexX] != NULL) {
            
            [_pixels[indexY][indexX] release];
        }
        
        _pixels[indexY][indexX] = [colour retain];
    }
}

- (void)dealloc {
    
    if(_pixels != NULL) {
        
        for(unsigned i = 0; i < _height; i++) {
            
            if(_pixels[i] != NULL) {
                
                for(unsigned j = 0; j < _width; j++) {
                    
                    if(_pixels[i][j] != NULL) {
                        
                        [_pixels[i][j] release];
                    }
                }
                
                free(_pixels[i]);
            }
        }
        
        free(_pixels);
    }
    
    [_dimension release], _dimension = nil;
    [super dealloc];
}

@end

@implementation RTCanvas (UIKit)

- (UIImage *)image {
    
    UIGraphicsBeginImageContext([[self dimension] size]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(unsigned i = 0; i < self.height; i++) {
        for(unsigned j = 0; j < self.width; j++) {
         
            CGContextSetFillColorWithColor(context, [[[self pixelAtX:(double)j Y:(double)i] asUIColor] CGColor]);
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
    
    UIImage * image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
