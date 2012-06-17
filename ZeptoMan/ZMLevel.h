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
@property (strong) NSArray *walls;
@property (strong) NSMutableArray *food;
@end
