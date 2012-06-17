//
//  ZMLevel.m
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZMLevel.h"

static int level1_horizontal_walls[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                         0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0,
                                         0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0,
                                         0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0,
                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0,
                                         0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                         1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
                                        };

static int level1_vertical_walls[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                                       1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1,
                                       1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1,
                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                                       1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1,
                                       1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1,
                                       1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1,
                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                                      };

static int coins[] =  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
};


@interface ZMLevel()
{
    NSMutableArray *_walls;
    NSMutableArray *_coins;
}
@end

@implementation ZMLevel

- (NSMutableArray *) walls
{
    if (!_walls)
    {
        _walls = [NSMutableArray array];
    }
    return _walls;
}

- (NSMutableArray *)coins
{
    if (!_coins){
        _coins = [NSMutableArray array];

    }
    return _coins;
}

- (void)loadWallsWithTexture:(GLKTextureInfo *)texInfo
{
    @autoreleasepool {
    
        [self.walls removeAllObjects];
        for (int i=0; i<16; i++){
            for (int j=0; j<12; j++) {
                if (level1_horizontal_walls[i + j*16] == 1){
                    
                    ZMSprite *wall = [[ZMSprite alloc] init];
                    wall.position = GLKVector2Make((float)i - 8.0 + 0.5, 6.0 - (float)j);
                    wall.width = 1.0;
                    wall.height = 0.2;
                    [wall setDefaultTextureCoordinates];
                    wall.texture = texInfo;
                    [self.walls addObject:wall];
                }
            }
        }
        
        for (int i=0; i<17; i++){
            for (int j=0; j<11; j++) {
                if (level1_vertical_walls[i + j*17] == 1){
                    
                    
                    ZMSprite *wall = [[ZMSprite alloc] init];
                    wall.position = GLKVector2Make((float)i - 8.0, 6.0 - 0.5 - (float)j);
                    wall.width = 0.2;
                    wall.height = 1.0;
                    [wall setDefaultTextureCoordinates];
                    wall.texture = texInfo;
                    [self.walls addObject:wall];
                }
            }
        }
    }
}

- (void)loadCoinsWithTexture:(GLKTextureInfo *)texInfo
{
    @autoreleasepool {
    
        [self.coins removeAllObjects];
        
        for (int i=0; i<16; i++){
            for (int j=0; j<12; j++) {
                if (coins[i + j*16] == 1)
                {
                    ZMSprite *coin = [[ZMSprite alloc] init];
                    coin.position = GLKVector2Make((float)i - 8.0 + 0.5, 6.0 - 0.5 - (float)j);
                    coin.width = 0.25;
                    coin.height = 0.25;
                    [coin setDefaultTextureCoordinates];
                    coin.texture = texInfo;
                    
                    [self.coins addObject:coin];
                }
            }
        }
    }

    
    
}

@end
