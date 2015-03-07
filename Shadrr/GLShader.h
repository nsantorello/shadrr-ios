//  Originally taken from http://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLShader : NSObject

- (NSString*)setVertexShader:(NSString*)vsh;
- (NSString*)setFragmentShader:(NSString*)fsh;
- (NSString*)compile;
- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time;

@end