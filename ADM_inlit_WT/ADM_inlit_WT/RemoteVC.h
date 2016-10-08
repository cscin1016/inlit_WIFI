//
//  RemoteVC.h
//  ADM_Lights
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 admin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "addSceneVC.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface RemoteVC : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,scenceArrayDelegte>

@property (retain, nonatomic)  UIScrollView *picScroller;


@end
