//
//  SlidingViewManager.h
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SlidingViewManager : NSObject

- (id)initWithInnerView:(UIView*)_innerView containerView:(UIView *)_containerView;
- (void)slideViewIn;
- (void)slideViewOut;

@end
