
//
//  ConnectedViewController.m
//  Shadrr
//
//  Created by Noah Santorello on 3/6/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import "AppDelegate.h"
#import "ConnectedViewController.h"

@implementation ConnectedViewController

NSString* _code;
NSString* _filename;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Ensure we get shader updates
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.shaderServer.delegate = self;
}

- (void)connected:(NSDictionary *)metadata {
    // Ignore this -- likely just erroneous connection notifications
}

- (void)disconnected {
    // Segue back to initial view controller
}

 - (void)updatedShader:(NSString*)filename withCode:(NSString*)code {
     // Save these values so we can pass them onto the next controller
     _code = code;
     _filename = filename;
     
     [self performSegueWithIdentifier:@"ShowShaderView" sender:self];
 }
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Pass along shader update to new controller
     id destController = [segue destinationViewController];
     if ([destController conformsToProtocol:@protocol(ShaderServerDelegate)]) {
         id<ShaderServerDelegate> callback = (id<ShaderServerDelegate>)destController;
        [callback updatedShader:_filename withCode:_code];
     }
 }

@end
