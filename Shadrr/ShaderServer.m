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
    
    // Handle initial connection attempt
    [_webServer addHandlerForMethod:@"POST" path:@"/connect"
                       requestClass:[GCDWebServerURLEncodedFormRequest class]
                       processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request)
     {
         if (self.delegate) {
             [self.delegate connected:[(GCDWebServerURLEncodedFormRequest*)request arguments]];
         }
         
         return [GCDWebServerResponse responseWithStatusCode:200];
     }];
    
    // Handle initial connection attempt
    [_webServer addHandlerForMethod:@"POST" path:@"/disconnect"
                       requestClass:[GCDWebServerURLEncodedFormRequest class]
                       processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request)
     {
         if (self.delegate) {
             [self.delegate disconnected];
         }
         
         return [GCDWebServerResponse responseWithStatusCode:200];
     }];
    
    // Handle shader updates
    [_webServer addHandlerForMethod:@"POST" path:@"/shader"
                requestClass:[GCDWebServerURLEncodedFormRequest class]
                processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request)
     {
         NSString* filename = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"filename"];
         NSString* code = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"code"];

         // Sanity check -- do shader params exist?
        if (filename && code) {
            if (self.delegate) {
                [self.delegate updatedShader:filename withCode:code];
            }
            
            // Good request
            return [GCDWebServerResponse responseWithStatusCode:200];
        } else {
            // Bad request
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
