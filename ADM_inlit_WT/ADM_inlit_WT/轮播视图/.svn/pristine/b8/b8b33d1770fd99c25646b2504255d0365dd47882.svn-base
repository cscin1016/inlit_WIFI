//
//  CustomUIPageControl.h
//  NewPageControl
//
//  Created by Miaohz on 11-8-31.
//  Copyright 2011 Etop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomUIPageControlDelegate <NSObject>

@optional
- (void)pageControlMoveToIndex:(int)index;

@end

@interface CustomUIPageControl : UIPageControl
{
    id <CustomUIPageControlDelegate> _delegate;
	UIImage *imagePageStateNormal;
	UIImage *imagePageStateHightlighted;
}

@property (assign) id <CustomUIPageControlDelegate> delegate;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHightlighted;

- (void) updateDots;
- (void) updateDots:(int)index;
- (id) initWithFrame:(CGRect)frame;
- (CGFloat)myWidth;

@end
