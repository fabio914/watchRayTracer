//
//  RTBox.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTAbstractObject.h"

@interface RTBox : RTAbstractObject

@property (nonatomic, retain) RTVector * size;

+ (instancetype)boxWithMaterial:(RTMaterial *)material position:(RTPoint *)position size:(RTVector *)size;

@end
