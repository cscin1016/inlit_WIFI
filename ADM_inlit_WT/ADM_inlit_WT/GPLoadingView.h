//
//  GPLoadingView.h
//  ADM_inlit_beta
//
//  Created by admin on 14-10-21.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLoadingView : UIButton

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic, assign) CGFloat anglePer;

- (id)initWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
- (void)startRotateAnimation;
@end
