//
//  ViewController.m
//  GLCubeAnimationProduct
//
//  Created by weiqing_iMac on 2020/7/27.
//  Copyright © 2020 iMac. All rights reserved.
//

#import "ViewController.h"

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController ()

{
    EAGLContext *context;
    GLKBaseEffect *cEffect;
    
    GLfloat transAngel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    transAngel = 0;
    
    [self setupContext];
    [self loadSource];
    [self setupVertexData];
}

- (void)loadSource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpeg"];
    //设置 纹理参数 纹理坐标原点是左下角,但是图片显示原点应该是左上角.
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft:@(GL_TRUE)};
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    cEffect = [[GLKBaseEffect alloc] init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = info.name;
    
    // 设置 透视投影
    cEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), self.view.bounds.size.width/self.view.bounds.size.height, 1.0, 100.0f);
    
    // 设置 物体的位置（往里面移动4）
    cEffect.transform.modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4);
    
    glEnable(GL_DEPTH_TEST);
}

- (void)setupContext {
    context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    if (!context) {
        NSLog(@"Create ES context Failed");
    }
    [EAGLContext setCurrentContext:context];
    
    GLKView *curView = (GLKView *)self.view;
    curView.context = context;
    
    curView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    curView.drawableDepthFormat = GLKViewDrawableDepthFormat16;//GLKViewDrawableDepthFormat24
    
    glClearColor(0.0, 0.8, 0.8, 1.0);
}

- (void)setupVertexData {
    GLfloat vertexData[] = {
        0.5, -0.5, 0.5f,    1.0f, 0.0f, //右下
        0.5, 0.5,  0.5f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.5f,    0.0f, 1.0f, //左上
        0.5, -0.5, 0.5f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.5f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.5f,   0.0f, 0.0f, //左下
        
        -0.5, -0.5, 0.5f,    1.0f, 0.0f, //右下
        -0.5, 0.5,  0.5f,    1.0f, 1.0f, //右上
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.5f,    1.0f, 0.0f, //右下
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //左上
        -0.5, -0.5, -0.5f,   0.0f, 0.0f, //左下

        0.5, -0.5, -0.5f,    1.0f, 0.0f, //右下
        0.5, 0.5,  -0.5f,    1.0f, 1.0f, //右上
        0.5, 0.5, 0.5f,    0.0f, 1.0f, //左上
        0.5, -0.5, -0.5f,    1.0f, 0.0f, //右下
        0.5, 0.5, 0.5f,    0.0f, 1.0f, //左上
        0.5, -0.5, 0.5f,   0.0f, 0.0f, //左下

        -0.5, -0.5, -0.5f,   0.0f, 0.0f, //右下
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //右上
        0.5, 0.5,  -0.5f,    1.0f, 1.0f, //左上
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //右下
        0.5, 0.5,  -0.5f,    1.0f, 1.0f, //左上
        0.5, -0.5, -0.5f,    1.0f, 0.0f, //左下

        0.5, 0.5, 0.5f,    1.0f, 0.0f, //右下
        0.5, 0.5,  -0.5f,    1.0f, 1.0f, //右上
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //左上
        0.5, 0.5, 0.5f,    1.0f, 0.0f, //右下
        -0.5, 0.5, -0.5f,    0.0f, 1.0f, //左上
        -0.5, 0.5, 0.5f,   0.0f, 0.0f, //左下

        0.5, -0.5, -0.5f,    1.0f, 0.0f, //右下
        0.5, -0.5,  0.5f,    1.0f, 1.0f, //右上
        -0.5, -0.5, 0.5f,    0.0f, 1.0f, //左上
        0.5, -0.5, -0.5f,    1.0f, 0.0f, //右下
        -0.5, -0.5, 0.5f,    0.0f, 1.0f, //左上
        -0.5, -0.5, -0.5f,   0.0f, 0.0f, //左下
    };
    
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    // 将顶点数组的数据copy到顶点缓存区中(GPU显存中)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //顶点坐标数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    //纹理坐标数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self updateEffectMatrix];
    
    [cEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)updateEffectMatrix {
    transAngel += 8;
    transAngel = (GLint)transAngel%360;
    GLKMatrix4 matrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4.0);
    
    cEffect.transform.modelviewMatrix = GLKMatrix4Rotate(matrix, GLKMathDegreesToRadians(transAngel), 0.4, 0.8, 0.6);
}

@end
