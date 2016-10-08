//
//  LampsSettingVC.m
//  ADM_Lights
//
//  Created by admin on 14-5-13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "LampsSettingVC.h"
#import "Reachability.h"

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

#include <netdb.h>
#include <sys/socket.h>

#import "IPAddress.h"
#import "ViewController.h"
#import "SubCollectionsCell2.h"
#import "SubCollectionsInfo.h"
#import "MBProgressHUD.h"
#import "DeviceController.h"

#import "GPLoadingView.h"
#import "WifiListVC.h"
#import "CSCDateOperation.h"

#define TITLE_HEIGHT 24
#define rowcellCount 2
#define TCP_IP @"192.168.16.254" //程序运行时需要建立的第一个tcp socket

#define GROUPTAG 6000
#define LIGHTTAG 8000

@class DeviceVC;

@interface LampsSettingVC ()
{
    AsyncUdpSocket *myUdpSocket;
    
    NSUserDefaults *userDef;
    
    UIView         *searchListBGView;//热点时的三个选择view
    UIView         *bgBlueView;//扫描时的蓝色背景
    UITableView    *testTableView;  //所有灯列表
    GPLoadingView  *loading;
    UILabel        *percentLabel; // 扫描百分比
    
    
    UIButton  *btnRight1; //配置按钮
    UIButton  *btnRight;  //刷新按钮
    
    
    NSMutableArray  *myAllLightArray;       //所有灯数组信息，SubCollectionsInfo对象
    NSMutableArray  *groupArray;           //组灯数组信息，SubCollectionsInfo对象
    NSMutableArray  *APIPMacAddressArray;    //AP扫描控制灯的IP和mac地址数组
    NSMutableArray  *STAIPMacAddressArray; //STA扫描控制灯的IP和mac地址数组
    NSMutableArray  *lampsNameList;        //AP或者STA模式下，显示到tableview上灯泡的数据
    NSMutableArray  *grouplampsList;       //分组时显示到tableview上的数据
    NSMutableArray  *allDeviceArray;       //保存本地设备名称与MAC地址对应数组
    
    
    WifiListVC *wifiVC;
    
    
    NSString *broadcastAddress;
    
    UILongPressGestureRecognizer *longPress;//单个长按
    UILongPressGestureRecognizer *GrouplongPress;//分组长按
    
    int  scantime ;
    NSInteger  selectedIndex;//分段控件的值，代表分组还是全部灯
    int  stepStatus;//0代表ap模式开始扫描，1代表已经接收到一个数据，ap模式结束
    
    UISegmentedControl *segmentedControl;
}

@end

@implementation LampsSettingVC

#pragma mark ---初始化会执行部分
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.view.frame.origin.y==64) {
        NSLog(@"===============aaaaaa");
        testTableView.frame=CGRectMake(0,64-self.view.frame.origin.y, SCREENWIDTH,SCREENHEIGHT-40-self.view.frame.origin.y);
        segmentedControl.frame=CGRectMake(0,SCREENHEIGHT-40-self.view.frame.origin.y, SCREENWIDTH, 40);
        bgBlueView.frame=CGRectMake(0, 0-self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }else{
        NSLog(@"===============bbbbbb");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDef =[NSUserDefaults standardUserDefaults];
    self.title = NSLocalizedStringFromTable(@"TITLE_Lamps", @"Locale", nil);
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    [self.view addSubview:imageView];
    
    
    //导航栏右侧刷新和配置按钮
    btnRight1=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight1.frame=CGRectMake(0, 0, 44, 44);
    [btnRight1 setTitle:NSLocalizedStringFromTable(@"Right_config_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    btnRight1.titleLabel.font =[UIFont systemFontOfSize:14];
    [btnRight1 addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    
    btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(44, 0, 54, 44);
    btnRight.titleLabel.font =[UIFont systemFontOfSize:14];
    [btnRight setTitle:NSLocalizedStringFromTable(@"Right_search_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *barView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 98, 44)];
    [barView addSubview:btnRight1];
    [barView addSubview:btnRight];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:barView];
    
    self.navigationItem.hidesBackButton=YES;
    
    //初始化表视图数据
    testTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-104)];
    testTableView.tag=100000;
    testTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, 0.01f)];
    testTableView.separatorStyle=UITableViewStylePlain;
    [testTableView setBackgroundColor:[UIColor clearColor]];
    testTableView.dataSource=self;
    testTableView.delegate=self;
    testTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:testTableView];
    
    
    
    //底部分段控件
    segmentedControl= [[ UISegmentedControl alloc ] initWithItems: nil];
    [segmentedControl insertSegmentWithTitle: NSLocalizedStringFromTable(@"ALL_BUTTON", @"Locale", nil) atIndex: 0 animated: NO ];
    [segmentedControl insertSegmentWithTitle: NSLocalizedStringFromTable(@"Group_BUTTON", @"Locale", nil) atIndex: 1 animated: NO ];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame=CGRectMake(0,SCREENHEIGHT-40, self.view.bounds.size.width, 40);
    segmentedControl.backgroundColor =[UIColor blackColor];
    [segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    
    //蓝色扫描背景
    bgBlueView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    bgBlueView.backgroundColor =[UIColor blueColor];
    bgBlueView.tag=10000;
    [self.view addSubview:bgBlueView];
    
    
    //转圈圈
    loading = [[GPLoadingView alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, (SCREENHEIGHT-200)/2, 200, 200)];
    [bgBlueView addSubview:loading];
    
    
    //进度百分比
    percentLabel =[[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, (SCREENHEIGHT-200)/2+80, 200, 40)];
    percentLabel.text=@"0%";
    percentLabel.backgroundColor =[UIColor clearColor];
    percentLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:48];
    percentLabel.textAlignment=NSTextAlignmentCenter;
    percentLabel.textColor =[UIColor whiteColor];
    [bgBlueView addSubview:percentLabel];
    
    
    //扫描设备中label
    UILabel        *scanLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, (SCREENHEIGHT-200)/2+130, 200, 20)];
    scanLabel.text=@"扫描设备中...";
    scanLabel.backgroundColor =[UIColor clearColor];
    scanLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:21];
    scanLabel.textAlignment=NSTextAlignmentCenter;
    scanLabel.textColor =[UIColor whiteColor];
    [bgBlueView addSubview:scanLabel];

    
    //初始化group 表
    groupArray =[[NSMutableArray alloc] init];
    myAllLightArray  =[[NSMutableArray alloc] init];
    wifiVC     =[[WifiListVC alloc] init];
    
    
    APIPMacAddressArray =[[NSMutableArray alloc] initWithCapacity:0]; //AP下ip mac地址 name组成的字典数据
    STAIPMacAddressArray =[[NSMutableArray alloc] initWithCapacity:0]; //STA下ip mac地址 name组成的字典数据
    allDeviceArray =[[NSMutableArray alloc] initWithArray:[userDef objectForKey:@"AllDeviceInfo"]];
    [self searchClick];  //程序启动， 执行刷新搜索
}

-(void)searchClick
{
    //判断网络状态wifi,3G,无网络
    Reachability *reach = [Reachability reachabilityWithHostName:TCP_IP];//用于判断有没有WIFI网络
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_Guangbo", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil,nil];
            [alert show];
        }
            
            break;
        case ReachableViaWiFi:
        {
            NSError * error = Nil;
            myUdpSocket =[[AsyncUdpSocket alloc] initIPv4];//使用IPv4初始化一个Socket
            [myUdpSocket bindToPort:988 error:&error];
            [myUdpSocket setDelegate: self];//设置委托为自身
            [myUdpSocket receiveWithTimeout:-1 tag:0];//启动接受线程
            //允许广播信息
            BOOL isOK=[myUdpSocket enableBroadcast:YES error:&error];
            if (!isOK) {
                NSLog(@"UDP创建失败，失败原因:%@",error);
            }else{
                NSLog(@"UDP建立成功");
            }
            //当前WIFI连接的名称
            NSString *ssid = [[[self fetchSSIDInfo] objectForKey:@"SSID"] lowercaseString];
            if([ssid hasPrefix:@"inlit_w101"]||[ssid hasPrefix:@"inlit_wt100"]){
                stepStatus=0;//是AP模式
                [APIPMacAddressArray removeAllObjects];//ap模式下的数据
            }else{
                stepStatus=3;//是STA模式
                [STAIPMacAddressArray removeAllObjects];//sta模式下的数据
            }
            [self routerIp];
            
            if (broadcastAddress==nil) {
                return;
            }else{
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:1.5];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:3.0];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:4.5];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:6.0];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:7.5];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:9.0];
                [self performSelector:@selector(sendUDPMessage) withObject:nil afterDelay:10.0];
            }
            
            self.navigationController.navigationBar.hidden= YES;
            
            bgBlueView.hidden=NO;
            [loading startRotateAnimation];
            scantime=0 ;
            //设置定时器
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeNumber:) userInfo:nil repeats:YES];
        }
            break;
        case ReachableViaWWAN:
        {
            // 3G下 提示没有连接wifi
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_Guangbo", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil,nil];
            [alert1 show];
        }
            break;
    }
}

-(void)sendUDPMessage{
    if(stepStatus==0||stepStatus==3){
        NSData *writeData= [@"HLK" dataUsingEncoding:NSUTF8StringEncoding];
        [myUdpSocket sendData:writeData toHost:broadcastAddress port:988 withTimeout:-1 tag:0];
        writeData= [@"{(WHO)}" dataUsingEncoding:NSUTF8StringEncoding];
        [myUdpSocket sendData:writeData toHost:broadcastAddress port:988 withTimeout:-1 tag:0];
    }
}
//AP,STA模式扫描结束的处理方法
-(void)dismissUDPSearchHUD
{
    self.navigationController.navigationBar.hidden = NO;
    [loading stopAnimation];
    bgBlueView.hidden =YES;
    NSString* string2;
    if ([APIPMacAddressArray count]&&stepStatus==1) {//如果IPMacAddressArray有数据，则说明是ap模式下
        lampsNameList = APIPMacAddressArray; //得到表格数据源
        [self initData];
        string2= [NSString stringWithFormat:@"%lu",(unsigned long)[APIPMacAddressArray count]];
        
        NSMutableArray *tempDic=[[NSMutableArray alloc]initWithArray:[userDef objectForKey:@"apSettingIsShow"]];
        for (int i=0; i<[tempDic count]; i++) {
            if ([[tempDic objectAtIndex:i] isEqualToString:[[APIPMacAddressArray objectAtIndex:0] objectForKey:@"DeviceMac"]]) {
                TcpClient *tcp =[TcpClient sharedInstance];
                NSMutableArray * APipAdresses =[[NSMutableArray alloc] initWithObjects:TCP_IP, nil];
                [tcp connectTCP:APipAdresses];
                [self.navigationController popViewControllerAnimated:NO];
                break;
            }
            if (i==[tempDic count]-1) {
                [self AP_alertAction];
            }
        }
        if([tempDic count]==0)[self AP_alertAction];
        
    }else if([STAIPMacAddressArray count]&&stepStatus==3){
        lampsNameList=STAIPMacAddressArray;
        [self initData];
        string2= [NSString stringWithFormat:@"%lu",(unsigned long)[STAIPMacAddressArray count]];
    }else{
        [lampsNameList removeAllObjects];
        string2= [NSString stringWithFormat:@"0"];
    }
    [testTableView reloadData];
    //扫描到多少个设备
    NSString* string1=NSLocalizedStringFromTable(@"HUD_ScanNumber", @"Locale", nil);
    NSString* tempstr =[string1 stringByAppendingString:string2];
    NSString* string3=NSLocalizedStringFromTable(@"HUD_ScanNumber_two", @"Locale", nil);
    
    MBProgressHUD * hhuudd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hhuudd.removeFromSuperViewOnHide =YES;
    hhuudd.mode = MBProgressHUDModeText;
    hhuudd.labelText =[tempstr stringByAppendingString:string3];
    hhuudd.minSize = CGSizeMake(120.f, 50.0f);
    [hhuudd hide:YES afterDelay:1.5];
    
}

-(void) initData
{
    if (selectedIndex==0)
    {
        [myAllLightArray removeAllObjects];
        for (int k=0; k<lampsNameList.count; k++)
        {
            SubCollectionsInfo *info=[[SubCollectionsInfo alloc] init];
            if(![userDef objectForKey:@"brigness"]){
                info.niandaiString=@"100";
            }else{
                info.niandaiString=[userDef objectForKey:@"brigness"];  //传亮度值
            }
            info.titleString=@"%";  // 百分号％
            NSString *MACStr = [[lampsNameList  objectAtIndex:k ]valueForKey:@"DeviceMac" ];
            NSString *temStr=[self ISContentMAC:MACStr];
            if ([temStr length]) {
                info.idString =temStr;
            }else{
                info.idString =@"未命名";
            }
            info.ipString = [[lampsNameList objectAtIndex:k] valueForKey:@"DeviceIP"];// ip地址
            info.contentString=MACStr;//  mac 地址
            info.iconString=@"light_pl";
            [myAllLightArray addObject:info];
        }
    }else if (selectedIndex==1){
        
        if(grouplampsList==NULL){
            return ;
        }
        [groupArray removeAllObjects];
        
        for (int k=0; k<grouplampsList.count; k++)
        {
            SubCollectionsInfo *info=[[SubCollectionsInfo alloc] init];
            NSArray *temarray =[[grouplampsList objectAtIndex:k]valueForKey:@"GroupArrayIP"];
            if(![userDef objectForKey:@"brigness"])
            {
                info.niandaiString=@"100";
            }else{
                info.niandaiString=[userDef objectForKey:@"brigness"];  //传亮度值
            }
            info.titleString=@"%";  // 百分号％
            
            info.idString =[[grouplampsList objectAtIndex:k] valueForKey:@"GroupName"];
            NSString *string1= [NSString stringWithFormat:@"%lu ",(unsigned long)[temarray  count]];
            NSString *string2=NSLocalizedStringFromTable(@"HUD_ScanNumber_two", @"Locale", nil);
            info.contentString=[string1 stringByAppendingString:string2];// ip 或mac 地址
            info.iconString=@"light_pl";
            [groupArray addObject:info];
        }
    }
}

#pragma mark ---灯设备选中事件时，创建tcp连接
-(void)cellviewTaped:(UITapGestureRecognizer *)recognizer
{
    NSLog(@")cellviewTaped:");
    TcpClient *tcp =[TcpClient sharedInstance];//创建tcp连接
    if (selectedIndex==0)
    {
        NSLog(@"aaaaa");
        NSInteger tag=[recognizer view].tag - LIGHTTAG;
        
        NSString *HOST2;
        if(stepStatus==3){
            if([STAIPMacAddressArray count]>=tag&&[STAIPMacAddressArray count]){
                NSLog(@"bbbbbb");
                HOST2 = [[STAIPMacAddressArray objectAtIndex:tag] objectForKey:@"DeviceIP"];
                NSLog(@"vvvvvvv");
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"nil" message:@"error!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
        }else{
            HOST2 = TCP_IP; // 根据当前获得的单个ip地址进行通讯
        }
        NSMutableArray *ipAdresses =[[NSMutableArray alloc] initWithObjects:HOST2, nil];
        [userDef setInteger:ipAdresses.count forKey:@"numberOfLight"];
        [tcp connectTCP:ipAdresses];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (selectedIndex==1){
        NSInteger tag=[recognizer view].tag - GROUPTAG;
        NSMutableArray * ipAdresses =[[grouplampsList objectAtIndex:tag] valueForKey:@"GroupArrayIP"];
        [userDef setInteger:ipAdresses.count forKey:@"numberOfLight"];
        [tcp connectTCP:ipAdresses];
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.navigationItem.leftBarButtonItem.customView.hidden =NO;
}

#pragma tableview
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex==1){
        if (groupArray.count==0)return 0;
        return (groupArray.count-1)/rowcellCount+1;
    }else if (selectedIndex==0){
        if (myAllLightArray.count==0)return 0;
        return (myAllLightArray.count-1)/rowcellCount+1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 =  @"Cell1";
    SubCollectionsCell2 *cell =(SubCollectionsCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil){
        cell = [[SubCollectionsCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.backgroundColor=[UIColor clearColor];
    }
    NSUInteger row=[indexPath row];
    SubCollectionsInfo *subInfo=nil;
    for (NSInteger i = 0; i < rowcellCount; i++){
        if(selectedIndex==0){//如果是全部灯泡模式
            if (row*rowcellCount+i>myAllLightArray.count-1){
                cell.cellView2.hidden=YES; //处理该行只有一个数据时。
                break;
            }
            subInfo=[myAllLightArray objectAtIndex:row*rowcellCount + i];
            
            if (i==0){
                [cell.cellView1.iconImageView setImage:[UIImage imageNamed:subInfo.iconString]];
                [cell.cellView1.niandaiLabel setText:subInfo.niandaiString];
                [cell.cellView1.titleLabel setText:subInfo.titleString];
                [cell.cellView1.nameLabel setText:subInfo.idString];
                [cell.cellView1.contentLabel setText:subInfo.contentString];
                [cell.cellView1.ipLabel  setText:subInfo.ipString];
                cell.cellView1.tag=LIGHTTAG+row*rowcellCount + i;
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                [ cell.cellView1 addGestureRecognizer:tapRecognizer];
                //长按手势
                longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newLongPressGestureRecognizer:)];
                [cell.cellView1 addGestureRecognizer:longPress];
                longPress.minimumPressDuration = 1.0;
            }else{
                cell.cellView2.hidden=NO;
                [cell.cellView2.iconImageView setImage:[UIImage imageNamed:subInfo.iconString]];
                [cell.cellView2.niandaiLabel setText:subInfo.niandaiString];
                [cell.cellView2.titleLabel setText:subInfo.titleString];
                [cell.cellView2.nameLabel setText:subInfo.idString];
                [cell.cellView2.contentLabel setText:subInfo.contentString];
                [cell.cellView2.ipLabel  setText:subInfo.ipString];
                
                cell.cellView2.tag=LIGHTTAG+row*rowcellCount + i;
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                [ cell.cellView2 addGestureRecognizer:tapRecognizer];
                //长按手势
                longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newLongPressGestureRecognizer:)];
                [cell.cellView2 addGestureRecognizer:longPress];
                longPress.minimumPressDuration = 1.0;
            }
            
        }else if (selectedIndex==1){
            if (row*rowcellCount+i>groupArray.count-1){
                cell.cellView2.hidden=YES; //处理该行只有一个数据时。
                break;
            }
            subInfo=[groupArray objectAtIndex:row*rowcellCount + i];
            if (i==0){
                [cell.cellView1.iconImageView setImage:[UIImage imageNamed:subInfo.iconString]];
                [cell.cellView1.niandaiLabel  setText:subInfo.niandaiString];
                [cell.cellView1.titleLabel    setText:subInfo.titleString];
                [cell.cellView1.nameLabel     setText:subInfo.idString];
                [cell.cellView1.contentLabel  setText:subInfo.contentString];
                [cell.cellView1.ipLabel       setText:subInfo.ipString];
                
                cell.cellView1.tag=GROUPTAG+row*rowcellCount + i;
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                [ cell.cellView1 addGestureRecognizer:tapRecognizer];
                //长按手势
                GrouplongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newLongPressGestureRecognizer:)];
                [cell.cellView1 addGestureRecognizer:GrouplongPress];
                GrouplongPress.minimumPressDuration = 1.0;
            }else{
                cell.cellView2.hidden=NO;
                [cell.cellView2.iconImageView setImage:[UIImage imageNamed:subInfo.iconString]];
                [cell.cellView2.niandaiLabel setText:subInfo.niandaiString];
                [cell.cellView2.titleLabel setText:subInfo.titleString];
                [cell.cellView2.nameLabel setText:subInfo.idString];
                [cell.cellView2.contentLabel setText:subInfo.contentString];
                [cell.cellView2.ipLabel  setText:subInfo.ipString];
                
                cell.cellView2.tag=GROUPTAG+row*rowcellCount + i;
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                [ cell.cellView2 addGestureRecognizer:tapRecognizer];
                //长按手势
                GrouplongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newLongPressGestureRecognizer:)];
                [cell.cellView2 addGestureRecognizer:GrouplongPress];
                GrouplongPress.minimumPressDuration = 1.0;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(NSString*)ISContentMAC:(NSString*)MACString{
    for (int j=0;j< [allDeviceArray count];j++) {
        if ([[[allDeviceArray objectAtIndex:j] objectForKey:@"DeviceMac"] isEqualToString:MACString]) {
            return [[allDeviceArray objectAtIndex:j] objectForKey:@"DeviceName"];
        }
    }
    return NULL;
}

#pragma mark -长按事件
- (void)newLongPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan");
        
        if(selectedIndex==0){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"输入灯泡要修改成什么名称！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            alert.tag=[gr view].tag;
            [alert show];
        }else{
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"改名",@"删除", nil];
            actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
            actionSheet.tag=[gr view].tag;
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)return;
    
    NSString *name=[alertView textFieldAtIndex:0].text;
    if (selectedIndex==1) {//分组改名
        NSInteger currGroup=alertView.tag-GROUPTAG; //当前长按的组
        NSLog(@"grouplampsList:%@",grouplampsList);
        if (currGroup<[grouplampsList count]) {
            NSMutableDictionary *tempDic=[[NSMutableDictionary alloc]initWithDictionary:[grouplampsList objectAtIndex:currGroup]];
            [tempDic setObject:name forKey:@"GroupName"];
            [grouplampsList replaceObjectAtIndex:currGroup withObject:tempDic];
        }
        [userDef setObject:grouplampsList forKey:@"GroupIP"];
        [self initData];
        [testTableView reloadData];
    }else{//灯泡改名
        NSInteger currLamps=alertView.tag-LIGHTTAG; //当前长按的灯
        for (int i=0; i<[allDeviceArray count]; i++) {//如果能在以往的数据中找到，则替换
            if ([[[allDeviceArray objectAtIndex:i] objectForKey:@"DeviceMac"] isEqualToString:[[lampsNameList objectAtIndex:currLamps] objectForKey:@"DeviceMac"]]) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[allDeviceArray objectAtIndex:i]];
                [dic setObject:name forKey:@"DeviceName"];
                [allDeviceArray replaceObjectAtIndex:i withObject:dic];
                break;
            }else if(i==[allDeviceArray count]-1){//如果到最后一个都不相等，则没有数据，添加新数据
                NSMutableDictionary *dic=[[NSMutableDictionary alloc ]initWithObjectsAndKeys:name,@"DeviceName",[[lampsNameList objectAtIndex:currLamps] objectForKey:@"DeviceMac"],@"DeviceMac",nil];
                [allDeviceArray addObject:dic];
            }
        }
        if([allDeviceArray count]==0){
            NSMutableDictionary *dic=[[NSMutableDictionary alloc ]initWithObjectsAndKeys:name,@"DeviceName",[[lampsNameList objectAtIndex:currLamps] objectForKey:@"DeviceMac"],@"DeviceMac",nil];
            [allDeviceArray addObject:dic];
        }
        [userDef setObject:allDeviceArray forKey:@"AllDeviceInfo"];
        [self initData];
        [testTableView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)return;
    switch (buttonIndex)
    {
        case 0: {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"输入分组要修改成什么名称！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            alert.tag=actionSheet.tag;
            [alert show];
            break;
        }
        case 1: {
            //删除操作
            NSInteger currGroup=actionSheet.tag-GROUPTAG; //当前长按的组
            [grouplampsList removeObjectAtIndex:currGroup];//数组中的数据移除
            [userDef setObject:grouplampsList forKey:@"GroupIP"];
            [self initData];
            [testTableView reloadData];
            break;
        }
    }
}


#pragma mark 新增分组回调
//选择分组后执行的委托
-(void)getHostList:(NSMutableArray *)hostLists andGetMac:(NSMutableArray *)MacLists
{
    //判断hostLists参数是all数组还是group数组
    if(selectedIndex==0)
    {
        //每次传值后 ，清空之前dataArray的值， 再重新加载testTableView表格数据
        NSLog(@"即将刷新页面");
        [self initData];
        [testTableView reloadData];
        
    }else if (selectedIndex==1){
        if(hostLists==nil){
            return;
        }else{
            grouplampsList =[NSMutableArray arrayWithArray:hostLists]; //ip地址;
            [self initData];
            [testTableView reloadData];
        }
    }
}

#pragma mark--分段开关segmentedControl
//分段开关响应按钮事件
- (void) controlPressed:(id)sender {
    selectedIndex = [ (UISegmentedControl*)sender selectedSegmentIndex];
    if(selectedIndex==0)
    {
        self.title = NSLocalizedStringFromTable(@"TITLE_Lamps", @"Locale", nil);
        UIView *barView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 98, 44)];
        [barView addSubview:btnRight1];
        [barView addSubview:btnRight];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:barView];
    }else if (selectedIndex==1){
        self.title = NSLocalizedStringFromTable(@"TITLE_Lamps_group", @"Locale", nil);
        grouplampsList =[[userDef objectForKey:@"GroupIP"] mutableCopy];//得到所有灯分组数组
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Right_new_BUTTON", @"Locale", nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(addClicked)];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    }
    [self initData];
    [testTableView reloadData];
}

#pragma mark -AP入网提示，弹出入网对话框
-(void)AP_alertAction
{
    bgBlueView.hidden =NO;
    [self.view setBackgroundColor:[UIColor blueColor]];
    self.navigationController.navigationBar.hidden= YES;
    
    //模态视图searchListRect
    CGRect searchListRect=CGRectMake(50, 166-20, [UIScreen mainScreen].bounds.size.width/2+60, TITLE_HEIGHT*4+30*4+20);
    
    searchListBGView=[[UIView alloc] initWithFrame:searchListRect];
    [searchListBGView setBackgroundColor:[UIColor grayColor]];
    [searchListBGView.layer setCornerRadius:15.0];//圆角
    
    
    //设置titile
    UILabel* lableTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 220, TITLE_HEIGHT+30)];
    lableTitle.text=@"连接至路由器";
    lableTitle.font = [UIFont systemFontOfSize: 21];
    lableTitle.textAlignment =NSTextAlignmentCenter;
    lableTitle.textColor=[UIColor whiteColor];
    [searchListBGView addSubview:lableTitle];
    
    //connect button
    
    UIButton  *btnSearch=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setTitle:@"连接" forState:UIControlStateNormal];
    btnSearch.backgroundColor =[UIColor whiteColor];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize: 24];
    [btnSearch setFrame:CGRectMake(0, TITLE_HEIGHT*3-6, 220, 50)];
    [btnSearch addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [searchListBGView addSubview:btnSearch];
    
    //nocancel button
    UIButton  *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.backgroundColor =[UIColor whiteColor];
    [btnCancel setTitle:@"不需要连接" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize: 24];
    [btnCancel setFrame:CGRectMake(0, TITLE_HEIGHT*5-1, 220, 50)];
    [btnCancel addTarget:self action:@selector(noconnetclicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchListBGView addSubview:btnCancel];
    
    //nocancel2 button
    UIButton  *btnCancel2=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel2.backgroundColor =[UIColor whiteColor];
    [btnCancel2 setTitle:@"跳过，下次再说" forState:UIControlStateNormal];
    [btnCancel2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel2.titleLabel.font = [UIFont systemFontOfSize: 24];
    [btnCancel2 setFrame:CGRectMake(0, TITLE_HEIGHT*7+5, 220, 50)];
    [btnCancel2 addTarget:self action:@selector(nextconnetclicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchListBGView addSubview:btnCancel2];
    
    UILabel   *textlabel =[[UILabel alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height-80, 260, 80)];
    textlabel.lineBreakMode = NSLineBreakByWordWrapping;
    textlabel.numberOfLines = 0;
    textlabel.text =@"如果您有无线路由， 您可以将LED设备连接到路由器，然后用手机通过无线路由器对设备进行控制";
    textlabel.textColor=[UIColor whiteColor];
    [bgBlueView addSubview:textlabel];
    [bgBlueView addSubview:searchListBGView];
}


//不连网
-(void)noconnetclicked:(UIButton*)sender
{
    [self nextconnetclicked:sender];
    //是AP模式， 直接进入操控界面直接进行tcp的连接
    //创建tcp连接
    TcpClient *tcp =[TcpClient sharedInstance];
    NSMutableArray * APipAdresses =[[NSMutableArray alloc] initWithObjects:TCP_IP, nil];
    [tcp connectTCP:APipAdresses];
    
    //下次连接时是否再显示
    NSMutableArray *tempDic=[[NSMutableArray alloc]initWithArray:[userDef objectForKey:@"apSettingIsShow"]];
    [tempDic addObject:[[APIPMacAddressArray objectAtIndex:0] objectForKey:@"DeviceMac"]];
    [userDef setObject:tempDic forKey:@"apSettingIsShow"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
//不连网
-(void)nextconnetclicked:(UIButton*)sender
{
    [userDef setInteger:1 forKey:@"numberOfLight"];
    sender.selected = YES;
    bgBlueView.hidden =YES;
    [searchListBGView removeFromSuperview];
    self.navigationController.navigationBar.hidden= NO;
}


#pragma mark- 广播搜索设备
-(void)changeNumber:(NSTimer *)timer
{
    scantime++;
    loading.anglePer += M_PI/20;
    if (loading.anglePer >=M_PI) {
        loading.anglePer -= M_PI;
    }
    if (scantime>=100||stepStatus==1) {
        percentLabel.text =@"100%";
        [timer invalidate];
        [self performSelector:@selector(dismissUDPSearchHUD) withObject:nil afterDelay:0.3f];
        return;
    }
    percentLabel.text =[NSString stringWithFormat:@"%d%%",scantime];
}


//分组选择列表， 根据所有页刷新得到的数据 传值
-(void)addClicked
{
    DeviceController *devices;
    devices = [[DeviceController alloc] init];
    devices.delegate=self;
    devices.allLightMessage=STAIPMacAddressArray;
    [self.navigationController pushViewController:devices animated:YES];
}


#pragma mark - AsyncUdpSocket Delegate  广播代理
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    //判断是否是ap模式，是ap模式，是否已返回一次数据
    if (stepStatus==0&&[APIPMacAddressArray count]==0) {
        NSMutableDictionary *resultDic=[[NSMutableDictionary alloc]initWithDictionary:[CSCDateOperation getIPAndMACFromData:data]];
        if (resultDic!=nil&&[resultDic count]>1) {
            [APIPMacAddressArray addObject:resultDic];
            stepStatus=1;
        }
    }else if(stepStatus==3){//当前是STA模式
        NSMutableDictionary *resultDic=[[NSMutableDictionary alloc]initWithDictionary:[CSCDateOperation getIPAndMACFromData:data]];
        if ([resultDic count]!=0&&![STAIPMacAddressArray containsObject:resultDic]) {
            [STAIPMacAddressArray addObject:resultDic];
        }
    }
    [sock receiveWithTimeout:-1 tag:0];
    return YES;
}


#pragma mark - 获取当前设备的名称BSSID，ssid
//连接路由器，先搜索附近的wifi热点
-(void)settingAction
{
    NSString *ssid = [[[self fetchSSIDInfo] objectForKey:@"SSID"] lowercaseString];
    NSLog(@"当前连接的WiFi的名称是：%@",ssid);
    if ([ssid hasPrefix:@"inlit_wt100"] >0||[ssid hasPrefix:@"inlit_w101"])//包含前缀为AP模式
    {
        [self.navigationController pushViewController:wifiVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_STA", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil];
        [alert show];
    }
}

//用于判断是ap模式还是sta模式,返回ssid，设备名称
-(id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

- (NSString *) routerIp
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    broadcastAddress =[[NSString alloc ]initWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
