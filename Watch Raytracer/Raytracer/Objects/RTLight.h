//
//  RTLight.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"
#import "RTPoint.h"
#import "RTColour.h"

@interface RTLight : Model

@property (nonatomic, retain) RTPoint * position;
@property (nonatomic, retain) RTColour * ambient;
@property (nonatomic, retain) RTColour * diffuse;
@property (nonatomic, retain) RTColour * specular;

+ (instancetype)light;
+ (instancetype)lightAtPosition:(RTPoint *)position withAmbient:(RTColour *)ambient diffuse:(RTColour *)diffuse specular:(RTColour *)specular;

@end
