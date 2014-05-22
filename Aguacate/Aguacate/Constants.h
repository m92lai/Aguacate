//
//  Constants.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-19.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLAYER_A_COLOR [UIColor colorWithRed:127.0f/255.0f green:187.0f/255.0f blue:250.0f/255.0f alpha:1]
#define PLAYER_B_COLOR [UIColor colorWithRed:242.0f/255.0f green:167.0f/255.0f blue:188.0f/255.0f alpha:1]
#define BLANK_COLOR [UIColor colorWithRed:201.0f/255.0f green:242.0f/255.0f blue:160.0f/255.0f alpha:1]
#define HIGHLIGHT_COLOR [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1]

@interface Constants : NSObject

extern int const GRID_SIZE;
extern int const POINTS_TOTAL;
extern int const POINTS_TO_WIN;


@end
