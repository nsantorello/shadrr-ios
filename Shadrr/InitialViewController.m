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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Ensure we get shader updates
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.shaderServer.delegate = self;
    
    // Set up pulsing halo - do it here since it's based on shadrrLogo's
    // center and since that's defined by constraints it won't be centered in viewDidLoad
    PulsingHaloLayer* halo = [PulsingHaloLayer layer];
    halo.position = self.shadrrLogo.center;
    halo.radius = self.view.frame.size.width / 3.;
    UIColor *color = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    halo.backgroundColor = color.CGColor;
    [self.view.layer insertSublayer:halo below:self.shadrrLogo.layer];
}

- (void)connected:(NSDictionary *)metadata {
    // Segue to next controller
    [self performSegueWithIdentifier:@"ShowConnectedView" sender:self];
}

- (void)disconnected {
    // Do nothing since we're already on the correct view
}

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code {
    // Ignore this since we can't handle it
}

@end
