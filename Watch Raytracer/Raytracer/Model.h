//
//  Model.h
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (BOOL)isValidWithRepresentation:(NSDictionary *)representation;
- (instancetype)initWithRepresentation:(NSDictionary *)representation;

+ (instancetype)fromRepresentation:(NSDictionary *)representation;

- (NSDictionary *)asRepresentation;

@end
