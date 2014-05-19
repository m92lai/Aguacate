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
        self.grid = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.blueScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 150, 50)];
    self.blueScore.textAlignment = NSTextAlignmentCenter;
    self.blueScore.text = @"0";
    [self.view addSubview:self.blueScore];
    
    self.redScore = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 150, 50)];
    self.redScore.textAlignment = NSTextAlignmentCenter;
    self.redScore.text = @"0";
    [self.view addSubview:self.redScore];
    
    self.board = [[UIView alloc] initWithFrame:CGRectMake(10, 144, 300, 300)];
    self.board.backgroundColor = [UIColor blackColor];
    
    for (int i = 0; i < 16; i++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < 16; j++) {
            GameCell *cell = [[GameCell alloc] initWithRow:i andColumn:j];
            
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
    GameManager *mgr = [GameManager instance];
    self.blueScore.text = [NSString stringWithFormat:@"%d", [mgr blueScore]];
    self.redScore.text = [NSString stringWithFormat:@"%d", [mgr redScore]];
}
@end
