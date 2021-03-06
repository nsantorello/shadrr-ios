//
//  ConnectedViewController.h
//  Shadrr
//
//  Created by Noah Santorello on 3/6/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaderServerDelegate.h"

@interface ConnectedViewController : UIViewController<ShaderServerDelegate>

- (void)connected:(NSDictionary *)metadata;
- (void)disconnected;
- (void)updatedShader:(NSString*)filename withCode:(NSString*)code;

@end
