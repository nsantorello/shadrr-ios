//  Originally taken from http://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial

/*#import "GLShader.h"

static GLfloat const RWTBaseShaderQuad[8] = {
  -1.f, -1.f,
  -1.f, +1.f,
  +1.f, -1.f,
  +1.f, +1.f,
};

@interface GLShader ()

// Program Handle
@property (assign, nonatomic, readonly) GLuint program;

// Attribute Handles
@property (assign, nonatomic, readonly) GLuint aPosition;

// Uniform Handles
@property (assign, nonatomic, readonly) GLuint uResolution;
@property (assign, nonatomic, readonly) GLuint uTime;

@end

@implementation GLShader

#pragma mark - Lifecycle
- (instancetype)initWithVertexShader:(NSString *)vsh fragmentShader:(NSString *)fsh {
  self = [super init];
  if (self) {
    // Program
    _program = [self programWithVertexShader:vsh fragmentShader:fsh];
    
    // Attributes
    _aPosition = glGetAttribLocation(_program, "aPosition");
    
    // Uniforms
    _uResolution = glGetUniformLocation(_program, "uResolution");
    _uTime = glGetUniformLocation(_program, "uTime");
    
    // Configure OpenGL ES
    [self configureOpenGLES];
  }
  return self;
}

#pragma mark - Public
#pragma mark - Render
- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time {
  // Uniforms
  glUniform2f(self.uResolution, CGRectGetWidth(rect)*2.f, CGRectGetHeight(rect)*2.f);
  glUniform1f(self.uTime, time);
  
  // Draw
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - Private
#pragma mark - Configurations
- (void)configureOpenGLES {
  // Program
  glUseProgram(_program);
  
  // Attributes
  glEnableVertexAttribArray(_aPosition);
  glVertexAttribPointer(_aPosition, 2, GL_FLOAT, GL_FALSE, 0, RWTBaseShaderQuad);
}

#pragma mark - Compile & Link
- (GLuint)programWithShader:(NSString*)fragCode {
    // Build shaders
    GLuint vertexShader = [self compileShader:@"void main() { gl_Position = vec4(1.0); }\n"];
    GLuint fragmentShader = [self compileShader:(fragCode ? fragCode : @"void main() { gl_FragColor = vec4(1.0); }\n")];
  
    // Create program
    GLuint programHandle = glCreateProgram();
  
  // Attach shaders
  glAttachShader(programHandle, vertexShader);
  glAttachShader(programHandle, fragmentShader);
  
  // Link program
  glLinkProgram(programHandle);
  
  // Check for errors
  GLint linkSuccess;
  glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[1024];
    glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
    NSLog(@"%@:- GLSL Program Error: %s", [self class], messages);
  }
  
  // Delete shaders
  glDeleteShader(vertexShader);
  glDeleteShader(fragmentShader);
  
  return programHandle;
}

- (GLuint)compileShader:(NSString*)code {
  
  // Create the shader source
  const GLchar* source = (GLchar*)[code UTF8String];
  
  // Create the shader object
  GLuint shaderHandle = glCreateShader(type);
  
  // Load the shader source
  glShaderSource(shaderHandle, 1, &source, 0);
  
  // Compile the shader
  glCompileShader(shaderHandle);
  
  // Check for errors
  GLint compileSuccess;
  glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[1024];
    glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
    NSLog(@"%@:- GLSL Shader Error: %s", [self class], messages);
  }
  
  return shaderHandle;
}

@end*/
