//
//  GameBomb.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-22.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameBomb.h"

@implementation GameBomb

- (id)init
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
        self.x = 0;
        self.y = 0;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view];
    UIView *superview = [view superview];
    CGPoint translation = [gestureRecognizer translationInView:superview];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self.delegate detonateBomb:self atX:self.frame.origin.x andY:self.frame.origin.y];
        return;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.x0 = translation.x;
        self.y0 = translation.y;
    }
    
    float dx = translation.x - self.x0;
    float dy = translation.y - self.y0;
    self.x += dx;
    self.y += dy;
    self.x0 = translation.x;
    self.y0 = translation.y;
    
    if (self.x < 0) self.x = 0;
    if (self.y < 0) self.y = 0;
    if (self.x >= superview.frame.size.width - self.width) self.x = superview.frame.size.width - self.width;
    if (self.y >= superview.frame.size.height - self.height) self.y = superview.frame.size.height - self.height;
    
    int cellx = self.x / 18.6875;
    int celly = self.y / 18.6875;
    self.frame = CGRectMake(cellx * 18.6875, celly * 18.6875, self.width, self.height);
}

@end
