//
//  ViewController.h
//  AD_BL
//
//  Created by 3013 on 14-6-5.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AsyncUdpSocket.h"
#import "Definition.h"
#import "PopupView.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySetting.h"
#import <AVFoundation/AVFoundation.h>

@class PopupView;
@class IFlySpeechRecognizer;

@interface ViewController : UIViewController<AsyncSocketDelegate,UIAlertViewDelegate,IFlySpeechRecognizerDelegate>

@property (nonatomic,strong) UISegmentedControl   * segmentedControl;
@property (nonatomic,strong) PopupView            * popUpView;
@property (nonatomic,strong) IFlySpeechRecognizer * iflySpeechRecognizer;


@end
