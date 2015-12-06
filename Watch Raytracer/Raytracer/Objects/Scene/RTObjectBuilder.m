//
//  RTObjectBuilder.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "RTObjectBuilder.h"

#import "RTBox.h"
#import "RTSphere.h"

@implementation RTObjectBuilder

+ (BOOL)isAValidObjectWithRepresentation:(NSDictionary *)representation {
    
    if(![representation isKindOfClass:[NSDictionary class]])
        return NO;
    
    if(![representation[@"type"] isKindOfClass:[NSString class]])
        return NO;
    
    if([representation[@"type"] isEqualToString:@"box"]) {
        
        if(![RTBox isValidWithRepresentation:representation])
            return NO;
    }
    
    else if([representation[@"type"] isEqualToString:@"sphere"]) {
        
        if(![RTSphere isValidWithRepresentation:representation])
            return NO;
    }
    
    return YES;
}

+ (RTAbstractObject *)objectWithRepresentation:(NSDictionary *)representation {
    
    NSString * type = representation[@"type"];
    
    if([type isEqualToString:@"box"]) {
        
        return [RTBox fromRepresentation:representation];
    }
    
    else if([type isEqualToString:@"sphere"]) {
        
        return [RTSphere fromRepresentation:representation];
    }
    
    return nil;
}

@end
