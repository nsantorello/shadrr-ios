//  Originally taken from http://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial

#import "GLShader.h"


static GLfloat const RWTBaseShaderQuad[8] = {
  -1.f, -1.f,
  -1.f, +1.f,
  +1.f, -1.f,
  +1.f, +1.f,
};

@interface GLShader ()

// Program Handle
@property (assign, nonatomic) GLuint program;

// Shader Handles
@property (assign, nonatomic) GLuint vertShader;
@property (assign, nonatomic) GLuint fragShader;

// Attribute Handles
@property (assign, nonatomic) GLuint aPosition;

// Shader inputs Handles
@property (assign, nonatomic) GLuint iResolution;
@property (assign, nonatomic) GLuint iGlobalTime;

@property (assign, nonatomic) GLuint startTime;

@end

@implementation GLShader

- (instancetype)init {
    self = [super init];
    if (self) {
        _startTime = CACurrentMediaTime();
    }
    return self;
}

- (NSString*)setVertexShader:(NSString*)vsh {
    return [self setShader:&_vertShader code:vsh type:GL_VERTEX_SHADER];
}

- (NSString*)setFragmentShader:(NSString*)fsh {
    return [self setShader:&_fragShader code:fsh type:GL_FRAGMENT_SHADER];
}

- (NSString*)setShader:(GLuint*)shaderPointer code:(NSString*)code type:(GLenum)type {
    GLuint oldShader = *shaderPointer;
    GLuint newShader = [self compileShader:code type:type];
    NSString* errors = [self getShaderCompilationErrors:newShader];
    if (errors) {
        glDeleteShader(newShader);
    } else {
        // Set new shader
        *shaderPointer = newShader;
        
        // No longer need old shader
        if (oldShader) {
            glDeleteShader(oldShader);
        }
    }
    
    return errors;
}

- (NSString*)linkProgram {
    GLuint oldProgram = _program;
    GLuint newProgram = [self programWithVertexShader:_vertShader fragmentShader:_fragShader];
    NSString* errors = [self getProgramLinkErrors:newProgram];
    if (errors) {
        glDeleteProgram(newProgram);
    } else {
        // Set new shader
        _program = newProgram;
        
        // Set shader inputs
        _aPosition = glGetAttribLocation(_program, "aPosition");
        _iResolution = glGetUniformLocation(_program, "iResolution");
        _iGlobalTime = glGetUniformLocation(_program, "iGlobalTime");
        
        // Configure OpenGL ES
        [self configureOpenGLES];
        
        // No longer need old shader
        if (oldProgram) {
            glDeleteProgram(oldProgram);
        }
    }
    
    return errors;
}

#pragma mark - Public
#pragma mark - Render
- (void)renderInRect:(CGRect)rect {
    // Uniforms
    glUniform3f(self.iResolution, CGRectGetWidth(rect)*2.f, CGRectGetHeight(rect)*2.f, 1.f);
    glUniform1f(self.iGlobalTime, CACurrentMediaTime() - _startTime);
    
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
- (GLuint)programWithVertexShader:(GLuint)vsh fragmentShader:(GLuint)fsh {
    // Create program
    GLuint programHandle = glCreateProgram();
    
    // Attach shaders
    glAttachShader(programHandle, vsh);
    glAttachShader(programHandle, fsh);
    
    // Link program
    glLinkProgram(programHandle);
    
    return programHandle;
}

- (GLuint)compileShader:(NSString*)code type:(GLenum)type {
  // Create the shader source
  const GLchar* source = (GLchar*)[code UTF8String];
  
  // Create the shader object
  GLuint shaderHandle = glCreateShader(type);
  
  // Load the shader source
  glShaderSource(shaderHandle, 1, &source, 0);
  
  // Compile the shader
  glCompileShader(shaderHandle);
  
  return shaderHandle;
}

- (NSString*)getShaderCompilationErrors:(GLuint)shaderHandle {
    // Check for errors
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        return [NSString stringWithUTF8String:messages];
    }
    
    return nil;
}

- (NSString*)getProgramLinkErrors:(GLuint)programHandle {
    // Check for errors
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        return [NSString stringWithUTF8String:messages];
    }
    
    return nil;
}

@end
