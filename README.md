# SlideInView

This is a quick and lightweight example of how to present a notification like view from the bottom of a view. Using SlideInView, the code you'd need would look something like this:

```
UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
notificationView.backgroundColor = [UIColor colorWithRed:5/255.0 green:61/255.0 blue:98/255.0 alpha:1];

SlidingViewManager *svm = [[SlidingViewManager alloc] initWithInnerView:notificationView containerView:self.view];

[svm slideViewIn];
```

The different approach taken here is to animate any view, without making assumption about whether it is a Warning or Failure message like many other libraries do.

Included are simple demos, most of which emulate the style you'd see in ALAlertBanner.

# Demos

Currently all included in the same video.

1. View with Button
1. ALAlertBannerStyleSuccess
1. ALAlertBannerStyleFailure
1. ALAlertBannerStyleWarning
1. ALAlertBannerStyleNotify
1. Stacking Views

<img src="http://f.cl.ly/items/2u0A2X1t0B3000160W21/SlideInViewDemo.mov.gif" width="200px" style="margin-left: auto; margin-right: auto;"/>
