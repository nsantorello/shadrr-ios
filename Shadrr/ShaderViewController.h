//
//  ViewController.h
//  Shadrr
//
//  Created by Noah Santorello on 3/3/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ShaderPushCallback.h"

@interface ShaderViewController : GLKViewController<ShaderPushCallback>

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code;

@end

