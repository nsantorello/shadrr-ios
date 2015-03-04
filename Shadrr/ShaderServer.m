//
//  ShaderServer.m
//  Shadrr
//
//  Created by Noah Santorello on 3/3/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaderServer.h"
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerURLEncodedFormRequest.h>
#import <GCDWebServer/GCDWebServerResponse.h>

@implementation ShaderServer

GCDWebServer* _webServer;

- (void)initializeServer {
    // Initialize server
    _webServer = [[GCDWebServer alloc] init];
    
    // Add POST request that handles incoming data
    [_webServer addDefaultHandlerForMethod:@"POST"
                              requestClass:[GCDWebServerURLEncodedFormRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request)
    {
        NSString* shader = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"shader"];
        if (shader) {
            // Shader param exists -- success passing shader data to app
            return [GCDWebServerResponse responseWithStatusCode:200];
        } else {
            // Shader param not found -- bad request
            return [GCDWebServerResponse responseWithStatusCode:400];
        }
    }];
    
    // Set up bonjour options
    NSDictionary* bonjourOptions =
        @{
          GCDWebServerOption_BonjourName: [[UIDevice currentDevice] name],
          GCDWebServerOption_BonjourType: @"_shadrr._tcp."
          };
    
    // Start server + bonjour
    NSError* error = [[NSError alloc] init];
    [_webServer startWithOptions:bonjourOptions error:&error];
    
    NSLog(@"[ShaderServer] Live at %@", _webServer.serverURL);
}

@end
