//
//  GameBomb.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-22.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameBomb.h"

@implementation GameBomb

- (id)initWithBoard:(UIView*)board
{

    self = [super init];
    if (self) {
        self.width = 18.6875 * 5 + 1;
        self.height = 18.6875 * 5 + 1;
        self.frame = CGRectMake(0, 0, self.width, self.height);
        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.board = board;
        self.x = 0;
        self.y = 0;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.board];
    self.x0 = location.x;
    self.y0 = location.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.board];
    float dx = location.x - self.x0;
    float dy = location.y - self.y0;
    self.x += dx;
    self.y += dy;
    self.x0 = location.x;
    self.y0 = location.y;

    if (self.x < 0) self.x = 0;
    if (self.y < 0) self.y = 0;
    if (self.x >= self.board.frame.size.width - self.width) self.x = self.board.frame.size.width - self.width;
    if (self.y >= self.board.frame.size.height - self.height) self.y = self.board.frame.size.height - self.height;

    [self snapBomb];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.x = self.frame.origin.x;
//    self.y = self.frame.origin.y;
    [self.delegate detonateBomb:self atX:self.frame.origin.x andY:self.frame.origin.y];
}

- (void)snapBomb
{
    int cellx = self.x / 18.6875;
    int celly = self.y / 18.6875;
    self.frame = CGRectMake(cellx * 18.6875, celly * 18.6875, self.width, self.height);
}



@end
