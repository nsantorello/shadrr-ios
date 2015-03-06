//
//  ShaderServer.h
//  Shadrr
//
//  Created by Noah Santorello on 3/3/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShaderServerDelegate.h"

@interface ShaderServer : NSObject

@property (strong, nonatomic) id<ShaderServerDelegate> delegate;

- (void)initializeServer;

@end
