# Watch RayTracer
![Picture](/watch.jpg?raw=true)

A simple ray tracer for iOS 9.0 and watchOS 2.0 written in Objetive-C. 

## Why?
I wanted to be the first one to run a ray tracer on a watch. It works, however it may take a while to render a single frame on the Apple Watch (try undefining "ANTIALIASING" to make it run faster).

## Example
### Creating a scene
```objective-c
RTCamera * camera = [RTCamera cameraWithEye:[RTPoint pointWithX:-5.0 Y:8.0 Z:5.0] lookAt:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0] up:[RTVector vectorWithX:0.0 Y:1.0 Z:0.0] fov:45.0 zvp:0.1];
    
RTColour * backgroundColour = [RTColour colourWithRed:40.0 green:40.0 blue:40.0];
    
RTMaterial * sphereMaterial = [RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1] diffuse:[RTComponent componentWithRed:0.8 green:0.8 blue:0.08] specular:[RTComponent componentWithRed:0.98 green:0.98 blue:0.8] shininess:300.0 reflection:0.15 transparency:0.0];
    
RTSphere * sphere = [RTSphere sphereWithMaterial:sphereMaterial position:[RTPoint pointWithX:0.0 Y:5.0 Z:0.0] radius:1.0];

RTMaterial * boxMaterial = [RTMaterial materialWithAmbient:[RTComponent componentWithRed:0.1 green:0.1 blue:0.1] diffuse:[RTComponent componentWithRed:0.5 green:0.5 blue:0.5] specular:[RTComponent componentWithRed:0.8 green:0.8 blue:0.8] shininess:300.0 reflection:0.75 transparency:0.0];

RTBox * box = [RTBox boxWithMaterial:boxMaterial position:[RTPoint pointWithX:0.0 Y:4.0 Z:0.0] size:[RTVector vectorWithX:3.0 Y:0.5 Z:3.0]];
    
RTLight * light = [RTLight lightAtPosition:[RTPoint pointWithX:2.0 Y:11.0 Z:6.0] withAmbient:[RTColour colourWithRed:255.0 green:255.0 blue:255.0] diffuse:[RTColour colourWithRed:255.0 green:255.0 blue:255.0] specular:[RTColour colourWithRed:255.0 green:255.0 blue:255.0]];
    
RTScene * scene = [RTScene sceneWithCamera:camera bakgroundColour:backgroundColour objects:@[sphere, box] lights:@[light]];
```

### Rendering that scene
```objective-c
UIImage * result = [[RTRayTracer rayTraceScene:scene dimension:[RTDimension dimensionWithSize:CGSizeMake(100, 100)]] image];
```

### Requires
* XCode 7.1 (iOS 9.0 + watchOS 2.0)

### Developer
[Fabio de Albuquerque Dela Antonio](http://fabio914.blogspot.com)



