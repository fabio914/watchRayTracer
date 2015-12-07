//
//  RTScene.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTScene.h"
#import "RTObjectBuilder.h"

@implementation RTIntersection

+ (instancetype)intersectionWithObject:(id<RTRayTracerObjectProtocol>)object distance:(double)distance {
    
    RTIntersection * intersection = [[self alloc] init];
    intersection.object = object;
    intersection.distance = distance;
    return [intersection autorelease];
}

- (void)dealloc {
    
    [_object release], _object = nil;
    [super dealloc];
}

@end

@implementation RTScene

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![RTBackground isValidWithRepresentation:representation[@"background"]])
        return NO;
    
    if(![RTCamera isValidWithRepresentation:representation[@"camera"]])
        return NO;
    
    if(![representation[@"objects"] isKindOfClass:[NSArray class]])
        return NO;
    
    for(id entry in representation[@"objects"]) {
        
        if(![RTObjectBuilder isAValidObjectWithRepresentation:entry])
            return NO;
    }
    
    if(![representation[@"lights"] isKindOfClass:[NSArray class]])
        return NO;
    
    for(id entry in representation[@"ligths"]) {
        
        if(![RTLight isValidWithRepresentation:entry])
            return NO;
    }
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _background = [[RTBackground alloc] initWithRepresentation:representation[@"background"]];
        _camera = [[RTCamera alloc] initWithRepresentation:representation[@"camera"]];
        
        NSMutableArray * objects = [NSMutableArray array];
        
        for(id entry in representation[@"objects"]) {
            
            [objects addObject:[RTObjectBuilder objectWithRepresentation:entry]];
        }
        
        _objects = [[NSArray alloc] initWithArray:objects];
        
        NSMutableArray * lights = [NSMutableArray array];
        
        for(id entry in representation[@"lights"]) {
            
            [lights addObject:[[[RTLight alloc] initWithRepresentation:entry] autorelease]];
        }
        
        _ligths = [[NSArray alloc] initWithArray:lights];
    }
    
    return self;
}

+ (instancetype)sceneWithCamera:(RTCamera *)camera bakground:(RTBackground *)background objects:(NSArray<RTAbstractObject *> *)objects lights:(NSArray<RTLight *> *)lights {
    
    RTScene * scene = [[self alloc] init];
    scene.camera = camera;
    scene.background = background;
    scene.objects = objects;
    scene.ligths = lights;
    return [scene autorelease];
}

- (RTIntersection *)intersect:(RTRay *)ray {
    
    double minDist = ((DBL_MAX) - 1.0f);
    RTAbstractObject * object = nil;
    
    for(RTAbstractObject * currentObject in _objects) {
        
        double objDistance = [currentObject intersect:ray];
        
        if(objDistance > 0.0 && minDist > objDistance) {
            
            minDist = objDistance;
            object = currentObject;
        }
    }
    
    if(object) {
        
        return [RTIntersection intersectionWithObject:object distance:minDist];
    }
    
    return nil;
}

- (void)dealloc {
    
    [_background release], _background = nil;
    [_camera release], _camera = nil;
    [_objects release], _objects = nil;
    [_ligths release], _ligths = nil;
    [super dealloc];
}

@end
