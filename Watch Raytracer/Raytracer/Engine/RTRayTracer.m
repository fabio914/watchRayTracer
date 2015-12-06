//
//  RTRayTracer.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTRayTracer.h"
#import "RTAbstractObject.h"
#import "RTRayShooter.h"
#import "RTColour.h"

#define ANTIALIASING

@interface RTRayTracer ()

@property (nonatomic, retain) RTScene * scene;
@property (nonatomic, retain) RTDimension * dimension;
@property (nonatomic, assign) BOOL antialiasing;
@property (nonatomic, assign) unsigned depth;

@end

@implementation RTRayTracer

+ (instancetype)niceRayTracerWithScene:(RTScene *)scene dimension:(RTDimension *)dimension {
    
    return [self raytracerWithScene:scene dimension:dimension depth:5 antialiasing:YES];
}

+ (instancetype)fastRayTracerWithScene:(RTScene *)scene dimension:(RTDimension *)dimension {
    
    return [self raytracerWithScene:scene dimension:dimension depth:2 antialiasing:NO];
}

+ (instancetype)raytracerWithScene:(RTScene *)scene dimension:(RTDimension *)dimension depth:(unsigned)depth antialiasing:(BOOL)antialiasing {
    
    return [[[self alloc] initWithScene:scene dimension:dimension depth:depth antialiasing:antialiasing] autorelease];
}

- (instancetype)initWithScene:(RTScene *)scene dimension:(RTDimension *)dimension depth:(unsigned)depth antialiasing:(BOOL)antialiasing {
    
    if(self = [super init]) {
        
        _scene = [scene retain];
        _dimension = [dimension retain];
        _depth = depth;
        _antialiasing = antialiasing;
    }
    
    return self;
}

- (RTCanvas *)trace {
    
    RTCanvas * canvas = [RTCanvas canvasWithDimension:_dimension];
    RTRayShooter * shooter = [RTRayShooter rayShooterWithCamera:_scene.camera dimension:_dimension];
    
    if(_antialiasing) {
        
        for(double y = 0.f; y < _dimension.height; y++) {
            for(double x = 0.f; x < _dimension.width; x++) {
                
                double red = 0.0, green = 0.0, blue = 0.0;
                
                @autoreleasepool {
                    
                    for(double yPart = -0.75; yPart < 1.0; yPart += 0.5) {
                        for(double xPart = -0.75; xPart < 1.0; xPart += 0.5) {
                            
                            RTRay * ray = [shooter rayAtX:xPart + x Y:yPart + y];
                            RTColour * colour = [self traceRay:ray step:0];
                            red += colour.red; green += colour.green; blue += colour.blue;
                        }
                    }
                }
                
                red /= 16.0; green /= 16.0; blue /= 16.0;
                
                [canvas setPixel:[[RTColour colourWithRed:red green:green blue:blue] gammaCorrected] atX:x y:y];
            }
        }
    }
    
    else {
        
        for(double y = 0.f; y < _dimension.height; y++) {
            for(double x = 0.f; x < _dimension.width; x++) {
                
                @autoreleasepool {
                    RTRay * ray = [shooter rayAtX:x Y:y];
                    RTColour * colour = [self traceRay:ray step:0];
                    [canvas setPixel:[colour gammaCorrected] atX:x y:y];
                }
            }
        }
    }
    
    return canvas;
}

- (RTColour *)traceRay:(RTRay *)ray step:(unsigned)step {
    
    if(step < _depth && ray.energy > kRayTracerMinEnergy) {
        
        RTIntersection * intersect = [_scene intersect:ray];
        
        if(intersect) {
            
            RTPoint * intersection = [RTPoint pointWithX:(ray.origin.x + intersect.distance * ray.direction.x)
                                                       Y:(ray.origin.y + intersect.distance * ray.direction.y)
                                                       Z:(ray.origin.z + intersect.distance * ray.direction.z)];
            
            RTVector * normal = [intersect.object normal:intersection];
            
            intersection.x = (intersection.x + kRayTracerEpsilon * normal.x);
            intersection.y = (intersection.y + kRayTracerEpsilon * normal.y);
            intersection.z = (intersection.z + kRayTracerEpsilon * normal.z);
            
            /* Reflection */
            double k = 2.0 * [ray.direction scalarProductWithVector:normal];
            RTVector * reflection = [[RTVector vectorWithX:(ray.direction.x - k * normal.x)
                                                         Y:(ray.direction.y - k * normal.y)
                                                         Z:(ray.direction.z - k * normal.z)] normalize];
            
            RTColour * local = [self phongShadowWithObject:intersect.object normal:normal reflection:reflection intersection:intersection];
            
            RTRay * reflectedRay = [RTRay rayWithOrigin:intersection direction:reflection energy:ray.energy * intersect.object.material.reflection];
            
            RTColour * reflectionColour = [self traceRay:reflectedRay step:step + 1];
            
            return [RTColour colourWithRed:(local.red * ray.energy) + (reflectionColour.red * reflectedRay.energy)
                                     green:(local.green * ray.energy) + (reflectionColour.green * reflectedRay.energy)
                                      blue:(local.blue * ray.energy) + (reflectionColour.blue * reflectedRay.energy)];
        }
    }
    
    return [_scene.background colourByMultiplyingByFactor:ray.energy];
}

- (RTColour *)phongShadowWithObject:(id<RTRayTracerObjectProtocol>)object normal:(RTVector *)normal reflection:(RTVector *)reflection intersection:(RTPoint *)intersectionPoint {
    
    RTMaterial * material = object.material;
    double red = 0.0, green = 0.0, blue = 0.0;
    
    for(RTLight * light in _scene.ligths) {
        
        red += material.ambient.red * light.ambient.red;
        green += material.ambient.green * light.ambient.green;
        blue += material.ambient.blue * light.ambient.blue;
        
        RTVector * shadowDir = [[RTVector vectorWithBeginning:intersectionPoint endPoint:light.position] normalize];
        RTRay * shadowRay = [RTRay rayWithOrigin:intersectionPoint direction:shadowDir];
        RTIntersection * intersection = [_scene intersect:shadowRay];
        
        if(intersection == nil) {
            
            RTVector * lightDir = [[RTVector vectorWithBeginning:intersectionPoint endPoint:light.position] normalize];
            
            double diff = [normal scalarProductWithVector:lightDir];
            
            if(diff > 0.0) {
                
                red += material.diffuse.red * light.diffuse.red * diff;
                green += material.diffuse.green * light.diffuse.green * diff;
                blue += material.diffuse.blue * light.diffuse.blue * diff;
                
                double spec = [reflection scalarProductWithVector:lightDir];
                
                if(spec > 0.0) {
                    
                    spec = MAX(0, pow(spec, material.shininess));
                    
                    red += material.specular.red * light.specular.red * spec;
                    green += material.specular.green * light.specular.green * spec;
                    blue += material.specular.blue * light.specular.blue * spec;
                }
            }
        }
    }
    
    return [RTColour colourWithRed:red green:green blue:blue];
}

- (void)dealloc {
    
    [_dimension release], _dimension = nil;
    [_scene release], _scene = nil;
    [super dealloc];
}

@end
