//
//  ZMScene.m
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZMScene.h"

@interface ZMScene()
{

}
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation ZMScene

@synthesize effect = _effect;

//- (id)init
//{
//    if (self = [super init]){
//    }
//    return self;
//}

- (void)setupGL
{
    self.effect = [[GLKBaseEffect alloc] init];    
}

- (void)tearDownGL
{
    self.effect = nil;
}

- (void)update
{
    
}

- (void)render
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);   
    
    float vertices[] = {-1, -1,
                         1, -1,
                         0,  1};
    
    [self.effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
