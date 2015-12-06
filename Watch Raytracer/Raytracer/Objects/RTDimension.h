//
//  RTDimension.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

@interface RTDimension : Model

@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;

+ (instancetype)dimensionWithWidth:(double)width height:(double)height;
- (BOOL)containsPositionX:(double)x Y:(double)y;

@end

#import <UIKit/UIKit.h>

@interface RTDimension (UIKit)
+ (instancetype)dimensionWithSize:(CGSize)size;
- (CGSize)size;
@end
