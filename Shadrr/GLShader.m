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
@property (assign, nonatomic, readonly) GLuint program;

// Shader Handles
@property (assign, nonatomic, readonly) GLuint vertexShader;
@property (assign, nonatomic, readonly) GLuint fragmentShader;

// Attribute Handles
@property (assign, nonatomic, readonly) GLuint aPosition;

// Uniform Handles
@property (assign, nonatomic, readonly) GLuint uResolution;
@property (assign, nonatomic, readonly) GLuint uTime;

@end

@implementation GLShader

- (NSString*)setVertexShader:(NSString*)vsh {
    return [self setShader:&_vertexShader code:vsh type:GL_VERTEX_SHADER];
}

- (NSString*)setFragmentShader:(NSString*)fsh {
    return [self setShader:&_fragmentShader code:fsh type:GL_FRAGMENT_SHADER];
}

- (NSString*)setShader:(GLuint*)shaderPointer code:(NSString*)code type:(GLenum)type {
    GLuint oldShader = _fragmentShader;
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

- (NSString*)compile {
    GLuint oldProgram = _program;
    GLuint newProgram = [self programWithVertexShader:_vertexShader fragmentShader:_fragmentShader];
    NSString* errors = [self getProgramLinkErrors:newProgram];
    if (errors) {
        glDeleteProgram(newProgram);
    } else {
        // Set new shader
        _program = newProgram;
        
        // Reset attributes and uniforms
        _aPosition = glGetAttribLocation(_program, "aPosition");
        _uResolution = glGetUniformLocation(_program, "uResolution");
        _uTime = glGetUniformLocation(_program, "uTime");
        
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
