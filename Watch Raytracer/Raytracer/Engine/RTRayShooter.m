//
//  RTRayShooter.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTRayShooter.h"

@interface RTRayShooter ()

@property (nonatomic, retain) RTPoint * eye;
@property (nonatomic, retain) RTVector * xDir;
@property (nonatomic, retain) RTVector * yDir;
@property (nonatomic, retain) RTVector * fRay;

@end

@implementation RTRayShooter

+ (instancetype)rayShooterWithCamera:(RTCamera *)camera dimension:(RTDimension *)dimension {
    
    RTRayShooter * shooter = [[self alloc] init];
    
    shooter.eye = camera.eye;
    
    RTVector * zDir = [[RTVector vectorWithBeginning:camera.eye endPoint:camera.lookAt] normalize];
    shooter.xDir = [[zDir crossProductWithVector:camera.viewUp] normalize];
    shooter.yDir = [[shooter.xDir crossProductWithVector:zDir] normalize];
    
    double height = 2.0 * camera.zvp * tan(((camera.fov) * M_PI/180.0)/2.0f);
    double width = (dimension.width/dimension.height) * height;
    
    [shooter.xDir multiplyByScalar:width/dimension.width];
    [shooter.yDir multiplyByScalar:height/dimension.height];
    
    [zDir multiplyByScalar:camera.zvp];
    
    double h_2 = (dimension.height/2.0);
    double w_2 = (dimension.width/2.0);
    
    shooter.fRay = [RTVector vectorWithX:(zDir.x + h_2 * shooter.yDir.x - w_2 * shooter.xDir.x)
                                       Y:(zDir.y + h_2 * shooter.yDir.y - w_2 * shooter.xDir.y)
                                       Z:(zDir.z + h_2 * shooter.yDir.z - w_2 * shooter.xDir.z)];
    
    return [shooter autorelease];
}

- (RTRay *)rayAtX:(double)x Y:(double)y {
    
    RTVector * direction = [[RTVector vectorWithX:_fRay.x + x * _xDir.x - y * _yDir.x
                                                Y:_fRay.y + x * _xDir.y - y * _yDir.y
                                                Z:_fRay.z + x * _xDir.z - y * _yDir.z] normalize];
    
    return [RTRay rayWithOrigin:_eye direction:direction];
}

- (void)dealloc {
    
    [_eye release], _eye = nil;
    [_xDir release], _xDir = nil;
    [_yDir release], _yDir = nil;
    [_fRay release], _fRay = nil;
    [super dealloc];
}

@end
