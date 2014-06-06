//
//  GameCell.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-18.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameCellDelegate;

@interface GameCell : UIView

@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) BOOL isSelected;

@property (weak, nonatomic) id<GameCellDelegate> delegate;

- (id)initWithRow:(int)row andColumn:(int)column;

@end

@protocol GameCellDelegate <NSObject>

@required
- (void)cellSelected:(GameCell *)cell atRow:(int)row andColumn:(int)column andDisableToggleTurn:(BOOL)disableToggleTurn;

@end
