//
//  RTObjectBuilder.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTAbstractObject.h"

@interface RTObjectBuilder : NSObject

+ (BOOL)isAValidObjectWithRepresentation:(NSDictionary *)representation;
+ (RTAbstractObject *)objectWithRepresentation:(NSDictionary *)representation;

@end
