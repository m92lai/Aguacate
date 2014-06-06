//
//  GameViewController.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameViewController.h"
#import "Constants.h"

@implementation GameViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.manager = [[GameManager alloc] init];
        self.grid = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.manager.delegate = self;

    self.AScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 140, 50)];
    self.AScore.textAlignment = NSTextAlignmentCenter;
    self.AScore.textColor = [UIColor whiteColor];
    self.AScore.backgroundColor = PLAYER_A_COLOR;
    self.AScore.layer.borderColor = HIGHLIGHT_COLOR.CGColor;
    [self.view addSubview:self.AScore];
    
    UIControl *bomb = [[UIControl alloc] initWithFrame:CGRectMake(0, 30, 20, 20)];
    bomb.backgroundColor = [UIColor blackColor];
    [bomb addTarget:self action:@selector(bombClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bomb];
    
    self.BScore = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 140, 50)];
    self.BScore.textAlignment = NSTextAlignmentCenter;
    self.BScore.textColor = [UIColor whiteColor];
    self.BScore.backgroundColor = PLAYER_B_COLOR;
    self.BScore.layer.borderColor = HIGHLIGHT_COLOR.CGColor;
    [self.view addSubview:self.BScore];
    
    self.pointsRemaining = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 300, 20)];
    self.pointsRemaining.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pointsRemaining];
    
    self.board = [[UIView alloc] initWithFrame:CGRectMake(10, 144, 300, 300)];
    self.board.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
    
    for (int i = 0; i < GRID_SIZE; i++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < GRID_SIZE; j++) {
            GameCell *cell = [[GameCell alloc] initWithRow:i andColumn:j];
            cell.delegate = self;
            
            [row addObject:cell];
            [self.board addSubview:cell];
        }
        
        [self.grid addObject:row];
    }
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.board addGestureRecognizer:pinch];
    
    [self.view addSubview:self.board];
    [self updateView];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch
{
    CGAffineTransform transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    self.board.transform = transform;
}

- (void)updateScores
{
    self.AScore.text = [NSString stringWithFormat:@"%d", [self.manager AScore]];
    self.BScore.text = [NSString stringWithFormat:@"%d", [self.manager BScore]];
}

- (void)cellSelected:(GameCell *)cell atRow:(int)row andColumn:(int)column andDisableToggleTurn:(BOOL)disableToggleTurn
{
    cell.isSelected = YES;
    NSString *obj = [self.manager objectAtRow:row andColumn:column];

    if ([@"#" isEqualToString:obj]) {
        cell.backgroundColor = [self.manager ATurn] ? PLAYER_A_COLOR : PLAYER_B_COLOR;

        [self.manager updateScore];
    } else {
        cell.backgroundColor = BLANK_COLOR;
        if (!disableToggleTurn) [self.manager toggleTurn];
        if ([@"" isEqualToString:obj]) {
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    if (i == 0 && j == 0) continue;
                    int dx = row + i;
                    int dy = column + j;
                    if (dx < 0 || dx >= GRID_SIZE || dy < 0 || dy >= GRID_SIZE) continue;

                    GameCell *adjCell = [[self.grid objectAtIndex:dx] objectAtIndex:dy];
                    if (adjCell.isSelected != YES) {
                        adjCell.isSelected = YES;
                        [self cellSelected:adjCell atRow:dx andColumn:dy andDisableToggleTurn: YES];
                    }
                }
            }

        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17.6875, 17.6875)];
            label.text = obj;
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;

            [cell addSubview:label];
        }
    }
    
    cell.layer.borderColor = HIGHLIGHT_COLOR.CGColor;
    cell.layer.borderWidth = 1;
    if (self.prevCell) {
        self.prevCell.layer.borderWidth = 0;
    }
    self.prevCell = cell;
}

- (void)updateView
{
    if ([self.manager ATurn]) {
        self.AScore.layer.borderWidth = 2;
        self.BScore.layer.borderWidth = 0;
    } else {
        self.BScore.layer.borderWidth = 2;
        self.AScore.layer.borderWidth = 0;
    }
    
    self.AScore.text = [NSString stringWithFormat:@"%d", [self.manager AScore]];
    self.BScore.text = [NSString stringWithFormat:@"%d", [self.manager BScore]];
    self.pointsRemaining.text = [NSString stringWithFormat:@"%d points remaining", [self.manager pointsRemaining]];
    
    if ([self.manager gameState] == GameStateAWins) {
        self.pointsRemaining.text = @"Blue Wins!";
    } else if ([self.manager gameState] == GameStateBWins) {
        self.pointsRemaining.text = @"Red Wins!";
    }
}

- (void)bombClicked
{
    self.bomb = [[GameBomb alloc] initWithBoard:self.board];
    self.bomb.delegate = self;
    [self.board addSubview:self.bomb];
}

- (void)detonateBomb:(GameBomb*)bomb atX:(float)x andY:(float)y
{
    [bomb removeFromSuperview];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            int row = i + x / 18.6875;
            int column = j + y / 18.6875;
            GameCell *cell = [[self.grid objectAtIndex:row] objectAtIndex:column];
            [self cellSelected:cell atRow:row andColumn:column andDisableToggleTurn:YES];
        }
    }
    
    [self.manager toggleTurn];
}
@end
