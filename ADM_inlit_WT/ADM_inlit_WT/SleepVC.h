//
//  SleepVC.h
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "ViewController.h"

@interface SleepVC : UIViewController<NIDropDownDelegate>
{
    UIButton *offbutton;
    UILabel *oneLabel;
    NIDropDown *dropDown;
}


@property (nonatomic, retain) UITableView *timeTableView;
@property (nonatomic, retain) NSMutableArray *timesArray;

@end
