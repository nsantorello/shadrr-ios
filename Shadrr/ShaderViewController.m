//
//  ViewController.m
//  Shadrr
//
//  Created by Noah Santorello on 3/3/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import "ShaderViewController.h"
#import "ShaderServer.h"
#import <GLKit/GLKit.h>
#import "GLShader.h"
#import "AppDelegate.h"

@interface ShaderViewController ()

@end

@implementation ShaderViewController

GLShader* _shader;

- (void)setupOpenGL {
    // Set up context
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = context;
    
    // OpenGL ES settings
    glClearColor(1.f, 0.f, 0.f, 1.f);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Ensure we get shader updates
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.shaderServer.delegate = self;
}

- (void)connected:(NSDictionary *)metadata {
    // Ignore this since we know we're already connected
}

- (void)disconnected {
    // TODO: Segue back to initial view controller
}

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Set up OpenGL and vertex shader if it hasn't been set up yet
        if (!_shader) {
            [self setupOpenGL];
            
            // Create shader and set vertex shader
            NSString* vert = @"attribute vec2 aPosition; void main() { gl_Position = vec4(aPosition, 0., 1.); }\n";
            _shader = [[GLShader alloc] init];
            [_shader setVertexShader:vert];
        }
        
        // Set fragment shader and compile program
        [_shader setFragmentShader:code];
        [_shader compile];
    }];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Might be null between pushing controller and receiving first shader update, so check!
    if (_shader) {
        [_shader renderInRect:rect atTime:self.timeSinceFirstResume];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
