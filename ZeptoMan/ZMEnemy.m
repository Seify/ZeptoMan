//
//  ZMEnemy.m
//  ZeptoMan
//
//  Created by Roman Smirnov on 17.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZMEnemy.h"

@implementation ZMEnemy

- (void)think
{
    // поворачиваем в случайную сторону если уперлись в стену или случайно
    if ((self.position.x == self.previousPosition.x && self.position.y == self.previousPosition.y) || ((rand()%100 < 4))){
        turnDirection direction = rand()%5;
        self.nextTurn = direction;
    }
}

@end
