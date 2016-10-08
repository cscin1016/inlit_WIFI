//
//  AppDelegate.h
//  AD_BL
//
//  Created by 3013 on 14-6-5.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TcpClient.h"

@class ViewController;
@class MMDrawerController;
@class MeunViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *hostArray;
    int flat;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)  MMDrawerController * drawerController;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MeunViewController *leftMenu;

@property (strong, nonatomic) TcpClient *tcpClient;
@property (strong, nonatomic) id musicDelegate;


@end
