//
//  GameViewController.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCell.h"
#import "GameManager.h"
#import "GameBomb.h"

@interface GameViewController : UIViewController<GameCellDelegate, GameManagerDelegate, GameBombDelegate>

@property (strong, nonatomic) GameManager *manager;
@property (strong, nonatomic) NSMutableArray *grid;

@property (strong, nonatomic) UIView *boardFrame;
@property (strong, nonatomic) UIView *board;
@property (strong, nonatomic) UILabel *AScore;
@property (strong, nonatomic) UILabel *BScore;
@property (strong, nonatomic) UILabel *pointsRemaining;

@property (strong, nonatomic) GameCell *prevCell;
@property (strong, nonatomic) GameBomb *bomb;

@property (nonatomic) CGPoint lastPoint;

@end
