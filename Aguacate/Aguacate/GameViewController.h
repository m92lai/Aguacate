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

@interface GameViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *grid;

@property (strong, nonatomic) UIView *board;
@property (strong, nonatomic) UILabel *blueScore;
@property (strong, nonatomic) UILabel *redScore;

@end
