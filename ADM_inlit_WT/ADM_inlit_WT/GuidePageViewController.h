//
//  GuidePageViewController.h
//  Buickhousekeeper
//
//  Created by 李黎明 on 13-7-26.
//  Copyright (c) 2013年 calinks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController<UIScrollViewDelegate>{
    BOOL _animating;
    
    UIScrollView *_pageScroll;
    UIPageControl *pageControlView;
    
}

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

+ (GuidePageViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
