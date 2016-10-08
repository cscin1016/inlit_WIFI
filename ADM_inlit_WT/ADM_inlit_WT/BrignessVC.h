//
//  BrignessVC.h
//  ADM_Lights
//
//  Created by admin on 14-3-7.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "draw_graphic.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"



//@protocol ColorVCDelegate <NSObject>
//
//-(void)colorDidChange1:(UIColor*)color;
//
//@end

@interface BrignessVC : UIViewController
{


//    id <ColorVCDelegate> delegate;
    
    UILabel *valueLabel;
    
    
    int iReg;
    int igreen;
    int iBlue;
    int iWhite;
    BOOL isOff;
    NSTimer *timer;
    
    int newVal;
    int touch_flag;;
    
    draw_graphic *drawView;
    
    NSInteger lastReg;
    NSInteger lastGreen;
    NSInteger lastBlue;
    NSInteger lastWhite;

    
    
}
//@property (assign) id <ColorVCDelegate> delegate;
@end
