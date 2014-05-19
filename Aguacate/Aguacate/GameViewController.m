//
//  GameViewController.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameViewController.h"

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
    
    self.blueScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 150, 50)];
    self.blueScore.textAlignment = NSTextAlignmentCenter;
    self.blueScore.text = @"0";
    [self.view addSubview:self.blueScore];
    
    self.redScore = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 150, 50)];
    self.redScore.textAlignment = NSTextAlignmentCenter;
    self.redScore.text = @"0";
    [self.view addSubview:self.redScore];
    
    self.board = [[UIView alloc] initWithFrame:CGRectMake(10, 144, 300, 300)];
    self.board.backgroundColor = [UIColor lightGrayColor];
    
    for (int i = 0; i < 16; i++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < 16; j++) {
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
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch
{
    CGAffineTransform transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    self.board.transform = transform;
}

- (void)updateScores
{
    self.blueScore.text = [NSString stringWithFormat:@"%d", [self.manager blueScore]];
    self.redScore.text = [NSString stringWithFormat:@"%d", [self.manager redScore]];
}

- (void)cellSelected:(GameCell *)cell atRow:(int)row andColumn:(int)column
{
    cell.isSelected = YES;
    NSString *obj = [self.manager objectAtRow:row andColumn:column];

    if ([@"#" isEqualToString:obj]) {
        cell.backgroundColor = [self.manager isBluesTurn] ? [UIColor blueColor] : [UIColor redColor];
        [self.manager updateScore];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
        [self.manager toggleTurn];
        if ([@"" isEqualToString:obj]) {
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    if (i == 0 && j == 0) continue;
                    int dx = row + i;
                    int dy = column + j;
                    if (dx < 0 || dx >= 16 || dy < 0 || dy >= 16) continue;

                    GameCell *adjCell = [[self.grid objectAtIndex:dx] objectAtIndex:dy];
                    if (adjCell.isSelected != YES) {
                        adjCell.isSelected = YES;
                        [self cellSelected:adjCell atRow:dx andColumn:dy];
                    }
//                    NSString *adjObj = [self.manager objectAtRow:(row+i) andColumn:(column+j)];
                    
                }
            }

        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17.6875, 17.6875)];
            label.text = obj;
            label.textAlignment = NSTextAlignmentCenter;

            [cell addSubview:label];
        }
    }
}

- (void)updateView
{
    self.blueScore.text = [NSString stringWithFormat:@"%d", [self.manager blueScore]];
    self.redScore.text = [NSString stringWithFormat:@"%d", [self.manager redScore]];
}
@end
