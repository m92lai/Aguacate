
//
//  GameManager.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameManager.h"
#import "Constants.h"

@implementation GameManager

//
// @"#" is a point
// @" " is nothing
// @"[1-8]" represents number of adjacent points
//

- (id)init
{
    self = [super init];
    if (self) {
        self.ATurn = YES;
        self.AScore = 0;
        self.BScore = 0;
        self.pointsRemaining = POINTS_TOTAL;
        
        self.points = [NSMutableArray array];
        while ([self.points count] < POINTS_TOTAL) {
            int r = arc4random() % GRID_SIZE;
            int c = arc4random() % GRID_SIZE;
            
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
    for (int i = 0; i < GRID_SIZE; i++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < GRID_SIZE; j++) {
            if ([self isPointAtRow:i andColumn:j]) {
                [row addObject:@"#"];
            } else {
                int adjPoints = 0;
                for (int x = -1; x <= 1; x++) {
                    for (int y = -1; y <= 1; y++) {
                        if (x == 0 && y == 0) continue;
                        if ([self isPointAtRow:(i+x) andColumn:(j+y)]) adjPoints++;
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
    self.ATurn = !self.ATurn;
    [self.delegate updateView];
}

- (BOOL)isBluesTurn
{
    return self.ATurn;
}

- (void)updateScore
{
    self.ATurn ? self.AScore++ : self.BScore++;
    self.pointsRemaining--;
    
    if (self.AScore == POINTS_TO_WIN) {
        self.gameState = GameStateAWins;
    } else if (self.BScore == POINTS_TO_WIN) {
        self.gameState = GameStateBWins;
    }
    
    [self.delegate updateView];
}

@end
