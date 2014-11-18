//
//  ViewController.m
//  SlideInView
//
//  Created by Andrew Drozdov on 11/14/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import "ViewController.h"
#import "SlidingViewManager.h"

// source: http://stackoverflow.com/questions/7792622/manual-retain-with-arc
#define AntiARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing
#define AntiARCRelease(...) void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil

/* start referenced from ALAlertBanner */
static CGFloat const kMargin = 10.f;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #define AL_SINGLELINE_TEXT_HEIGHT(text, font) [text length] > 0 ? [text sizeWithAttributes:nil].height : 0.f;
    #define AL_MULTILINE_TEXT_HEIGHT(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize \
                                                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) \
                                                                                                    attributes:nil \
                                                                                    context:NULL].size.height : 0.f;
#else
    #define AL_SINGLELINE_TEXT_HEIGHT(text, font) [text length] > 0 ? [text sizeWithFont:font].height : 0.f;
    #define AL_MULTILINE_TEXT_HEIGHT(text, font, maxSize, mode) [text length] > 0 ? [text sizeWithFont:font \
                                                                                     constrainedToSize:maxSize \
                                                                                         lineBreakMode:mode].height : 0.f;
#endif

typedef enum {
    ALAlertBannerStyleSuccess = 0,
    ALAlertBannerStyleFailure,
    ALAlertBannerStyleNotify,
    ALAlertBannerStyleWarning,
} ALAlertBannerStyle;

/* end referenced from ALAlertBanner */

typedef void (^ActionBlock)();

@interface ClickHandler : NSObject

- (id)initWithCallback:(ActionBlock)_callback;
- (void)buttonClicked:(id)sender;

@end

@implementation ClickHandler {
    ActionBlock callback;
}

- (id)initWithCallback:(ActionBlock)_callback {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    callback = _callback;
    
    return self;
}

- (void)buttonClicked:(id)sender {
    callback();
}

@end

// Main Class

@interface ViewController ()

- (IBAction)demoButtonClicked:(id)sender;
- (IBAction)warningButtonClicked:(id)sender;
- (IBAction)successButtonClicked:(id)sender;
- (IBAction)failureButtonClicked:(id)sender;
- (IBAction)notifyButtonClicked:(id)sender;

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
    
    ClickHandler *clickHandler = [[ClickHandler alloc] initWithCallback:^() {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Button clicked" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [svm slideViewOut];
        AntiARCRelease(clickHandler);
    }];
    AntiARCRetain(clickHandler);
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:clickHandler action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.center = CGPointMake(notificationView.center.x, 3 * notificationView.frame.size.height / 4);
    [notificationView addSubview:button];
    
    [svm slideViewIn];
}

# pragma mark - ALAlertBanner Copycat Demo

- (UIColor*)colorForALAlertBannerStyle:(ALAlertBannerStyle)style {
    switch (style) {
        case ALAlertBannerStyleSuccess:
            return [UIColor colorWithRed:(77/255.0) green:(175/255.0) blue:(67/255.0) alpha:1.f];
        case ALAlertBannerStyleFailure:
            return [UIColor colorWithRed:(173/255.0) green:(48/255.0) blue:(48/255.0) alpha:1.f];
        case ALAlertBannerStyleNotify:
            return [UIColor colorWithRed:(48/255.0) green:(110/255.0) blue:(173/255.0) alpha:1.f];
        case ALAlertBannerStyleWarning:
            return [UIColor colorWithRed:(211/255.0) green:(209/255.0) blue:(100/255.0) alpha:1.f];
        default:
            return nil;
    }
}

- (UIImage*)imageForALAlertBannerStyle:(ALAlertBannerStyle)style {
    switch (style) {
        case ALAlertBannerStyleSuccess:
            return [UIImage imageNamed:@"bannerSuccess.png"];
        case ALAlertBannerStyleFailure:
            return [UIImage imageNamed:@"bannerFailure.png"];
        case ALAlertBannerStyleNotify:
            return [UIImage imageNamed:@"bannerNotify.png"];
        case ALAlertBannerStyleWarning:
            return [UIImage imageNamed:@"bannerAlert.png"];
        default:
            return nil;
    }
}

- (void)demoForALAlertBannerStyle:(ALAlertBannerStyle)style {
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    notificationView.backgroundColor = [self colorForALAlertBannerStyle:style];
    
    UIImageView *styleImageView = [[UIImageView alloc] init];
    styleImageView.image = [self imageForALAlertBannerStyle:style];
    styleImageView.frame = CGRectMake(kMargin, (notificationView.frame.size.height/2.f) - (styleImageView.image.size.height/2.f), styleImageView.image.size.width, styleImageView.image.size.height);
    [notificationView addSubview:styleImageView];
    
    CGSize maxLabelSize = CGSizeMake(notificationView.bounds.size.width - (kMargin*3.f) - styleImageView.image.size.width, CGFLOAT_MAX);
    
    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"This is a title";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.f];
    _titleLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.9f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGFloat titleLabelHeight = AL_SINGLELINE_TEXT_HEIGHT(_titleLabel.text, _titleLabel.font);
    _titleLabel.frame = CGRectMake(styleImageView.frame.origin.x + styleImageView.frame.size.width + kMargin, kMargin, maxLabelSize.width, titleLabelHeight);
    [notificationView addSubview:_titleLabel];
    
    UILabel *_subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = @"This is a subtitle\nThis is a subtitle\nThis is a subtitle\nThis is a subtitle";
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.f];
    _subtitleLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.9f];
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat subtitleLabelHeight = AL_MULTILINE_TEXT_HEIGHT(_subtitleLabel.text, _subtitleLabel.font, maxLabelSize, _subtitleLabel.lineBreakMode);
    _subtitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + (_titleLabel.text == nil ? 0.f : kMargin/2.f), maxLabelSize.width, subtitleLabelHeight);
    [notificationView addSubview:_subtitleLabel];
    
    SlidingViewManager *svm = [[SlidingViewManager alloc] initWithInnerView:notificationView containerView:self.view];
    
    [svm slideViewIn];
}

- (IBAction)warningButtonClicked:(id)sender {
    [self demoForALAlertBannerStyle:ALAlertBannerStyleWarning];
}

- (IBAction)successButtonClicked:(id)sender {
    [self demoForALAlertBannerStyle:ALAlertBannerStyleSuccess];
}

- (IBAction)failureButtonClicked:(id)sender {
    [self demoForALAlertBannerStyle:ALAlertBannerStyleFailure];
}

- (IBAction)notifyButtonClicked:(id)sender {
    [self demoForALAlertBannerStyle:ALAlertBannerStyleNotify];
}

@end
