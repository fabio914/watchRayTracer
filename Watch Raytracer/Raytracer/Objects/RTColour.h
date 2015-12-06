//
//  RTColour.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

@interface RTColour : Model

@property (nonatomic, assign) double red, green, blue;

+ (instancetype)colourWithRed:(double)red green:(double)green blue:(double)blue;
- (instancetype)multiplyByFactor:(double)factor;
- (instancetype)colourByMultiplyingByFactor:(double)factor;
- (instancetype)gammaCorrected;

@end

#import <UIKit/UIKit.h>

@interface RTColour (UIKit)
+ (instancetype)colourWithUIColor:(UIColor *)color;
- (UIColor *)asUIColor;
@end
