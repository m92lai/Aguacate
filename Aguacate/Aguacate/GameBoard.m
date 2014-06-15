//
//  GameBoard.m
//  Aguacate
//
//  Created by Michael Lai on 2014-06-10.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameBoard.h"
#import "Constants.h"

@implementation GameBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUND_COLOR;
        
        // Attach gesture recognizers
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pinch];
        [self addGestureRecognizer:pan];
    }
    
    return self;
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

    UIView *view = gestureRecognizer.view;
    CGAffineTransform t0 = view.transform;
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, gestureRecognizer.scale, gestureRecognizer.scale);
        [gestureRecognizer setScale:1];
    }
    
    NSLog(@"%f", BOARD_SIZE);
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    if (width < BOARD_SIZE ||
        height < BOARD_SIZE ||
        width > 300 * MAX_SCALE_BOARD ||
        height > 300 * MAX_SCALE_BOARD)
        view.transform = t0;
    
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    float w = view.superview.frame.size.width;
    float h = view.superview.frame.size.height;
    
    CGRect frame = view.frame;
    if (x > 0) frame.origin.x = 0;
    if (y > 0) frame.origin.y = 0;
    if (x + width < w) frame.origin.x = w - width;
    if (y - height < h) frame.origin.y = h - height;
    [view setFrame:frame];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    UIView *view = gestureRecognizer.view;
    CGPoint c0 = view.center;
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:view.superview];
        
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    if (x > 0 ||
        y > 0 ||
        x < view.superview.frame.size.width - view.frame.size.width ||
        y < view.superview.frame.size.height -  view.frame.size.height)
        [view setCenter:c0];
}

@end
