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

float bgcolor = 0.f;

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Update shader here.
        bgcolor = 1.f;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Ensure we get shader updates
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.shaderPushDelegate = self;
    
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.delegate = self;
    
    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;

    // Initialize shader
    //self.shader = [[GLShader alloc] initWithFragmentShader:@"RWTBase" fragmentShader:@"RWTBase"];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(bgcolor, 0.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //[self.shader renderInRect:rect atTime:self.timeSinceFirstResume];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
