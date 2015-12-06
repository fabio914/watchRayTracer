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

+ (NSArray *)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count {
    
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:count];
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    
    for (int i = 0 ; i < count ; ++i) {
        
        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / 255.0;
        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / 255.0;
        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / 255.0;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [result addObject:acolor];
    }
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

+ (instancetype)canvasWithImage:(UIImage *)image {
    
    RTCanvas * canvas = [self canvasWithDimension:[RTDimension dimensionWithSize:image.size]];
    
    unsigned width = floor(image.size.width), height = floor(image.size.height);
    
    NSArray * pixels = [self getRGBAsFromImage:image atX:0 andY:0 count:width * height];
    
    for(unsigned i = 0; i < height; i++) {
        for(unsigned j = 0; j < width; j++) {
            
            [canvas setPixel:[RTColour colourWithUIColor:[pixels objectAtIndex:(i * width + j)]] atX:j y:i];
        }
    }
    
    return canvas;
}

- (UIImage *)image {
    
    UIGraphicsBeginImageContext([[self dimension] size]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(unsigned i = 0; i < self.height; i++) {
        for(unsigned j = 0; j < self.width; j++) {
         
            CGContextSetFillColorWithColor(context, [[[self pixelAtX:(double)j Y:(double)i] asUIColor] CGColor]);
            CGContextFillRect(context, CGRectMake(j, i, 1, 1));
        }
    }
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
