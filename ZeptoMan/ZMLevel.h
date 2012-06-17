//
//  ZMLevel.h
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMSprite.h"

@interface ZMLevel : NSObject
@property (readonly) NSMutableArray *walls;
@property (readonly) NSMutableArray *coins;
- (void)loadWallsWithTexture:(GLKTextureInfo *)texInfo;
- (void)loadCoinsWithTexture:(GLKTextureInfo *)texInfo;
@end
