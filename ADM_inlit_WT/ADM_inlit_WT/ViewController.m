//
//  ViewController.m
//  AD_BL
//
//  Created by 3013 on 14-6-5.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "ViewController.h"
#import "LampsSettingVC.h"
#import "MBProgressHUD.h"

#import "GuidePageViewController.h"

#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import "RecognizerFactory.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface ViewController (){
    UIButton      *onOffButon;//开关按钮
    UILabel       *numberStr;//亮度标签
    UILabel       *lightIp;//IP地址
    MBProgressHUD *hud;
    UIButton      *yuyinBt;//语音按钮
    BOOL          isCanceled;
    NSString      *result;
    
    
}
@property (nonatomic,strong) LampsSettingVC  * lampVC;//操作灯界面;

@end

@implementation ViewController
@synthesize iflySpeechRecognizer;
@synthesize segmentedControl;
@synthesize lampVC =_lampVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //摇一摇动作设置
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    self.title = NSLocalizedStringFromTable(@"TITLE_Home", @"Locale", nil);//设置标题
    [self setupLeftMenuButton];//设置左导航栏按钮
    
    //设置右导航栏
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Right_set_BUTTON", @"Locale", nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(SettingAction)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    //设置背景图
    UIImageView *BGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    BGImageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:BGImageView];
    
    //开关按钮
    onOffButon =[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btView =[UIImage imageNamed:@"power_on"];
    onOffButon.frame =CGRectMake(SCREENWIDTH/2-btView.size.width/2, 32, btView.size.width, btView.size.height);
    [onOffButon setImage:[UIImage imageNamed:@"power_on"] forState:UIControlStateNormal];
    [onOffButon setImage:[UIImage imageNamed:@"power_off"] forState:UIControlStateSelected];
    onOffButon.selected=NO;
    [onOffButon addTarget:self action:@selector(turnOff:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onOffButon];
    
    //最近连接的灯泡名称信息
    UIImage *lightImage = [UIImage imageNamed:@"light_pl"];
    UIImageView *lgImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_pl"]];
    lgImageView.frame =CGRectMake((SCREENWIDTH-lightImage.size.width)/2,onOffButon.frame.origin.y+onOffButon.frame.size.height+10 , lightImage.size.width, lightImage.size.height);
    [self.view addSubview:lgImageView];
    
    //亮度值label
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    numberStr= [[UILabel alloc] initWithFrame:CGRectMake(20, 10, lgImageView.frame.size.width-40, 40)];
    if(![userDefaults objectForKey:@"brigness"])
        numberStr.text=@"100";
    else
        numberStr.text=[userDefaults objectForKey:@"brigness"];
    numberStr.font =[UIFont systemFontOfSize:26];
    numberStr.backgroundColor=[UIColor clearColor];
    numberStr.textColor =[UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0];
    numberStr.textAlignment = NSTextAlignmentCenter;
    [lgImageView addSubview:numberStr];
    
    //％ percent symbol
    UILabel *percentSymbol= [[UILabel alloc] initWithFrame:CGRectMake(35, 25, lgImageView.frame.size.width-20, 40)];
    percentSymbol.text=@"%";
    percentSymbol.textColor =[UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0];
    percentSymbol.backgroundColor= [UIColor clearColor];
    percentSymbol.font =[UIFont fontWithName:@"HelveticaNeue" size:10];
    percentSymbol.textAlignment = NSTextAlignmentCenter;
    [lgImageView addSubview:percentSymbol];
    
    //灯泡名称信息label
    UILabel *lightName= [[UILabel alloc] initWithFrame:CGRectMake(20, 35, lgImageView.frame.size.width-40, 40)];
    lightName.text=@"Untitled";
    lightName.font =[UIFont systemFontOfSize:10];
    lightName.backgroundColor=[UIColor clearColor];
    lightName.textColor =[UIColor whiteColor];
    lightName.textAlignment = NSTextAlignmentCenter;
    [lgImageView addSubview:lightName];
    
    //设备ip地址
    NSLog(@"ipipipipi ===%@",[userDefaults objectForKey:@"CurConnectIP"]);
    lightIp= [[UILabel alloc] initWithFrame:CGRectMake(10, 50, lgImageView.frame.size.width-20, 40)];
    if ([userDefaults objectForKey:@"CurConnectIP"]==nil) {
        lightIp.text = @"无连接设备";
    }else{
        if ([userDefaults integerForKey:@"allOrGroup"]==1) {
            lightIp.text= [NSString stringWithFormat:@"%lu lamps",(unsigned long)[[userDefaults objectForKey:@"CurConnectIP"] count]];
        }else{
            lightIp.text=[[userDefaults objectForKey:@"CurConnectIP"] objectAtIndex:0];
        }
    }
    lightIp.textColor =[UIColor whiteColor];
    lightIp.backgroundColor= [UIColor clearColor];
    lightIp.font =[UIFont fontWithName:@"HelveticaNeue" size:8];
    lightIp.textAlignment = NSTextAlignmentCenter;
    [lgImageView addSubview:lightIp];
    
    //语音按钮
    yuyinBt =[UIButton buttonWithType:UIButtonTypeCustom];
    yuyinBt.layer.cornerRadius =5;
    if (isIPhone5) {
        yuyinBt.frame =CGRectMake(SCREENWIDTH/2-100,lgImageView.frame.origin.y+lgImageView.frame.size.height+50, 200, 40);
    }else{
        yuyinBt.frame =CGRectMake(SCREENWIDTH/2-100,lgImageView.frame.origin.y+lgImageView.frame.size.height+10, 200, 40);
    }
    [yuyinBt setTitle:NSLocalizedStringFromTable(@"Voice_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    [yuyinBt addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];
    [yuyinBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yuyinBt.titleLabel.font = [UIFont fontWithName:@"helvetica" size:19];
    yuyinBt.backgroundColor =[UIColor grayColor];
    [self.view addSubview:yuyinBt];
    
    //气泡显示
    self.popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, lgImageView.frame.origin.y-35, 0, 0)];
    _popUpView.ParentView = self.view;
    
    //设置
    segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
    [ segmentedControl insertSegmentWithTitle: NSLocalizedStringFromTable(@"Enlish_BUTTON", @"Locale", nil) atIndex: 0 animated: NO ];
    [ segmentedControl insertSegmentWithTitle: NSLocalizedStringFromTable(@"Chinese_BUTTON", @"Locale", nil) atIndex: 1 animated: NO ];
    segmentedControl.tag=10000;
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame=CGRectMake(0,SCREENHEIGHT-64-40, SCREENWIDTH, 40);
    segmentedControl.backgroundColor =[UIColor blackColor];
    [segmentedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    
    _lampVC =[[LampsSettingVC alloc] init];
    
    //创建语音配置
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    iflySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    [iflySpeechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        [GuidePageViewController show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Isfirst"];
    }
    [self.navigationController pushViewController:_lampVC animated:NO];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self becomeFirstResponder];
    NSLog(@"主页－－－》");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"brigness"])
    {
        numberStr.text=@"100";
    }else{
        numberStr.text=[userDefaults objectForKey:@"brigness"];
    }
    
    if ([userDefaults objectForKey:@"CurConnectIP"]==nil) {
        lightIp.text = NSLocalizedStringFromTable(@"Lamp_LABEL", @"Locale", nil);
    }else{
        if ([userDefaults integerForKey:@"allOrGroup"]==1) {
            lightIp.text= [NSString stringWithFormat:@"%lu lamps",(unsigned long)[[userDefaults objectForKey:@"CurConnectIP"] count]];
        }else{
            lightIp.text=[[userDefaults objectForKey:@"CurConnectIP"] objectAtIndex:0];
        }
    }
}
#pragma mark--分段开关segmentedControl
//分段开关响应按钮事件
- (void) controlPressed:(id)sender {
    NSInteger selectedIndex = [ segmentedControl selectedSegmentIndex ];
    if(selectedIndex==0){
        [iflySpeechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
    }else if (selectedIndex==1){
        [iflySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    }
}


-(void)voiceClick
{
    bool ret = [iflySpeechRecognizer startListening];
    if (ret) {
        
    }else{
        [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        [self.view addSubview:_popUpView];
    }
//    [iflyRecognizerView start];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSLog(@"start listenning...");
}


#pragma mark - IFlySpeechRecognizerDelegate

- (void) onVolumeChanged: (int)volume
{
    if (isCanceled) {
        [_popUpView removeFromSuperview];
        return;
    }
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    [_popUpView setText: vol];
    [self.view addSubview:_popUpView];
}


- (void) onBeginOfSpeech
{
    [_popUpView setText: @"正在录音"];
    [self.view addSubview:_popUpView];
}


- (void) onEndOfSpeech
{
    [_popUpView setText: @"停止录音"];
    [self.view addSubview:_popUpView];
}



- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (isCanceled) {
        text = @"识别取消";
    }else if (error.errorCode ==0 ) {
        if (result.length==0) {
            text = @"无识别结果";
        }else{
            text = @"识别成功";
        }
    }else{
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    [_popUpView setText: text];
    [self.view addSubview:_popUpView];
}


- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSData * stringData = [[NSData alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        //得到的string进行转码
        stringData = [key dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (isLast){
        NSLog(@"this is the last result");
    }else{
        NSLog(@"this is not last ");
        //解析json数据
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:stringData options:kNilOptions  error:nil];
        //格式化输出解析得到的json数据
        for (int i=0;i<[[dict objectForKey:@"ws"] count];i++) {
            [resultString appendFormat:@"%@",[[[[[dict objectForKey:@"ws"] objectAtIndex:i] objectForKey:@"cw"] objectAtIndex:0]objectForKey:@"w"]];
        }
        NSLog(@"resultString======%@",resultString);
        result = resultString; //拼接的字符赋给result
        TcpClient *tcp = [TcpClient sharedInstance];
        if([resultString rangeOfString:@"关"].length>0||[resultString rangeOfString:@"关灯"].length>0||[resultString rangeOfString:@"Close"].length>0||[resultString rangeOfString:@"Off"].length>0||[resultString rangeOfString:@"Turn off"].length>0)//_roaldSearchText
        {
            char strcommand[8]={'s','*','*','*','*','*','#','e'};
            strcommand[6] =128;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
        }else if([resultString rangeOfString:@"开"].length>0||[resultString rangeOfString:@"开灯"].length>0||[resultString rangeOfString:@"Open"].length>0||[resultString rangeOfString:@"On"].length>0||[resultString rangeOfString:@"Turn on"].length>0)//_roaldSearchText
        {
            char strcommand[8]={'s','*','*','*','*','*','#','e'};
            strcommand[6] =129;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
        }
        if([resultString rangeOfString:@"蓝"].length>0||[resultString rangeOfString:@"蓝色"].length>0||[resultString rangeOfString:@"Blue"].length>0||[resultString rangeOfString:@"blue"].length>0)//_roaldSearchText
        {
            NSLog(@"yes");
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =0;
            strcommand [2] =0;
            strcommand [1] =255;
            strcommand [4] =0;
            strcommand[6] =0x93;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];;
        }
        if([resultString rangeOfString:@"绿"].length>0||[resultString rangeOfString:@"绿色"].length>0||[resultString rangeOfString:@"Green"].length>0||[resultString rangeOfString:@"green"].length>0)//_roaldSearchText
        {
            NSLog(@"yes");
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =0;
            strcommand [2] =255;
            strcommand [1] =0;
            strcommand [4] =0;
            strcommand[6] =0x93;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];;
        }
        if([resultString rangeOfString:@"红"].length>0||[resultString rangeOfString:@"红色"].length>0||[resultString rangeOfString:@"Red"].length>0||[resultString rangeOfString:@"red"].length>0)//_roaldSearchText
        {
            NSLog(@"yes");
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =255;
            strcommand [2] =0;
            strcommand [1] =0;
            strcommand [4] =0;
            strcommand[6] =0x93;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];;
        }
        if([resultString rangeOfString:@"白"].length>0||[resultString rangeOfString:@"白色"].length>0||[resultString rangeOfString:@"White"].length>0||[resultString rangeOfString:@"white"].length>0)//_roaldSearchText
        {
            NSLog(@"yes");
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =0;
            strcommand [2] =0;
            strcommand [1] =0;
            strcommand [4] =255;
            strcommand[6] =0x93;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
        }
    }
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
}


#pragma mark---语音事件
- (void) myButtonLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Touch down");
        //语音控制
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
    }
    
}



-(void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
}

//开和关操作
-(void)turnOff:(UIButton*)sender
{
    sender.selected=!sender.selected;
    if(!sender.selected){
        NSLog(@"开");
        TcpClient *tcp = [TcpClient sharedInstance];
        [onOffButon setImage:[UIImage imageNamed:@"power_off"] forState:UIControlStateSelected];
        char strcommand[8]={'s','*','*','*','*','*','#','e'};
        strcommand[6] =129;
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        
    }else{
        NSLog(@"关");
        TcpClient *tcp = [TcpClient sharedInstance];
        if(!tcp.currentArray.count)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_ONOFF", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil];
            [alert show];
            return;
        }else{
            char strcommand[8]={'s','*','*','*','*','*','#','e'};
            strcommand[6] =128;
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
        }
    }
    
}

#pragma mark -设置


-(void)SettingAction{
    [self.navigationController pushViewController:_lampVC animated:YES];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
    hud = [[MBProgressHUD alloc] init];
    hud.labelText =NSLocalizedStringFromTable(@"YaoYao_Hud", @"Locale", nil);
    [hud show:YES];
    [self.view addSubview:hud];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    [self yaoyiyao];
    
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
    [hud removeFromSuperview];
    UIAlertView * yaoyao =[[UIAlertView alloc] initWithTitle:@"摇一摇测试：" message:@"连接失败？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [yaoyao show];
}

-(void)yaoyiyao
{
//    NSLog(@"连接上一次的IP");
    NSMutableArray *hostArray=[[NSMutableArray alloc] initWithCapacity:0];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    hostArray= [userDef valueForKey:@"DeviceIP"];
    NSLog(@"上一次的IP hostArray:%@",hostArray);
    TcpClient *tcp = [TcpClient sharedInstance];
    [tcp connectTCP:hostArray];
    [hud removeFromSuperview];
    
}
#pragma mark - Button Handlers
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(MMDrawerController*)mm_drawerController{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[MMDrawerController class]]){
            return (MMDrawerController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
