//
//  RTCanvas.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTColour.h"
#import "RTDimension.h"

@interface RTCanvas : NSObject

+ (instancetype)canvasWithDimension:(RTDimension *)dimension;
- (RTColour *)pixelAtX:(double)x Y:(double)y;
- (void)setPixel:(RTColour *)colour atX:(double)x y:(double)y;

- (RTDimension *)dimension;

@end

#import <UIKit/UIKit.h>

@interface RTCanvas (UIKit)
+ (instancetype)canvasWithImage:(UIImage *)image;
- (UIImage *)image;
@end
