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
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isSelected == YES) return;
    [self.delegate cellSelected:self atRow:self.row andColumn:self.column];
}
    
@end
