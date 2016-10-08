//
//  AppDelegate.m
//  AD_BL
//
//  Created by 3013 on 14-6-5.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "MeunViewController.h"
#import "AsyncSocket.h"

#import "MMDrawerController.h"
#import "MMNavigationController.h"
#import "MMExampleDrawerVisualStateManager.h"

#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation AppDelegate
@synthesize viewController = _viewController;
@synthesize leftMenu=_leftMenu;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"CurConnectIP"];
    _viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ViewControll"];
    
    _leftMenu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"menuControll"];
    
    UIViewController * leftSideDrawerViewController = _leftMenu;
    UIViewController * centerViewController = _viewController;
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
    
    [leftSideDrawerViewController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController leftDrawerViewController:leftSideDrawerViewController rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];

    [self.window setRootViewController:self.drawerController];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"title_bg_ios7"] stretchableImageWithLeftCapWidth:0 topCapHeight:1] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
    [self becomeFirstResponder];
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重新激活
    static BOOL isAppLaunch = YES;
	if (isAppLaunch){
        isAppLaunch = NO;
		return;
	}
    
    TcpClient *tcp =[TcpClient sharedInstance];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    hostArray =[[NSMutableArray alloc] initWithCapacity:0];
    if (![userDef objectForKey:@"CurConnectIP"]) {
        return;
    }else{
        hostArray = [userDef objectForKey:@"CurConnectIP"]; // 根据当前获得的ip地址进行通讯
        if([tcp.currentArray  count]){
            [tcp reconnectTCP:hostArray];
        }
    }
}



@end
