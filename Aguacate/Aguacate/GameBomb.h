//
//  GameBomb.h
//  Aguacate
//
//  Created by Michael Lai on 2014-05-22.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameBombDelegate;

@interface GameBomb : UIView

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float x0;
@property (nonatomic) float y0;
@property (nonatomic) float width;
@property (nonatomic) float height;

@property (weak, nonatomic) id<GameBombDelegate> delegate;

@end

@protocol GameBombDelegate <NSObject>

@required
- (void)detonateBomb:(GameBomb*)bomb atX:(float)x andY:(float)y;

@end

