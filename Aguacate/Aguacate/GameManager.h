//
//  GameManager.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSMutableArray *grid;
@property (nonatomic) BOOL blueTurn;
@property (nonatomic) int blueScore;
@property (nonatomic) int redScore;

+ (id)instance;

- (BOOL)isPointAtRow:(int)row andColumn:(int)column;
- (id)objectAtRow:(int)row andColumn:(int)column;
- (BOOL)isBluesTurn;
- (void)toggleTurn;
- (void)updateScore;

@end
