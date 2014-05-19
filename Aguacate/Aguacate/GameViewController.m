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
    
//    self.blueMarker = [[UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    self.blueScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 140, 50)];
    self.blueScore.textAlignment = NSTextAlignmentCenter;
    self.blueScore.text = @"0";
    self.blueScore.textColor = [UIColor whiteColor];
    self.blueScore.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.blueScore];
    
    self.redScore = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 140, 50)];
    self.redScore.textAlignment = NSTextAlignmentCenter;
    self.redScore.text = @"0";
    self.redScore.textColor = [UIColor whiteColor];
    self.redScore.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redScore];
    
    self.pointsRemaining = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 300, 20)];
    self.pointsRemaining.text = [NSString stringWithFormat:@"%d points remaining", 51];
    self.pointsRemaining.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pointsRemaining];
    
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
    self.pointsRemaining.text = [NSString stringWithFormat:@"%d points remaining", [self.manager pointsRemaining]];
}
@end
