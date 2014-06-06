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
    
    self.boardFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 144, 300, 300)];
    self.boardFrame.clipsToBounds = YES;
    self.board = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.board addGestureRecognizer:pinch];
    [self.board addGestureRecognizer:pan];
    
    [self.view addSubview:self.boardFrame];
    [self.boardFrame addSubview:self.board];
    [self updateView];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    UIView *view = [gestureRecognizer view];
    CGAffineTransform t0 = view.transform;
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
    
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    
    if (width < 300 || height < 300 || width > 1200 || height > 1200)
        view.transform = t0;
    
    CGRect frame = view.frame;
    if (x > 0) {
        frame.origin.x = 0;
    }
    if (y > 0) {
        frame.origin.y = 0;
    }
    if (x + view.frame.size.width < view.superview.frame.size.width) {
        frame.origin.x = view.superview.frame.size.width - view.frame.size.width;
    }
    if (y + view.frame.size.height < view.superview.frame.size.height)
        frame.origin.y = view.superview.frame.size.height - view.frame.size.height;
    
    [view setFrame:frame];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    UIView *view = [gestureRecognizer view];
    CGPoint c0 = [view center];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[view superview]];
        
        [view setCenter:CGPointMake([view center].x + translation.x, [view center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[view superview]];
    }

    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    if (x > 0 || y > 0 || x + view.frame.size.width < view.superview.frame.size.width ||
        y + view.frame.size.height < view.superview.frame.size.height)
        [view setCenter:c0];
    
    
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
