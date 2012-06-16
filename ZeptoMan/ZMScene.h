//
//  ZMScene.h
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ZMScene : NSObject

- (void)setupGL;
- (void)tearDownGL;

- (void)update;
- (void)render;

@end
