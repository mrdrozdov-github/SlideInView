//
//  ViewController.m
//  SlideInView
//
//  Created by Andrew Drozdov on 11/14/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import "ViewController.h"

#import "SlidingViewManager.h"
#import "CallbackButton.h"

@interface ViewController ()

- (IBAction)demoButtonClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)demoButtonClicked:(id)sender {
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    notificationView.backgroundColor = [UIColor colorWithRed:5/255.0 green:61/255.0 blue:98/255.0 alpha:1];
    
    SlidingViewManager *svm = [[SlidingViewManager alloc] initWithInnerView:notificationView containerView:self.view];
    
    CallbackButton *cb = [[CallbackButton alloc] init];
    [cb handleControlEvent:UIControlEventTouchUpInside withBlock:^() {
        NSLog(@"button clicked");
        [svm slideViewOut];
    }];
    
    [cb setTitle:@"Button" forState:UIControlStateNormal];
    [cb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cb.frame = CGRectMake(0, 0, 100, 44);
    cb.center = CGPointMake(notificationView.center.x, 3 * notificationView.frame.size.height / 4);
    [notificationView addSubview:cb];
    
    [svm slideViewIn];
}

@end
