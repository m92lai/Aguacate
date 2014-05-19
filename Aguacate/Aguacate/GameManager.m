
//
//  GameManager.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

//
// @"#" is a point
// @" " is nothing
// @"[1-8]" represents number of adjacent points
//

+ (id)instance
{
    static GameManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.blueTurn = YES;
        self.blueScore = 0;
        self.redScore = 0;
        
        self.points = [NSMutableArray array];
        while ([self.points count] < 51) {
            int r = arc4random() % 16;
            int c = arc4random() % 16;
            
            NSArray *pos = @[@(r), @(c)];
            if (![self.points containsObject:pos]) {
                [self.points addObject:pos];
            }
        }
        
        [self makeGrid];
    }

    return self;
}

- (void)makeGrid
{
    self.grid = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < 16; j++) {
            if ([self isPointAtRow:i andColumn:j]) {
                [row addObject:@"#"];
            } else {
                int adjPoints = 0;
                for (int p = -1; p <= 1; p++) {
                    for (int q = -1; q <= 1; q++) {
                        if (p == 0 && q == 0) continue;
                        if ([self isPointAtRow:(i+p) andColumn:(j+q)]) adjPoints++;
                    }
                }
                
                if (adjPoints != 0) {
                    [row addObject:[[NSNumber numberWithInt:adjPoints] stringValue]];
                } else {
                    [row addObject:@""];
                }
            }
        }
        
        [self.grid addObject:row];
    }
}

- (BOOL)isPointAtRow:(int)row andColumn:(int)column
{
    return [self.points containsObject:@[@(row), @(column)]];
}

- (NSString *)objectAtRow:(int)row andColumn:(int)column
{
    return (NSString *)[[self.grid objectAtIndex:row] objectAtIndex:column];
}

- (void)toggleTurn
{
    self.blueTurn = !self.blueTurn;
}

- (BOOL)isBluesTurn
{
    return self.blueTurn;
}

- (void)updateScore
{
    self.blueTurn ? self.blueScore++ : self.redScore++;
}

@end