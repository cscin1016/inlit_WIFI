//
//  tb_2_graphic.m
//  xiangmu_1
//
//  Created by liu xiaotao008 on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "draw_graphic.h"
#define  radius 136

@implementation draw_graphic
@synthesize angle,red,green,blue;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    angle=0;
    return self;
}
//当调用setNeedsDisplay时由系统调用

-(void)drawRect:(CGRect)rect
{
    
    //CG绘制三角形
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, radius+radius, radius);
    CGContextAddArc(ctx, radius, radius, radius,  0,3.1415926*angle/180, 0);
    CGContextAddLineToPoint(ctx,radius, radius);
    //    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
    [[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1] setFill];
//    UIColor
    [[UIColor clearColor] setStroke];//设置边框颜色
    CGContextDrawPath(ctx, kCGPathFillStroke);
  
}


@end
