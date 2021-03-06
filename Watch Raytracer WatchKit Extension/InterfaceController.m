//
//  InterfaceController.m
//  Watch Raytracer WatchKit Extension
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "InterfaceController.h"
#import "RTRayTracer.h"
#import "RTSphere.h"
#import "RTBox.h"

@interface InterfaceController()
@property (retain, nonatomic) IBOutlet WKInterfaceImage * interfaceImage;
@property (retain, nonatomic) NSThread * renderingThread;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    
    [super willActivate];
    
    [self.renderingThread cancel];
    self.renderingThread = [[[NSThread alloc] initWithTarget:self selector:@selector(render) object:nil] autorelease];
    [self.renderingThread start];
}

- (void)render {
    
    unsigned angle = 0;
    
    RTBackground * background = [RTBackground backgroundWithCanvas:[RTCanvas canvasWithImage:[UIImage imageNamed:@"photosphere"]]];
    
    NSArray * objects = @[[RTSphere sphereWithMaterial:[RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1]
                                                                               diffuse:[RTComponent componentWithRed:0.8 green:0.8 blue:0.08]
                                                                              specular:[RTComponent componentWithRed:0.98 green:0.98 blue:0.8]
                                                                             shininess:300.0
                                                                            reflection:0.9
                                                                          transparency:0.0]
                                              position:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0]
                                                radius:1.0],
                          [RTBox boxWithMaterial:[RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1]
                                                                         diffuse:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5]
                                                                        specular:[RTComponent componentWithRed:0.8 green:0.8 blue:0.8]
                                                                       shininess:300.0
                                                                      reflection:0.75
                                                                    transparency:0.0]
                                        position:[RTPoint pointWithX:0.0 Y:4.0 Z:0.0]
                                            size:[RTVector vectorWithX:3.0 Y:0.5 Z:3.0]]
                          ];
    
    NSArray * lights = @[[RTLight lightAtPosition:[RTPoint pointWithX:2.0 Y:11.0 Z:6.0]
                                      withAmbient:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]
                                          diffuse:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]
                                         specular:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]]];
    
    while(![[NSThread currentThread] isCancelled]) {
    
        @autoreleasepool {
            
        
            RTScene * scene = [RTScene sceneWithCamera:[RTCamera cameraWithEye:[RTPoint pointWithX:5.0 * cos((double)angle * (M_PI/180.0)) Y:8.0 Z:5.0 * sin((double)angle * (M_PI/180.0))]
                                                                        lookAt:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0]
                                                                            up:[RTVector vectorWithX:0.0 Y:1.0 Z:0.0]
                                                                           fov:60.0
                                                                           zvp:0.1]
                                             bakground:background
                                               objects:objects
                                                lights:lights];
            
            RTRayTracer * rt = [RTRayTracer fastRayTracerWithScene:scene dimension:[RTDimension dimensionWithWidth:100.0 height:100.0]];
            
//            RTRayTracer * rt = [RTRayTracer niceRayTracerWithScene:scene dimension:[RTDimension dimensionWithWidth:200.0 height:200.0]];
            
            UIImage * result = [[rt trace] image];
            
            [self performSelectorOnMainThread:@selector(setImage:) withObject:result waitUntilDone:YES];
        }
        
        angle += 30;
        angle %= 360;
    }
}

- (void)setImage:(UIImage *)image {
    [self.interfaceImage setImage:image];
}

- (void)didDeactivate {
    [super didDeactivate];
    [_renderingThread cancel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_renderingThread cancel], [_renderingThread release], _renderingThread = nil;
    [_interfaceImage release], _interfaceImage = nil;
    [super dealloc];
}

@end



