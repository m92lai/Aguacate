//
//  GameManager.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameManagerDelegate;

enum GameState {
    GameStatePlaying,
    GameStateAWins,
    GameStateBWins
};

@interface GameManager : NSObject

@property (weak, nonatomic) id<GameManagerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSMutableArray *grid;
@property (nonatomic) BOOL ATurn;
@property (nonatomic) int AScore;
@property (nonatomic) int BScore;
@property (nonatomic) int pointsRemaining;

@property enum GameState gameState;

- (BOOL)isPointAtRow:(int)row andColumn:(int)column;
- (id)objectAtRow:(int)row andColumn:(int)column;
- (void)toggleTurn;
- (void)updateScore;

@end

@protocol GameManagerDelegate <NSObject>

@required
- (void)updateView;

@end
