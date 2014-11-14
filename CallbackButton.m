//
//  CallbackButton.m
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import "CallbackButton.h"

@implementation CallbackButton {
    ActionBlock _callback;
}

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)())callback;
{
    _callback = callback;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    _callback();
}

@end
