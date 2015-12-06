//
//  RTCamera.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"
#import "RTPoint.h"
#import "RTVector.h"

@interface RTCamera : Model

@property (nonatomic, retain) RTPoint * eye;
@property (nonatomic, retain) RTPoint * lookAt;
@property (nonatomic, retain) RTVector * viewUp;

@property (nonatomic, assign) double fov; /* degrees */
@property (nonatomic, assign) double zvp; /* projection plane distance */

+ (instancetype)cameraWithEye:(RTPoint *)eye lookAt:(RTPoint *)lookAt up:(RTVector *)viewUp fov:(double)fov zvp:(double)zvp;
+ (instancetype)camera;

@end
