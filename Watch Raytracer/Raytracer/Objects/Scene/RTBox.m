//
//  RTBox.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTBox.h"

@implementation RTBox

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![super isValidWithRepresentation:representation])
        return NO;
    
    if(![RTVector isValidWithRepresentation:representation[@"size"]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super initWithRepresentation:representation]) {
        
        _size = [[RTVector alloc] initWithRepresentation:representation];
    }
    
    return self;
}

- (NSDictionary *)asRepresentation {
    
    NSMutableDictionary * representation = [NSMutableDictionary dictionaryWithDictionary:[super asRepresentation]];
    
    representation[@"size"] = [_size asRepresentation];
    
    return representation;
}

+ (instancetype)boxWithMaterial:(RTMaterial *)material position:(RTPoint *)position size:(RTVector *)size {
    
    return [[[self alloc] initWithMaterial:material position:position size:size] autorelease];
}

- (instancetype)initWithMaterial:(RTMaterial *)material position:(RTPoint *)position size:(RTVector *)size {
    
    if(self = [super initWithMaterial:material position:position]) {
        
        _size = [size retain];
    }
    
    return self;
}

- (double)sx {
    
    return _size.x + 0.001;
}

- (double)sy {
    
    return _size.y + 0.001;
}

- (double)sz {
    
    return _size.z + 0.001;
}

- (double)intersect:(RTRay *)ray {

    double xHit, yHit, zHit;
    double ss = ((DBL_MAX) - 1.0);
    
    double xAdj = ray.origin.x - self.position.x;
    double yAdj = ray.origin.y - self.position.y;
    double zAdj = ray.origin.z - self.position.z;
    
    if(ray.direction.x != 0) {
        
        double s = (self.sx/2.0 - xAdj)/ray.direction.x;
        
        if(s > 0 && s < ss) {
            
            yHit = fabs(yAdj + s * ray.direction.y);
            zHit = fabs(zAdj + s * ray.direction.z);
            
            if((yHit < self.sy/2.0) && (zHit < self.sz/2.0)) {
                ss = s;
            }
        }
        
        s = (-self.sx/2.0 - xAdj)/ray.direction.x;
        
        if((s > 0) && (s < ss)) {
            
            yHit = fabs(yAdj + s * ray.direction.y);
            zHit = fabs(zAdj + s * ray.direction.z);
            
            if((yHit < self.sy/2.0) && (zHit < self.sz/2.0)) {
                ss = s;
            }
        }
    }
    
    if(ray.direction.y != 0) {
        
        double s = (self.sy/2.0 - yAdj)/ray.direction.y;
        
        if(s > 0 && s < ss) {
            
            xHit = fabs(xAdj + s * ray.direction.x);
            zHit = fabs(zAdj + s * ray.direction.z);
            
            if((xHit < self.sx/2.0) && (zHit < self.sz/2.0)) {
                ss = s;
            }
        }
        
        s = (-self.sy/2.0 - yAdj)/ray.direction.y;
        
        if((s > 0) && (s < ss)) {
            
            xHit = fabs(xAdj + s * ray.direction.x);
            zHit = fabs(zAdj + s * ray.direction.z);
            
            if((xHit < self.sx/2.0) && (zHit < self.sz/2.0)) {
                ss = s;
            }
        }
    }
    
    if (ray.direction.z != 0) {
        
        double s = (self.sz/2.0 - zAdj)/ray.direction.z;
        
        if(s > 0 && s < ss) {
            
            xHit = fabs(xAdj + s * ray.direction.x);
            yHit = fabs(yAdj + s * ray.direction.y);
            
            if((xHit < self.sx/2.0) && (yHit < self.sy/2.0)) {
                ss = s;
            }
        }
        
        s = (-self.sz/2.0 - zAdj)/ray.direction.z;
        
        if ((s > 0) && (s < ss)) {
            
            xHit = fabs(xAdj + s * ray.direction.x);
            yHit = fabs(yAdj + s * ray.direction.y);
            
            if((xHit < self.sx/2.0) && (yHit < self.sy/2.0)) {
                ss = s;
            }
        }
    }
    
    if(ss == ((DBL_MAX) - 1.0)) {
        return -1;
    }
    
    return ss;
}

- (RTVector *)normal:(RTPoint *)point {

    unsigned face = 0;
    double diff, ss = ((DBL_MAX) - 1.0);
    
    diff = fabs((self.position.x + self.sx/2.0) - point.x);
    if(ss > diff) {
        ss = diff;
        face = 0;
    }
    
    diff = fabs((self.position.x - self.sx/2.0) - point.x);
    if(ss > diff) {
        ss = diff;
        face = 1;
    }
    
    diff = fabs((self.position.y + self.sy/2.0) - point.y);
    if(ss > diff) {
        ss = diff;
        face = 2;
    }
    
    diff = fabs((self.position.y - self.sy/2.0) - point.y);
    if(ss > diff) {
        ss = diff;
        face = 3;
    }
    
    diff = fabs((self.position.z + self.sz/2.0) - point.z);
    if(ss > diff) {
        ss = diff;
        face = 4;
    }
    
    diff = fabs((self.position.z - self.sz/2.0) - point.z);
    if(ss > diff) {
        face = 5;
    }
    
    switch(face) {
        case 0:
            return [RTVector vectorWithX:1 Y:0 Z:0]; break;
        case 1:
            return [RTVector vectorWithX:-1 Y:0 Z:0]; break;
        case 2:
            return [RTVector vectorWithX:0 Y:1 Z:0]; break;
        case 3:
            return [RTVector vectorWithX:0 Y:-1 Z:0]; break;
        case 4:
            return [RTVector vectorWithX:0 Y:0 Z:1]; break;
        case 5:
            return [RTVector vectorWithX:0 Y:0 Z:-1]; break;
    }
    
    return [RTVector vectorWithX:0 Y:0 Z:0];
}

- (void)dealloc {
    
    [_size release], _size = nil;
    [super dealloc];
}

@end
