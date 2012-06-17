//
//  ZMScene.m
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZMScene.h"
#import "ZMSprite.h"
#import "ZMLevel.h"
#import "ZMEnemy.h"

@interface ZMScene()
{
    ZMSprite *player;
    ZMEnemy *enemy;
    sceneState state;
    
    GLKTextureInfo *coinTexture;    
    GLKTextureInfo *playerTexture1;    
    GLKTextureInfo *playerTexture2;    
    GLKTextureInfo *enemyTexture;    
    GLKTextureInfo *wallTexture;    
}
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong) ZMLevel *level;

@end

@implementation ZMScene

@synthesize effect = _effect;
@synthesize left = _left, right = _right, bottom = _bottom, top = _top;
@synthesize level = _level;

- (void)loadInitialPosition
{
    NSError *error;
    if (!coinTexture) coinTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"coin.png"].CGImage options:nil error:&error];
    if (!playerTexture1) playerTexture1 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"ZMan1.png"].CGImage options:nil error:&error];
    if (!playerTexture2) playerTexture2 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"ZMan2.png"].CGImage options:nil error:&error];
    if (!enemyTexture) enemyTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"fire.png"].CGImage options:nil error:&error];
    if (!wallTexture) wallTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"wall.png"].CGImage options:nil error:&error];
    
    player.width  = 0.7;
    player.height = 0.7;
    player.position = GLKVector2Make(0.5, 0.5);
    player.rotation = 0;
    player.velocity = GLKVector2Make(0, 0);
    
    [player setDefaultTextureCoordinates];
    player.texture = playerTexture1;
    
    NSArray *frames = [NSArray arrayWithObjects:playerTexture1, playerTexture2, nil];
    player.spriteAnimation = [[ZMSpriteAnimation alloc] initWithTimePerFrame:0.2 frames:frames]; 
    

    enemy.width  = 0.7;
    enemy.height = 0.7;
    enemy.position = GLKVector2Make(-5.5, 0.5);
    enemy.rotation = 0;
    enemy.velocity = GLKVector2Make(1.0, 0.0);
    
    [enemy setDefaultTextureCoordinates];
    
    enemy.texture = enemyTexture;

    [self.level loadWallsWithTexture:wallTexture];
    [self.level loadCoinsWithTexture:coinTexture];
}

- (id)init
{
    if (self = [super init]){
        player = [[ZMSprite alloc] init];
        
        enemy = [[ZMEnemy alloc] init];
        
        self.level = [[ZMLevel alloc] init];
        
        [self loadInitialPosition];
        
        state = SCENE_STATE_PLAYING;
        
    }
    return self;
}

- (void)setupGL
{
    self.effect = [[GLKBaseEffect alloc] init];    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.left   = -9;
        self.right  =  9;
        self.bottom = -6;
        self.top    =  6;
    } else {
        self.left   = -8;
        self.right  =  8;
        self.bottom = -6;
        self.top    =  6;
    }
    
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(self.left, self.right, self.bottom, self.top, 1, -1);
}

- (void)tearDownGL
{
    self.effect = nil;
    state = SCENE_STATE_PAUSED;

}

# pragma mark - Gesture handlers

- (void)swipe:(UISwipeGestureRecognizerDirection)direction
{
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:{
            player.nextTurn = TURN_DIRECTION_UP;
            break;
        }
            
        case UISwipeGestureRecognizerDirectionDown:{
            player.nextTurn = TURN_DIRECTION_DOWN;
            break;            
        }
            
        case UISwipeGestureRecognizerDirectionRight:{
            player.nextTurn = TURN_DIRECTION_RIGHT;
            break;            
        }
            
        case UISwipeGestureRecognizerDirectionLeft:{
            player.nextTurn = TURN_DIRECTION_LEFT;
            break;            
        }
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected direction: %@", self, NSStringFromSelector(_cmd), direction);
            break;
        }
    }
}

#pragma mark - Physics & Game Logic

- (BOOL)areRectangle:(CGRect)r1 IntersectsWithRectangle:(CGRect)r2
{
    float left1 = r1.origin.x;
    float left2 = r2.origin.x;
    
    float right1 = r1.origin.x + r1.size.width;
    float right2 = r2.origin.x + r2.size.width;
    
    float bottom1 = r1.origin.y;
    float bottom2 = r2.origin.y;
    
    float top1 = r1.origin.y + r1.size.height;
    float top2 = r2.origin.y + r2.size.height;
    
    if(bottom1 > top2) {
        return NO;   
    }
    if(top1 < bottom2){
        return NO;   
    }
    if(right1 < left2){
        return NO;   
    }
    if(left1 > right2) {
        return NO;   
    }
    return YES;
}

- (BOOL)doesSprite:(ZMSprite *)sprite1 intersectsWithSprite:(ZMSprite *)sprite2
{
    CGRect spriteBox1 = CGRectMake(sprite1.position.x - sprite1.width/2.0, sprite1.position.y - sprite1.height/2.0, sprite1.width, sprite1.height);
    CGRect spriteBox2 = CGRectMake(sprite2.position.x - sprite2.width/2.0, sprite2.position.y - sprite2.height/2.0, sprite2.width, sprite2.height);
    if ([self areRectangle:spriteBox1 IntersectsWithRectangle:spriteBox2]){
        return YES;
    }
    return NO;
}

- (BOOL)spriteCollidesWithWalls:(ZMSprite *)sprite
{
    for (ZMSprite *wall in self.level.walls) {
        if([self doesSprite:sprite intersectsWithSprite:wall]){
            return YES;
        }
    }
    
    return NO;
}

- (void)processPlayerAndCoinsCollisions
{
    CGRect playerBox = CGRectMake(player.position.x - player.width/2.0, player.position.y - player.height/2.0, player.width, player.height);
    CGRect coinBox;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (ZMSprite *coin in self.level.coins)
    {
        coinBox = CGRectMake(coin.position.x - coin.width/2.0, coin.position.y - coin.height/2.0, coin.width, coin.height);
        if ([self areRectangle:playerBox IntersectsWithRectangle:coinBox]){
            [tempArray addObject:coin];
        }
    }
    
    for (ZMSprite *coinToRemove in tempArray) {
        [self.level.coins removeObject:coinToRemove];
    }
    
}

- (BOOL)playerHasWon
{
    return ([self.level.coins count] == 0);
}


- (void)update:(NSTimeInterval)dt
{
    if (state == SCENE_STATE_PLAYING)
    {
        [player update:dt];
        if ([self spriteCollidesWithWalls:player]){
            [player restorePosition];
        }
        [self processPlayerAndCoinsCollisions];
        if ([self playerHasWon]){
            state = SCENE_STATE_PAUSED;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You win" 
                                                            message:@"Congratulations!" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Restart Level"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [enemy think];
        [enemy update:dt];
        if ([self spriteCollidesWithWalls:enemy]){
            [enemy restorePosition];
        }
        
        if ([self doesSprite:player intersectsWithSprite:enemy]){
            state = SCENE_STATE_PAUSED;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lose" 
                                                            message:@"Try again!" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Restart Level"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self loadInitialPosition];
    state = SCENE_STATE_PLAYING;
}

# pragma mark - Graphics

- (void)render
{
    if (state == SCENE_STATE_PLAYING)
    {
    
        glClearColor(0.5f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);   
                
        [player renderWithEffect:self.effect];
        
        [self.level.walls makeObjectsPerformSelector:@selector(renderWithEffect:) withObject:self.effect];
        
        [self.level.coins makeObjectsPerformSelector:@selector(renderWithEffect:) withObject:self.effect];
        
        [enemy renderWithEffect:self.effect];
    }
    
}

@end
