//
//  InitialViewController.h
//  Shadrr
//
//  Created by Noah Santorello on 3/4/15.
//  Copyright (c) 2015 Noah Santorello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaderPushCallback.h"

@interface InitialViewController : UIViewController<ShaderPushCallback>

@property (weak) IBOutlet UILabel* shadrrLogo;

- (void)updatedShader:(NSString*)filename withCode:(NSString*)code;

@end
