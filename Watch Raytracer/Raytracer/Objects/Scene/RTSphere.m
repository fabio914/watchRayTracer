//
//  RTSphere.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTSphere.h"

@implementation RTSphere

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![representation[@"radius"] isKindOfClass:[NSNumber class]])
        return NO;
    
    if([representation[@"radius"] doubleValue] <= 0.0)
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _radius = [representation[@"radius"] doubleValue];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    NSMutableDictionary * representation = [NSMutableDictionary dictionaryWithDictionary:[super asRepresentation]];
    
    representation[@"radius"] = @(_radius);
    
    return representation;
}

+ (instancetype)sphereWithMaterial:(RTMaterial *)material position:(RTPoint *)position radius:(double)radius {
    
    return [[[self alloc] initWithMaterial:material position:position radius:radius] autorelease];
}

- (instancetype)initWithMaterial:(RTMaterial *)material position:(RTPoint *)position radius:(double)radius {
    
    if(self = [super initWithMaterial:material position:position]) {
        
        _radius = radius;
    }
    
    return self;
}

- (double)radius {
    
    if(_radius <= 0.0)
        return 0.001;
    
    return _radius;
}

- (double)intersect:(RTRay *)ray {
    
    double x = ray.origin.x - self.position.x;
    double y = ray.origin.y - self.position.y;
    double z = ray.origin.z - self.position.z;
    
    double d = x * ray.direction.x + y * ray.direction.y + z * ray.direction.z;
    double t = d * d - x * x - y * y - z * z + self.radius * self.radius;
    
    if(t < 0) {
        return -1.0;
    }
    
    double s = -d - sqrt(t);
    if(s > 0) {
        return s;
    }
    
    s = -d + sqrt(t);
    if(s > 0) {
        return s;
    }
    
    return -1.0;
}

- (RTVector *)normal:(RTPoint *)point {
    
    return [RTVector vectorWithX:(point.x - self.position.x)/self.radius
                               Y:(point.y - self.position.y)/self.radius
                               Z:(point.z - self.position.z)/self.radius];
}

@end
