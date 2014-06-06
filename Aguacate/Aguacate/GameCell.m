//
//  GameCell.m
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameCell.h"
#import "GameManager.h"

@implementation GameCell

- (id)initWithRow:(int)row andColumn:(int)column
{
    self = [super initWithFrame:CGRectMake(1 + 18.6875 * row, 1 + 18.6875 * column, 17.6875, 17.6875)];
    if (self) {
        self.row = row;
        self.column = column;
        self.isSelected = NO;
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    if (location.x < 0 || location.y < 0 || location.x > self.frame.size.width || location.y > self.frame.size.height) return;
    if (self.isSelected == YES) return;

    [self.delegate cellSelected:self atRow:self.row andColumn:self.column andDisableToggleTurn:NO];
}
    
@end
