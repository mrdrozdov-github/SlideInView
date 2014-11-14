//
//  SlidingViewManager.m
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import "SlidingViewManager.h"

static NSTimeInterval kNotificationViewDefaultHideTimeInterval = 4.5;

@implementation SlidingViewManager {
    BOOL visible;
    UIView *innerView;
    UIView *containerView;
}

- (id)initWithInnerView:(UIView*)_innerView containerView:(UIView *)_containerView {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    innerView = _innerView;
    containerView = _containerView;
    
    return self;
}

- (void)slideViewIn {
    visible = YES;
    
    CGFloat innerWidth = CGRectGetWidth(innerView.frame);
    CGFloat innerHeight = CGRectGetHeight(innerView.frame);
    CGFloat innerX = CGRectGetMinX(innerView.frame);
    CGFloat innerOriginalY = CGRectGetHeight(containerView.frame);
    CGFloat innerTargetY = CGRectGetHeight(containerView.frame) - innerHeight;
    
    CGRect original = CGRectMake(innerX, innerOriginalY, innerWidth, innerHeight);
    CGRect target = CGRectMake(innerX, innerTargetY, innerWidth, innerHeight);
    
    // Add to View
    [innerView setFrame:original];
    [containerView addSubview:innerView];
    
    // Animate In
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [innerView setFrame:target];
    } completion:^(BOOL finished) {
        if (finished) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            [innerView addGestureRecognizer:tapGestureRecognizer];
        }
    }];
    
    // Animate Out
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kNotificationViewDefaultHideTimeInterval* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (visible) {
            [self slideViewOut];
        }
    });
}

- (void)slideViewOut {
    visible = NO;
    
    CGFloat innerWidth = CGRectGetWidth(innerView.frame);
    CGFloat innerHeight = CGRectGetHeight(innerView.frame);
    CGFloat innerX = CGRectGetMinX(innerView.frame);
    CGFloat innerOriginalY = CGRectGetHeight(containerView.frame);
    
    CGRect original = CGRectMake(innerX, innerOriginalY, innerWidth, innerHeight);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [innerView setFrame:original];
    } completion:^(BOOL finished) {
        [innerView removeFromSuperview];
    }];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [recognizer.view removeGestureRecognizer:recognizer];
    [self slideViewOut];
}

@end
