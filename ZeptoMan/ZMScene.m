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

@interface ZMScene()
{
    ZMSprite *player;
}
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong) ZMLevel *level;

@end

@implementation ZMScene

@synthesize effect = _effect;
@synthesize left = _left, right = _right, bottom = _bottom, top = _top;
@synthesize level = _level;

- (id)init
{
    if (self = [super init]){
        player = [[ZMSprite alloc] init];
        player.width  = 0.7;
        player.height = 0.7;
        player.position = GLKVector2Make(0.5, 0.5);
        player.rotation = 0;
        player.velocity = GLKVector2Make(0, 0);
        [player setTextureImage:[UIImage imageNamed:@"ZMan2.png"]];
        NSArray *names = [NSArray arrayWithObjects:@"ZMan2.png", @"ZMan1.png", nil];
        player.spriteAnimation = [[ZMSpriteAnimation alloc] initWithTimePerFrame:0.2 framesNamed:names];
        
        self.level = [[ZMLevel alloc] init];
        
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

- (BOOL)playerCollidesWithWalls{

//    float playerBoxWidth = 0.6;
//    float playerBoxHeight = 0.6;
//    CGRect playerBox = CGRectMake(player.position.x - playerBoxWidth/2.0, player.position.y - playerBoxHeight/2.0, playerBoxWidth, playerBoxHeight);
    
    CGRect playerBox = CGRectMake(player.position.x - player.width/2.0, player.position.y - player.height/2.0, player.width, player.height);
    CGRect wallBox;

    for (ZMSprite *wall in self.level.walls)
    {
        wallBox = CGRectMake(wall.position.x - wall.width/2.0, wall.position.y - wall.height/2.0, wall.width, wall.height);
        if ([self areRectangle:playerBox IntersectsWithRectangle:wallBox]){
            return YES;
        }
            
    }
    
    return NO;
}


- (void)update:(NSTimeInterval)dt
{
    [player update:dt];
    if ([self playerCollidesWithWalls]){
        [player restorePosition];
    }
}

# pragma mark - Graphics

- (void)render
{
    glClearColor(0.5f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);   
            
    [player renderWithEffect:self.effect];
    
    [self.level.walls makeObjectsPerformSelector:@selector(renderWithEffect:) withObject:self.effect];
    
}

@end
