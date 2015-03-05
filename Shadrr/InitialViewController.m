//
//  InitialViewController.m
//  Shadrr
//
//  Created by Noah Santorello on 3/4/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import "InitialViewController.h"
#import "AppDelegate.h"
#import "PulsingHaloLayer.h"

@implementation InitialViewController

NSString* _code;
NSString* _filename;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Ensure we get shader updates
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.shaderPushDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set up pulsing halo - do it here since it's based on shadrrLogo's
    // center and since that's defined by constraints it won't be centered in viewDidLoad
    PulsingHaloLayer* halo = [PulsingHaloLayer layer];
    halo.position = self.shadrrLogo.center;
    halo.radius = self.view.frame.size.width / 3.;
    UIColor *color = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    halo.backgroundColor = color.CGColor;
    [self.view.layer insertSublayer:halo below:self.shadrrLogo.layer];
}

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code {
    // Save these values so we can pass them onto the next controller
    _code = code;
    _filename = filename;
    
    // Segue to next controller
    [self performSegueWithIdentifier:@"ShowShaderView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destController = [segue destinationViewController];
    if ([destController conformsToProtocol:@protocol(ShaderPushCallback)]) {
        id<ShaderPushCallback> callback = (id<ShaderPushCallback>)destController;
        [callback updatedShader:_filename withCode:_code];
    }
}

@end
