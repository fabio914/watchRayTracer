//
//  RTBackground.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/6/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"
#import "RTCanvas.h"
#import "RTColour.h"
#import "RTRay.h"

@interface RTBackground : Model

@property (nonatomic, retain) RTCanvas * canvas;
/* or */
@property (nonatomic, retain) RTColour * backgroundColour;

+ (instancetype)backgroundWithCanvas:(RTCanvas *)canvas;
+ (instancetype)backgroundWithColour:(RTColour *)colour;

- (RTColour *)colourForRay:(RTRay *)ray;

@end
