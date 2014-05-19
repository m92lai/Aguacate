//
//  GameCell.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCell : UIView

@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) BOOL isSelected;

- (id)initWithRow:(int)row andColumn:(int)column;

@end
