//
//  LampsSettingVC.h
//  ADM_Lights
//
//  Created by admin on 14-5-13.
//  Copyright (c) 2014年 admin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DeviceController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CFNetwork/CFNetwork.h>
#import "AsyncSocket.h"
#import "TcpClient.h"
#import "AsyncUdpSocket.h"


@interface LampsSettingVC : UIViewController<AsyncSocketDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,hostIPDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@end
