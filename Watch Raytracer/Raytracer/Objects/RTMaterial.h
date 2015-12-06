//
//  RTMaterial.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

@interface RTComponent : Model

@property (nonatomic, assign) double red, green, blue;

+ (instancetype)componentWithRed:(double)red green:(double)green blue:(double)blue;

@end

@interface RTMaterial : Model

@property (nonatomic, assign) double shininess;
@property (nonatomic, assign) double reflection;
@property (nonatomic, assign) double transparency;

@property (nonatomic, retain) RTComponent * ambient;
@property (nonatomic, retain) RTComponent * diffuse;
@property (nonatomic, retain) RTComponent * specular;

+ (instancetype)materialWithAmbient:(RTComponent *)ambient diffuse:(RTComponent *)diffuse specular:(RTComponent *)specular shininess:(double)shininess reflection:(double)reflection transparency:(double)transparency;

+ (instancetype)material;

@end
