//
//  Model.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation {
    
    if(![representation isKindOfClass:[NSDictionary class]])
        return NO;
    
    return YES;
}

- (instancetype)initWithRepresentation:(NSDictionary *)representation {
    
    if(self = [super init]) {
        
    }
    
    return self;
}

+ (instancetype)fromRepresentation:(NSDictionary *)representation {

    if([self isValidWithRepresentation:representation]) {
        
        return [[[self alloc] initWithRepresentation:representation] autorelease];
    }
    
    return nil;
}

- (NSDictionary *)asRepresentation {
    return @{};
}

@end
