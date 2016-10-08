//
//  DeviceController.h
//  ADM_inlit_WT
//
//  Created by admin on 14-8-7.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

@protocol hostIPDelegate <NSObject>
-(void)getHostList:(NSMutableArray *)hostLists andGetMac:(NSMutableArray *)MacLists;
@end

#import <UIKit/UIKit.h>
#import "LampsSettingVC.h"
#import "TcpClient.h"

@class LampsSettingVC;


@interface DeviceController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic,strong) TcpClient      *tcpClient;
@property (nonatomic,strong) NSMutableArray *allLightMessage;
@property (nonatomic,strong) NSArray        *dataList;
@property (nonatomic, weak) id<hostIPDelegate> delegate;

@end
