//
//  CallbackButton.h
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface CallbackButton : UIButton

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)())callback;

@end
