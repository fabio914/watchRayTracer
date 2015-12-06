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

+ (RTColour *)traceRay:(RTRay *)ray onScene:(RTScene *)scene step:(unsigned)step;

+ (RTColour *)phongShadowWithObject:(id<RTRayTracerObjectProtocol>)object scene:(RTScene *)scene normal:(RTVector *)normal reflection:(RTVector *)reflection intersection:(RTPoint *)intersection;

@end

@implementation RTRayTracer

+ (RTCanvas *)rayTraceScene:(RTScene *)scene dimension:(RTDimension *)dimension {
    
    RTCanvas * canvas = [RTCanvas canvasWithDimension:dimension];
    RTRayShooter * shooter = [RTRayShooter rayShooterWithCamera:scene.camera dimension:dimension];
    
    for(double y = 0.f; y < dimension.height; y++) {
        for(double x = 0.f; x < dimension.width; x++) {
         
            double red = 0.0, green = 0.0, blue = 0.0;
            
            @autoreleasepool {
                
#ifdef ANTIALIASING
                for(double yPart = -0.75; yPart < 1.0; yPart += 0.5) {
                    for(double xPart = -0.75; xPart < 1.0; xPart += 0.5) {
#else
                        const double xPart = 0, yPart = 0;
#endif
                        
                        RTRay * ray = [shooter rayAtX:xPart + x Y:yPart + y];
                        RTColour * colour = [self traceRay:ray onScene:scene step:0];
                        red += colour.red; green += colour.green; blue += colour.blue;
#ifdef ANTIALIASING
                    }
                }
#endif
            }
#ifdef ANTIALIASING
            red /= 16.0; green /= 16.0; blue /= 16.0;
#endif
            [canvas setPixel:[[RTColour colourWithRed:red green:green blue:blue] gammaCorrected] atX:x y:y];
        }
    }
    
    return canvas;
}

+ (RTColour *)traceRay:(RTRay *)ray onScene:(RTScene *)scene step:(unsigned)step {
    
    if(step < kRayTracerMaxSteps && ray.energy > kRayTracerMinEnergy) {
        
        RTIntersection * intersect = [scene intersect:ray];
        
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
            
            RTColour * local = [self phongShadowWithObject:intersect.object scene:scene normal:normal reflection:reflection intersection:intersection];
            
            RTRay * reflectedRay = [RTRay rayWithOrigin:intersection direction:reflection energy:ray.energy * intersect.object.material.reflection];
            
            RTColour * reflectionColour = [self traceRay:reflectedRay onScene:scene step:step + 1];
            
            return [RTColour colourWithRed:(local.red * ray.energy) + (reflectionColour.red * reflectedRay.energy)
                                     green:(local.green * ray.energy) + (reflectionColour.green * reflectedRay.energy)
                                      blue:(local.blue * ray.energy) + (reflectionColour.blue * reflectedRay.energy)];
        }
    }
    
    return [scene.background colourByMultiplyingByFactor:ray.energy];
}

+ (RTColour *)phongShadowWithObject:(id<RTRayTracerObjectProtocol>)object scene:(RTScene *)scene normal:(RTVector *)normal reflection:(RTVector *)reflection intersection:(RTPoint *)intersectionPoint {
    
    RTMaterial * material = object.material;
    double red = 0.0, green = 0.0, blue = 0.0;
    
    for(RTLight * light in scene.ligths) {
        
        red += material.ambient.red * light.ambient.red;
        green += material.ambient.green * light.ambient.green;
        blue += material.ambient.blue * light.ambient.blue;
        
        RTVector * shadowDir = [[RTVector vectorWithBeginning:intersectionPoint endPoint:light.position] normalize];
        RTRay * shadowRay = [RTRay rayWithOrigin:intersectionPoint direction:shadowDir];
        RTIntersection * intersection = [scene intersect:shadowRay];
        
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

@end
