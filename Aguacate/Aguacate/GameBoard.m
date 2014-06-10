//
//  GameBoard.m
//  Aguacate
//
//  Created by Michael Lai on 2014-06-10.
//  Copyright (c) 2014 Michael Lai. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
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

@end
