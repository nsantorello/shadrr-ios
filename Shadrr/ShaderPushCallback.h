//
//  ShaderPushCallback.h
//  Shadrr
//
//  Created by Noah Santorello on 3/4/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShaderPushCallback <NSObject>

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code;

@end
