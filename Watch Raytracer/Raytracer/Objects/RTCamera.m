//
//  RTCamera.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTCamera.h"

@implementation RTCamera

+ (instancetype)cameraWithEye:(RTPoint *)eye lookAt:(RTPoint *)lookAt up:(RTVector *)viewUp fov:(double)fov zvp:(double)zvp {
    
    RTCamera * camera = [[self alloc] init];
    camera.eye = eye;
    camera.lookAt = lookAt;
    camera.viewUp = viewUp;
    camera.fov = fov;
    camera.zvp = zvp;
    return [camera autorelease];
}

+ (instancetype)camera {
    return [self cameraWithEye:[RTPoint pointWithX:0.0 Y:0.0 Z:0.0] lookAt:[RTPoint pointWithX:0.0 Y:0.0 Z:-1.0] up:[RTVector vectorWithX:0.0 Y:1.0 Z:0.0] fov:45.0 zvp:1.0];
}

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![RTPoint isValidWithRepresentation:representation[@"eye"]])
        return NO;
    
    if(![RTPoint isValidWithRepresentation:representation[@"lookAt"]])
        return NO;
    
    if(![RTVector isValidWithRepresentation:representation[@"viewUp"]])
         return NO;
         
    if(![representation[@"fov"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if(![representation[@"zvp"] isKindOfClass:[NSNumber class]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _eye = [[RTPoint alloc] initWithRepresentation:representation[@"eye"]];
        _lookAt = [[RTPoint alloc] initWithRepresentation:representation[@"lookAt"]];
        _viewUp = [[RTVector alloc] initWithRepresentation:representation[@"viewUp"]];
        _fov = [representation[@"fov"] doubleValue];
        _zvp = [representation[@"zvp"] doubleValue];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    return @{@"eye":[_eye asRepresentation], @"lookAt":[_lookAt asRepresentation], @"viewUp":[_viewUp asRepresentation], @"fov":@(_fov), @"zvp":@(_zvp)};
}

- (void)dealloc {
    
    [_eye release], _eye = nil;
    [_lookAt release], _lookAt = nil;
    [_viewUp release], _viewUp = nil;
    [super dealloc];
}

@end
