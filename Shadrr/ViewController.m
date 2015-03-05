//
//  ViewController.m
//  Shadrr
//
//  Created by Noah Santorello on 3/3/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import "ViewController.h"
#import "ShaderServer.h"

@interface ViewController ()

@end

@implementation ViewController

ShaderServer* _server;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the Bonjour service and web server for shader communication
    _server = [[ShaderServer alloc] init];
    [_server initializeServer:^ (NSString* filename, NSString* shaderCode) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.textView setText:shaderCode];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
