//
//  WifiListVC.m
//  ADM_inlit_beta
//
//  Created by admin on 14-10-22.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "WifiListVC.h"
#import "MBProgressHUD.h"
#import "AsyncSocket.h"
#include <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>

#define SRV_CONNECTED 0
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 2
#define TCP_IP @"192.168.16.254" //程序运行时需要建立的第一个tcp socket
#define TCP_PORT 80

@interface WifiListVC ()<AsyncSocketDelegate>
{
    UITableView    *WiFiListTable;
    
    UIButton       *btnRight;//刷新按钮
    
    NSString       *SSIDString; //得到该选的wifi
    NSString       *broadcastAddress;
    
    UITextField    *password; //密码
    UIView         *editView; //wifi SSID 密码编辑view
    MBProgressHUD  *hud_set;
    
    NSInteger      ssidLength;
    NSInteger      pswLength;
    
    AsyncSocket    *client;
    AsyncSocket    *secondClient;
    AsyncUdpSocket *UdpSocket;
   
    NSMutableArray *Doarray ;
    
    NSMutableArray *WIFIList;//wifi 信息数据
    
}

@end

@implementation WifiListVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//wifi 扫描 创建到tcp
- (int) connectServer: (NSString *) hostIP port:(int) hostPort{
    if (client == nil) {
        client = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        [client setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host " stringByAppendingString:hostIP] message:[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return SRV_CONNECT_FAIL;
        }else{
            // 连接成功后
            return SRV_CONNECT_SUC;
        }
    }else{
        [client readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
        NSLog(@"－socket AP模式连接!");
    }
}

//AP转STA的需要创建的tcp
- (int) connectToSecondScrver: (NSString *) hostIP port:(int) hostPort
{
    if (secondClient == nil) {
        secondClient = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        [secondClient setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        if (![secondClient connectToHost:hostIP onPort:hostPort error:&err]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host " stringByAppendingString:hostIP] message:[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return SRV_CONNECT_FAIL;
        }else{
            // 连接成功后
            NSLog(@"－－》第二次Socket连接成功!成功成功");
            return SRV_CONNECT_SUC;
        }
    }else {
        [secondClient readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
        NSLog(@"－－》第二次Socket连接!");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"TITLE_WIFI", @"Locale", nil);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    [self.view addSubview:imageView];
    
    WiFiListTable =[[UITableView alloc] init];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [WiFiListTable setTableFooterView:view];
    WiFiListTable.dataSource= self;
    WiFiListTable.delegate=self;
    WiFiListTable.backgroundColor = [UIColor grayColor];
    

    [WiFiListTable setFrame:CGRectMake(0,64, self.view.frame.size.width,self.view.frame.size.height-64)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Left_back_BUTTON", @"Locale", nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(BackAction)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

    
    btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(10, 0, 50, 24);
    [btnRight setTitle:NSLocalizedStringFromTable(@"Right_search_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *barView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 24)];
    [barView addSubview:btnRight];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:barView];
    [self.view addSubview:WiFiListTable];
    [self scanClick]; //执行刷新扫描wifi
}

-(void)viewWillAppear:(BOOL)animated
{
    WIFIList =[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"WIFIArray"]];
    NSLog(@"WIFIList=%@",WIFIList);
    WiFiListTable.hidden = NO;
    [WiFiListTable reloadData];
}

-(void)BackAction
{
    [password resignFirstResponder];

    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scanClick
{
    [password resignFirstResponder];
    
    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
    WiFiListTable.hidden = NO;
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSString *ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
    NSLog(@"当前连接的WiFi的名称是：%@",ssid);
    NSRange range = [ssid rangeOfString:@"inlit_wt100"];//判断字符串是否包含，包含则是AP模式
    if (range.length >0||[ssid hasPrefix:@"inlit_w101"])//包含
    {
        hud_set =[[MBProgressHUD alloc] init];
        hud_set.labelText = @"WIFI扫描中"; //正在配置，请稍等
        [hud_set show:YES];
        [self.view addSubview:hud_set];
        
        
        if ([ssid hasPrefix:@"inlit_w101"]) {
            NSError *error;
            UdpSocket =[[AsyncUdpSocket alloc] initIPv4];
            [UdpSocket bindToPort:988 error:&error];//PORT_ACTIVE为发送端口
            [self routerIp];
            [UdpSocket setDelegate: self];//设置委托为自身
            [UdpSocket receiveWithTimeout:-1 tag:0];//启动接受线程,,同时开启TCP服务监听，以便后面建立TCP连接
            BOOL isOK=[UdpSocket enableBroadcast:YES error:&error];//允许广播信息
            if (!isOK) {
                NSLog(@"-----------%@",error);
            }else{
                NSLog(@"UDP建立成功");
            }
            NSData *writeData= [@"{(SCAN)}" dataUsingEncoding:NSUTF8StringEncoding];
            BOOL result = NO;
            if (broadcastAddress==nil) {
                return;
            }else{
                
                NSLog(@"单个控制时的网关地址---%@",broadcastAddress);
                result = [UdpSocket sendData:writeData toHost:broadcastAddress port:988 withTimeout:-1 tag:0]; //对网关
            }
        }else{
            [self connectServer:TCP_IP port:TCP_PORT]; //连接192.168.16.254:80进行wifi扫描
            NSMutableString *wifisetting =[[NSMutableString  alloc]initWithString:@"POST /goform/ser2netconfigAT HTTP/1.1\r\nHost: 192.168.16.254\r\nConnection: keep-alive\r\nAuthorization: Basic YWRtaW46YWRtaW4=\r\nContent-Length:＊\r\n\r\nwifi_Scan=?&wifi_Scan=?&wifi_Scan=?&wifi_Scan=?&wifi_Scan=?"];
            NSInteger  allLength =11+36;
            NSString *tempUrl =[NSString stringWithFormat:@"%ld",(long)allLength];
            NSString *strUrl = [wifisetting stringByReplacingOccurrencesOfString:@"＊" withString:tempUrl];
            
            
            NSData *wifiData= [strUrl dataUsingEncoding:NSUTF8StringEncoding];
            
            [client writeData:wifiData withTimeout:-1 tag:0];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_STA", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }

    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  WIFIList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];//
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [WIFIList objectAtIndex:row];
    cell.tag = row;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone4) {
        return 48;
    }
    return 55;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //根据当前行的值,代理传值
    NSString *rowValue = cell.textLabel.text;
    SSIDString=rowValue;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    UILabel *wifiname =[[UILabel alloc] initWithFrame:CGRectMake(10, 6, 200, 20)];
    wifiname.text=@"WiFi名称（SSID）";
    wifiname.textColor=[UIColor whiteColor];
    wifiname.backgroundColor = [UIColor clearColor];
    
    UILabel *wifiStr =[[UILabel alloc] initWithFrame:CGRectMake(10, 29, 300, 20)];
    wifiStr.text=SSIDString;
    wifiStr.adjustsFontSizeToFitWidth=YES;
    wifiStr.backgroundColor = [UIColor clearColor];
    wifiStr.textColor=[UIColor whiteColor];
    
    UILabel *passname =[[UILabel alloc] initWithFrame:CGRectMake(10, 56, 200, 20)];
    passname.text=@"密码";
    passname.backgroundColor = [UIColor clearColor];
    passname.textColor=[UIColor whiteColor];

    
    password = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, [[UIScreen mainScreen] bounds].size.width-20, 40)];
    password.placeholder =@"输入wifi密码";
    password.backgroundColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"WifiuserInfo"]==nil) {
        password.text=nil;
    }else{
        password.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"WifiuserInfo"];
    }
    password.returnKeyType = UIReturnKeyDone;  //键盘返回类型
    
    password.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    password.delegate= self;
    
    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
    password.borderStyle =UITextBorderStyleNone;
    [password.layer setMasksToBounds:YES];
    [password.layer setBorderWidth:2.0]; //边框宽度
    password.layer.cornerRadius = 8;
    [password.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];    //左端缩进像素
    password.leftView = view1;
    password.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBut.frame = CGRectMake(50, 120, 60, 40);
    [cancelBut setTitle:@"取消"forState:UIControlStateNormal];
    cancelBut.titleLabel.font = [UIFont systemFontOfSize: 21];
    [cancelBut addTarget:self action:@selector(CancelButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelLine=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, 120+5, 1, 30)];
    labelLine.backgroundColor=[UIColor whiteColor];
    
    UIButton *fasongBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fasongBut.frame = CGRectMake(210, 120, 60, 40);
    [fasongBut setTitle:@"确定"forState:UIControlStateNormal];
    fasongBut.titleLabel.font = [UIFont systemFontOfSize: 21];
    [fasongBut addTarget:self action:@selector(OKButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    editView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 160)];
    editView.backgroundColor =[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1];
    [self.view addSubview:editView];
    [editView addSubview:password];
    
    [editView addSubview:cancelBut];
    [editView addSubview:fasongBut];
    [editView addSubview:wifiname];
    [editView addSubview:wifiStr];
    [editView addSubview:passname];
    [editView addSubview:labelLine];
    
    [self editpassWord];
    WiFiListTable.hidden= YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)editpassWord
{
    editView.hidden = NO;
    [self.view bringSubviewToFront:editView];
    [password becomeFirstResponder];
}

-(void)OKButtonclicked:(UIButton *)sender{
    NSLog(@"确定按钮点击了");
    [password resignFirstResponder];
    WiFiListTable.hidden = NO;
    
    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
    
    [self connectToSecondScrver:TCP_IP port:TCP_PORT];
    
    
    ssidLength =[SSIDString length];
    pswLength =[password.text length];
    if (password.text.length<8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_SSID", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil];
        [alert show];
    }else if (password.text.length>=8){
        //选择确定后 保存用户名和密码
        NSUserDefaults *UserDefaults = [NSUserDefaults  standardUserDefaults];
        //保存数据
        [UserDefaults setObject:password.text  forKey:@"WifiuserInfo"];
        
        [UserDefaults synchronize];
        
        UIView * hudview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        hudview.backgroundColor =[UIColor grayColor];
        hud_set =[[MBProgressHUD alloc] initWithView:hudview];
        hud_set.labelText = NSLocalizedStringFromTable(@"HUD_Connect", @"Locale", nil); //正在配置，请稍等
        [hud_set show:YES];
        [self.view addSubview:hud_set];
        
        NSDictionary *ifs = [self fetchSSIDInfo];
        NSString *ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
        NSLog(@"ssid:%@,SSIDString:%@",ssid,SSIDString);
        NSLog(@"SSIDString:%@,password:%@",SSIDString,password.text);
        
        if ([ssid hasPrefix:@"inlit_w101"]){
            NSArray *tempArr=[SSIDString componentsSeparatedByString:@","];
            NSMutableString *tempStr;
            if ([tempArr count]==4) {
                tempStr=[[NSMutableString alloc]initWithString:[tempArr objectAtIndex:0]];
            }else if([tempArr count]<4){
                tempStr=[NSMutableString stringWithString:SSIDString];
            }else{
                for (int i=0; i<[tempArr count]; i++) {
                    if (i<[tempArr count]-3) {
                        [tempStr appendString:[tempArr objectAtIndex:i]];
                    }
                }
            }
            //添加指示，判断转换是否超时或成功，超时或成功则 消失
            NSData *writeData= [[NSString stringWithFormat:@"{(AP2STA)(%@)(%@)}",tempStr,password.text] dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"--------------%@",[NSString stringWithFormat:@"{(AP2STA)(%@)(%@)}",tempStr,password.text]);
            if (broadcastAddress!=nil) {
                NSLog(@"单个控制时的网关地址---%@",broadcastAddress);
                [UdpSocket sendData:writeData toHost:broadcastAddress port:988 withTimeout:-1 tag:0]; //对网关
            }
        }else{
            NSMutableString *wifisetting =[[NSMutableString  alloc]initWithString:@"POST /goform/ser2netconfigAT HTTP/1.1\r\nHost: 192.168.16.254\r\nConnection: keep-alive\r\nAuthorization: Basic YWRtaW46YWRtaW4=\r\nContent-Length:＊\r\n\r\nGet_MAC=?&netmode=2&wifi_conf=@,wpa2_aes,#&RstaChe=1&net_commit=1&out_trans=0"];
            NSInteger  allLength =75+ssidLength+pswLength;
            NSString *tempUrl =[NSString stringWithFormat:@"%ld",(long)allLength];
            NSString *strUrl = [wifisetting stringByReplacingOccurrencesOfString:@"＊" withString:tempUrl];
            NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"@" withString:SSIDString];
            NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@"#" withString:password.text];
            NSData *wifiData= [strUrl2 dataUsingEncoding:NSUTF8StringEncoding];
            [secondClient writeData:wifiData withTimeout:-1 tag:0];
        }
        //并恢复导航栏
        self.navigationController.navigationBarHidden = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    //关闭键盘
    NSLog(@"点击甲盘done按钮");
    [self OKButtonclicked:nil];
    return YES;
}
-(void)CancelButtonclicked:(UIButton *)sender{
    WiFiListTable.hidden = NO;
    [password resignFirstResponder];
    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
}
// 根据键盘状态，调整editView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        editView.center = CGPointMake(editView.center.x, keyBoardEndY- editView.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度

    }];
}

#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    if (sock==client) {
        [client readDataWithTimeout:-1 tag:0];
        NSLog(@"扫描wifi SSID：%@-----,%d",host,port);
    }else if (sock ==secondClient){
        [secondClient readDataWithTimeout:-1 tag:0];
        NSLog(@"AP->STA :second通讯:%@-----,second =%d",host,port);
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    //从ap模式转到sta模式，则该socket会断开链接
    if (sock==secondClient) {
        [hud_set removeFromSuperview];
        hud_set=nil;
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"设定完成" message:@"在网络模式下，您可以扫描到已入网的设备，请点击“确定”按钮，进入设备列表重新扫描，如密码错误，则不会显示设备" delegate:self cancelButtonTitle:@" 确定" otherButtonTitles:nil, nil];
        [alert show];
        
        [secondClient setDelegate:nil];
        secondClient =nil;
        NSLog(@"Error：secondClient断开链接");
    }else if(sock==client){
        [self stringUtil];//字符串数组的处理
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if (sock==secondClient) {
        NSLog(@" secondClient DidDisconnect");
        //断开后及时销毁
        [secondClient setDelegate:nil];
        secondClient =nil;
    }else{
        //断开后及时销毁
        [client setDelegate:nil];
        client =nil;
        NSLog(@"Client DidDisconnect22222");
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (sock==client) {
        aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [client readDataWithTimeout:-1 tag:0];
        
        Doarray =[[NSMutableArray alloc] initWithCapacity:30];
        [Doarray addObject:aStr];
    }else if (sock ==secondClient){
        [secondClient readDataWithTimeout:-1 tag:0];
        NSLog(@"AP转STA datas is :%@",aStr);
    }
}

-(void)stringUtil
{
    [hud_set removeFromSuperview];
    hud_set=nil;
    
    if (Doarray.count==0) {
        NSLog(@"空数组");
        return;
    }else{
        NSMutableString *ssss=[NSMutableString stringWithFormat:@"%@",[Doarray objectAtIndex:0]];
        NSLog(@"原始数据ssss:%@",ssss);
        NSRange rangeStr=[ssss rangeOfString:@"Ch  SSID                             BSSID               Security               Siganl()W-Mode  ExtCH  NT WPS DPID"];
        NSLog(@"========:%lu,%lu",(unsigned long)rangeStr.location,(unsigned long)rangeStr.length);
        if (rangeStr.length>0) {
            [ssss deleteCharactersInRange:NSMakeRange(0,rangeStr.location+rangeStr.length)];
        }else{
            return;
        }
       
        [WIFIList removeAllObjects];
        for (int i=0; i<ssss.length/117;i++ ) {
            NSRange strRange={6+i*117,30};
            NSString *rountStr=[[ssss substringWithRange:strRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSLog(@"%@,%lu", rountStr,(unsigned long)[rountStr length]);
            if (rountStr.length!=0) {
                [WIFIList addObject:rountStr];
            }
        }
        NSLog(@"%@",WIFIList);
        [WiFiListTable reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:WIFIList forKey:@"WIFIArray"];
    }
}

#pragma mark - 获取当前设备的名称BSSID，ssid
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

-(void)viewDidDisappear:(BOOL)animated
{
    [secondClient setDelegate:nil];
    secondClient =nil;
}

#pragma mark - AsyncUdpSocket Delegate  广播代理

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString* Udpinfo=[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    NSLog(@"收到UDP数据:%@",Udpinfo);
    if ([Udpinfo hasPrefix:@"{(+SCAN)"]) {//是否是返回的扫描结果
        if (hud_set!=nil) {
            [hud_set removeFromSuperview];
            hud_set=nil;
        }
        if ([Udpinfo length]>10) {//返回数据中是否有热点
            NSMutableString *tempStr=[[NSMutableString alloc]initWithString:[Udpinfo substringFromIndex:9]];
            tempStr=(NSMutableString*)[tempStr substringToIndex:[tempStr length]-2];
            NSArray *scanResultArr=[tempStr componentsSeparatedByString:@")("];
            WIFIList=[NSMutableArray arrayWithArray:scanResultArr];
            
            for (int i=0; i<[WIFIList count]; i++) {
                NSArray *tempArr=[[WIFIList objectAtIndex:i] componentsSeparatedByString:@","];
                NSMutableString *Str;
                if ([tempArr count]==4) {
                    Str=[[NSMutableString alloc]initWithString:[tempArr objectAtIndex:0]];
                    [WIFIList replaceObjectAtIndex:i withObject:Str];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:WIFIList forKey:@"WIFIArray"];
            [WiFiListTable reloadData];
        }
    }else if ([Udpinfo isEqualToString:@"{(+AP2STA)(OK)}"]){
        [hud_set removeFromSuperview];
        hud_set=nil;
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"设定完成" message:@"在网络模式下，您可以扫描到已入网的设备，请点击“确定”按钮，进入设备列表重新扫描，如密码错误，则不会显示设备" delegate:self cancelButtonTitle:@" 确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [sock receiveWithTimeout:-1 tag:0];
    return YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"WifiListUDP无法接收数据:%@",error);
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag

{
    NSLog(@"UDP数据已发送: %ld",(long)tag);
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"无法发送数据");
}

@end
