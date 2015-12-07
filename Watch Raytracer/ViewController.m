//
//  ViewController.m
//  Watch Raytracer
//
//  Created by Fabio Dela Antonio on 12/5/15.
//  Copyright © 2015 bluenose. All rights reserved.
//

#import "ViewController.h"

#import "RTRayTracer.h"
#import "RTSphere.h"
#import "RTBox.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet UIImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    RTCamera * camera = [RTCamera cameraWithEye:[RTPoint pointWithX:-5.0 Y:8.0 Z:5.0]
                                         lookAt:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0]
                                             up:[RTVector vectorWithX:0.0 Y:1.0 Z:0.0]
                                            fov:60.0
                                            zvp:0.1];
    
    RTSphere * sphere = [RTSphere sphereWithMaterial:[RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1]
                                                                             diffuse:[RTComponent componentWithRed:0.8 green:0.8 blue:0.08]
                                                                            specular:[RTComponent componentWithRed:0.98 green:0.98 blue:0.8]
                                                                           shininess:300.0
                                                                          reflection:0.9
                                                                        transparency:0.0]
                                            position:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0]
                                              radius:1.0];
    
    RTBox * box = [RTBox boxWithMaterial:[RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1]
                                                                 diffuse:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5]
                                                                specular:[RTComponent componentWithRed:0.8 green:0.8 blue:0.8]
                                                               shininess:300.0
                                                              reflection:0.75
                                                            transparency:0.0]
                                position:[RTPoint pointWithX:0.0 Y:4.0 Z:0.0]
                                    size:[RTVector vectorWithX:3.0 Y:0.5 Z:3.0]];
    
    RTLight * light = [RTLight lightAtPosition:[RTPoint pointWithX:2.0 Y:11.0 Z:6.0]
                                   withAmbient:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]
                                       diffuse:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]
                                      specular:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]];
    
    RTScene * scene = [RTScene sceneWithCamera:camera
                                     bakground:[RTBackground backgroundWithCanvas:[RTCanvas canvasWithImage:[UIImage imageNamed:@"photosphere"]]]
                                       objects:@[sphere, box]
                                        lights:@[light]];
    
    [self performSelectorInBackground:@selector(render:) withObject:scene];
}

- (void)render:(RTScene *)scene {
    
    RTRayTracer * rt = [RTRayTracer niceRayTracerWithScene:scene dimension:[RTDimension dimensionWithSize:self.imageView.frame.size]];
    
    UIImage * result = [[rt trace] image];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:result waitUntilDone:NO];
}

- (void)setImage:(UIImage *)image {
    
    self.imageView.image = image;
}

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_imageView release];
    [super dealloc];
}
@end
