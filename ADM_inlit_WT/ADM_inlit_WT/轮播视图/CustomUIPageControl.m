//
//  CustomUIPageControl.m
//  NewPageControl
//
//  Created by Miaohz on 11-8-31.
//  Copyright 2011 Etop. All rights reserved.
//

#import "CustomUIPageControl.h"

#define DOTWIDTH  5
#define DOTHEIGHT 5

@interface CustomUIPageControl(private)

@end


@implementation CustomUIPageControl

@synthesize delegate    = _delegate;
@synthesize imagePageStateNormal,imagePageStateHightlighted;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void) setImagePageStateNormal:(UIImage *)image
{
	[imagePageStateNormal release];
	imagePageStateNormal = [image retain];
	[self updateDots];
}

- (void) setImagePageStateHightlighted:(UIImage *)image
{
	[imagePageStateHightlighted release];
	imagePageStateHightlighted = [image retain];
	[self updateDots];
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
//	[super endTrackingWithTouch:touch withEvent:event];
//	[self updateDots];
}

- (void) updateDots
{
	if (imagePageStateNormal || imagePageStateHightlighted)
    {
        
		NSArray *subView = self.subviews;
		for (int i = 0; i < [subView count]; i++)
        {
			UIImageView *dot = [subView objectAtIndex:i];
            CGRect rect = dot.frame;
            dot.frame = CGRectMake(rect.origin.x, rect.origin.y, DOTWIDTH, DOTHEIGHT);
			dot.image = (self.currentPage == i ? imagePageStateHightlighted : imagePageStateNormal);
		}
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageControlMoveToIndex:)])
        {
            [self.delegate pageControlMoveToIndex:self.currentPage];
        }
	}
}

- (void) updateDots:(NSInteger)index
{
	if (imagePageStateNormal || imagePageStateHightlighted)
    {
		NSArray *subView = self.subviews;
		for (int i = 0; i < [subView count]; i++)
        {
            UIImageView *dot =[subView objectAtIndex:i];
            CGRect rect = dot.frame;
            dot.frame = CGRectMake(rect.origin.x, rect.origin.y, DOTWIDTH, DOTHEIGHT);
            // add by caijunbo on 2013.09.26
            // to solve app crash on ios7
            if (![dot isKindOfClass:[UIImageView class]]) {
                return;
            }
            
            if (i == index)
            {
                dot.image = imagePageStateHightlighted;
            }
			else
            {
                dot.image = imagePageStateNormal;
            }
		}
	}
}

- (CGFloat)myWidth
{
    if (self.numberOfPages != 0)
    {
        CGFloat width = self.numberOfPages*(DOTWIDTH+5);
        return width;
    }
    
    return 0;
}

- (void)dealloc
{
	[imagePageStateNormal release];
	imagePageStateNormal = nil;
	[imagePageStateHightlighted release];
	imagePageStateHightlighted = nil;
    [super dealloc];
}


@end
