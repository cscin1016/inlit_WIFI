//
//  TimerVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "TimerVC.h"
#import "TimerCell.h"
#import "ViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface TimerVC ()
{
    UIDatePicker *datePick;
    NSMutableArray *dateArray;
    
    NSUserDefaults *userDefaults;
    
    NSInteger editRow;
    NSInteger lastSelectRow;
    
    float returnColorRed;
    float returnColorGreen;
    float returnColorBlue;
    
    UIView *colorView;
    UIImageView *colorImage;
    UIImageView *imageTip;
    UIButton *SelectOverBtn;
    
    NSTimer * timer;
    NSTimer * timer1;
    NSTimer * timer2;
    
    NSInteger timeID;
    NSInteger timeFlag;
    
}

@end

@implementation TimerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//获取当前时间
- (NSString *)getCurrentTime
{
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"dd/MM/yyyy hh:mm:ss"];
    return  [formatter stringFromDate:dateNow];
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedStringFromTable(@"TITLE_Timer", @"Locale", nil);
    NSLog(@"定时功能");
    
    UIBarButtonItem *mySearchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addTimerAction)];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:mySearchButton, nil];
    self.navigationItem.rightBarButtonItems = myButtonArray;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton];
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    datePick=[[UIDatePicker alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+0, 0, 320, 216)];
    [datePick setTimeZone: [NSTimeZone systemTimeZone]];
    [datePick setMinimumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePick setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePick addTarget:self action:@selector(changeDateAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePick];
    
    dateArray=[[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:@"timerDateArray"]];
    NSLog(@"dateArray==%@",dateArray);
    TimerTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, datePick.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-datePick.frame.size.height-64) style:UITableViewStylePlain];
    
    TimerTableView.backgroundColor=[UIColor clearColor];
    TimerTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TimerTableView.dataSource=self;
    TimerTableView.delegate=self;
    
    [self.view addSubview:TimerTableView];
    
    [TimerTableView reloadData];
//    TimerTableView.contentSize=CGSizeMake(320, [dateArray count]*88);
}

//发送校验时间值，即系统时间
-(void)delayMethod
{  TcpClient*tcp= [TcpClient sharedInstance];
    NSString *DataStr=[self getCurrentTime];
    NSLog(@"系统时间DataStr==%@",DataStr);
    char strtime[8]={'s','*','*','*','*','*','*','e'};
    NSDate *nowdate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    //当前的时分秒获得
    comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                        fromDate:nowdate];
    NSInteger year =[comps year];
    NSInteger monch= [comps month];
    NSInteger day =[comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    
    
    strtime[1]= (year-2000)/10*16+(year-2000)%10;//年
    strtime[2]=monch/10*16+monch%10;//月
    strtime[3]=day/10*16+day%10;//日
    strtime[4]=hour/10*16+hour%10;//时
    strtime[5]=minute/10*16+minute%10;//分
    strtime[6]=second/10*16+second%10;//秒
    NSData *timeData = [NSData dataWithBytes:strtime length:8];
    [tcp writeData:timeData];
    
    NSLog(@"校验时间＝%d ,%d ,%d,%d ,%d ,%d",strtime[1],strtime[2],strtime[3],strtime[4],strtime[5],strtime[6]);
}

#pragma mark - //时间选择器事件
-(void)changeDateAction{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyyMMddHHmmss"];
    NSString *localeDateStr=[formatter stringFromDate:datePick.date];
    [formatter setDateFormat : @"dd/MM/yyyy hh:mm:ss"];
    NSString *time=[formatter stringFromDate:datePick.date];
    if (editRow>=0) {
        if (editRow!=-1) {
            //得到editRow.row该行的数据
            NSMutableDictionary *TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:editRow]];
            [TemDic setObject:localeDateStr forKey:@"date"];
            [TemDic setObject:time forKey:@"time"];
            //替换之前的数据，TimerTableView刷新
            [dateArray replaceObjectAtIndex:editRow withObject:TemDic];
            [userDefaults setObject:dateArray forKey:@"timerDateArray"];
            [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:editRow inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            //得到editRow.row该行的数据
            NSMutableDictionary *TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:[dateArray count]-1]];
            [TemDic setObject:localeDateStr forKey:@"date"];
            [TemDic setObject:time forKey:@"time"];
            //替换之前的数据，TimerTableView刷新
            [dateArray replaceObjectAtIndex:[dateArray count]-1 withObject:TemDic];
            [userDefaults setObject:dateArray forKey:@"timerDateArray"];
            [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[dateArray count]-1 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else
        NSLog(@"bbbbbbbb");
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"视图要显示时 开始定时");
    editRow=lastSelectRow=-1;
    
    userDefaults= [NSUserDefaults standardUserDefaults];
    //  检验时间
    TcpClient *tcp = [TcpClient sharedInstance];
    
    if(tcp.currentArray.count)
    {
        //时间校验
        char strcommand[8]={'s','i','t','*','*','*','#','e'};
        
        strcommand[6] =160;                                                   //160，0xa0
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        NSLog(@"时间校验－－－－－");
    }
}
#pragma mark - //增加定时器
-(void)addTimerAction{
    if ([dateArray count]>4) {
        return;
    }
    //获得当前UIPickerDate所在的时间
    NSDate *selected = [datePick date];
    NSDate *sinceDate=[NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyyMMddHHmmss"];
    NSString *localeDateStr=[formatter stringFromDate:selected];
    
    [formatter setDateFormat : @"dd/MM/yyyy hh:mm:ss"];
    NSString *time=[formatter stringFromDate:selected];
    //时间选取器的时间要比系统时间大
    if ([selected timeIntervalSinceDate:sinceDate]>0) {
        NSInteger tempReg =[userDefaults integerForKey:@"reg"];
        NSInteger tempGreen   =[userDefaults integerForKey:@"green"];
        NSInteger tempBlue    =[userDefaults integerForKey:@"blue"];
        NSInteger tempWhite   =(int)[userDefaults integerForKey:@"white"];
        //通道数0-1-2-3-4
        NSInteger commandId=[dateArray count];
        
        for (int i=0; i<[dateArray count]; i++) {
            for (int j=0; j<[dateArray count]; j++) {
                if ([[[dateArray objectAtIndex:j] objectForKey:@"commandId"] intValue]==i) {
                    break;
                }else if (j==[dateArray count]-1){
                    commandId=i;
                    break;
                }
            }
        }
        //commandId:通道ID，1-5
        //status:当前状态，0：定时关，1：定时开，2：取消定时
        NSMutableDictionary *timerTemDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:localeDateStr,@"date",time,@"time",[NSNumber numberWithInteger:commandId],@"commandId",@"0",@"status",[NSNumber numberWithInteger:tempReg],@"red",[NSNumber numberWithInteger:tempGreen],@"green",[NSNumber numberWithInteger:tempBlue],@"blue",[NSNumber numberWithInteger:tempWhite],@"white",nil];
        [dateArray addObject:timerTemDic];
        NSLog(@"timerTemDic=%@",timerTemDic);
        
        [TimerTableView reloadData];
        [userDefaults setObject:dateArray forKey:@"timerDateArray"];
        TimerTableView.contentSize=CGSizeMake(320, [dateArray count]*88);
        //初始时默认 开关是关的。
        [self RTC_ALARM_OFF:localeDateStr];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"Timer_Disabled", @"Locale", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}
#pragma mark - //定时开命令
-(void)RTC_ALARM_ON:(NSString*)DataStr{
    //  检验时间
    TcpClient* tcp = [TcpClient sharedInstance];
    
    if(tcp.currentArray.count)
    {
        //得到editRow.row该行的数据
        NSMutableDictionary *TemDic=[dateArray objectAtIndex:editRow];
        timeID =[[TemDic objectForKey:@"commandId"] intValue];
        timeFlag =[[TemDic objectForKey:@"status"] intValue];
        NSLog(@"开开开开");
        char strstate1[8]={'s','a','n','*','*','*','*','e'};
        
        strstate1[3]=timeID;
        strstate1[4]=1;
        strstate1[6]=160;
        NSData *onOffData = [NSData dataWithBytes:strstate1 length:8];
        [tcp writeData:onOffData];
        
        timer1 =[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(sendOnData) userInfo:nil repeats:NO];
        NSLog(@"发送on时间");
    }
}

#pragma mark - //定时关
-(void)RTC_ALARM_OFF:(NSString*)DataStr{
    //  检验时间
   TcpClient *tcp = [TcpClient sharedInstance];
    NSMutableDictionary *TemDic=nil;
    //得到editRow.row该行的数据
    if(editRow!=-1)
    {
        TemDic=[dateArray objectAtIndex:editRow];
    }else{
        TemDic=[dateArray objectAtIndex:[dateArray count]-1];
    }
    timeID =[[TemDic objectForKey:@"commandId"] intValue];
    timeFlag =[[TemDic objectForKey:@"status"] intValue];
    
    char strstate[8]={'s','a','f','*','*','*','*','e'};
    strstate[3]=timeID;
    strstate[4]=1;
    strstate[6]=160;
    NSData *onOffData = [NSData dataWithBytes:strstate length:8];
    [tcp writeData:onOffData];
    timer2 =[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(sendOffData) userInfo:nil repeats:NO];
}

#pragma mark - /发送定时开时间值
-(void)sendOnData
{
    TcpClient *tcp = [TcpClient sharedInstance];
    ///定时时间
    //获取设定的时间
    NSString *timeString=nil;
    if(editRow!=-1)
    {
        timeString= [[dateArray objectAtIndex:editRow] objectForKey:@"date"];
    }else
    {
        timeString= [[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"date"];
    }
    
    
    NSLog(@"timeString>>==%@",timeString);
    int year,monch,day,hour,minute,second;
    year=  [[timeString substringWithRange:NSMakeRange(2, 2)] intValue];
    monch=  [[timeString substringWithRange:NSMakeRange(4, 2)] intValue];
    day=  [[timeString substringWithRange:NSMakeRange(6, 2)] intValue];
    hour=  [[timeString substringWithRange:NSMakeRange(8, 2)] intValue];
    minute=  [[timeString substringWithRange:NSMakeRange(10, 2)] intValue];
    second=  [[timeString substringWithRange:NSMakeRange(12, 2)] intValue];
    NSLog(@"年＝%d,月＝%d, 日＝%d, 时＝%d, 分＝%d, 秒＝%d" ,year,monch,day,hour,minute,second);
    char onOfftime[8]={'s','*','*','*','*','*','*','e'};
    onOfftime[1]=  year/10*16+year%10;//年
    onOfftime[2]=monch/10*16+monch%10;//月
    onOfftime[3]=day/10*16+day%10;//日
    onOfftime[4]=hour/10*16+hour%10;//时
    onOfftime[5]=minute/10*16+minute%10;//分
    onOfftime[6]=second/10*16+second%10;//秒
    
    NSLog(@"定时开时间：-----%d,----%d,--%d,-----%d,----%d,--%d",onOfftime[1],onOfftime[2],onOfftime[3],onOfftime[4],onOfftime[5],onOfftime[6]);
    NSData *onOffTime = [NSData dataWithBytes:onOfftime length:8];
    [tcp writeData:onOffTime];
   
    [self performSelector:@selector(sendColorData) withObject:nil afterDelay:0.3];
    
}


#pragma mark -  //发送定时关时间值
-(void)sendOffData
{
    TcpClient *tcp = [TcpClient sharedInstance];
    ///定时时间
    //获取设定的时间
    NSString *timeString=nil;
    if(editRow!=-1)
    {
        timeString= [[dateArray objectAtIndex:editRow] objectForKey:@"date"];
    }else
    {
        timeString= [[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"date"];
    }
    
    
    NSLog(@"timeString>>==%@",timeString);
    int year,monch,day,hour,minute,second;
    year=  [[timeString substringWithRange:NSMakeRange(2, 2)] intValue];
    monch=  [[timeString substringWithRange:NSMakeRange(4, 2)] intValue];
    day=  [[timeString substringWithRange:NSMakeRange(6, 2)] intValue];
    hour=  [[timeString substringWithRange:NSMakeRange(8, 2)] intValue];
    minute=  [[timeString substringWithRange:NSMakeRange(10, 2)] intValue];
    second=  [[timeString substringWithRange:NSMakeRange(12, 2)] intValue];
    NSLog(@"年＝%d,月＝%d, 日＝%d, 时＝%d, 分＝%d, 秒＝%d" ,year,monch,day,hour,minute,second);
    char onOfftime[8]={'s','*','*','*','*','*','*','e'};
    onOfftime[1]=  year/10*16+year%10;//年
    onOfftime[2]=monch/10*16+monch%10;//月
    onOfftime[3]=day/10*16+day%10;//日
    onOfftime[4]=hour/10*16+hour%10;//时
    onOfftime[5]=minute/10*16+minute%10;//分
    onOfftime[6]=second/10*16+second%10;//秒
    
    NSLog(@"定时关时间：-----%d,----%d,--%d,-----%d,----%d,--%d",onOfftime[1],onOfftime[2],onOfftime[3],onOfftime[4],onOfftime[5],onOfftime[6]);
    NSData *onOffTime = [NSData dataWithBytes:onOfftime length:8];
    [tcp writeData:onOffTime];
    
}
#pragma mark - //发送颜色值
-(void)sendColorData
{
    TcpClient *tcp = [TcpClient sharedInstance];
    int tempReg ;
    int tempGreen;
    int tempBlue;
    int tempWhite;
    if(tcp.currentArray.count)
    {
        NSLog(@"设定颜色");
        if(editRow!=-1)
        {
            tempReg = [[[dateArray objectAtIndex:editRow] objectForKey:@"red"] intValue];
            tempGreen = [[[dateArray objectAtIndex:editRow] objectForKey:@"green"] intValue];
            tempBlue = [[[dateArray objectAtIndex:editRow] objectForKey:@"blue"] intValue];
            tempWhite = [[[dateArray objectAtIndex:editRow] objectForKey:@"white"] intValue];
        }else{
            
            tempReg = [[[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"red"] intValue];
            tempGreen = [[[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"green"] intValue];
            tempBlue = [[[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"blue"] intValue];
            tempWhite = [[[dateArray objectAtIndex:[dateArray count]-1] objectForKey:@"white"] intValue];
        }
        
        
        char onOfftime[8]={'s','r','g','b','w','B','#','e'};
        onOfftime [3] =tempReg;
        onOfftime [2] =tempGreen ;
        onOfftime [1] =tempBlue;
        onOfftime [4] =tempWhite;
        onOfftime[6]=0xa0;
        NSLog(@"设定颜色值：tempReg＝%d, tempGreen =%d, tempBlue =%d,  tempWhite =%d, ",tempReg,tempGreen,tempBlue,tempWhite);
        NSData *onOffTime = [NSData dataWithBytes:onOfftime length:8];
        [tcp writeData:onOffTime];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dateArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TimerCell *cell = (TimerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[TimerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.contentView.tag=10000;
    if (indexPath.row==editRow&&editRow>=0) {
        cell.segment.hidden=NO;
        cell.operationLabel.hidden=YES;
        cell.backgroundColor=[UIColor colorWithRed:27/255.0 green:95/255.0 blue:115/255.0 alpha:1];
        [cell.segment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
        cell.titleImage.enabled=YES;
        [cell.titleImage addTarget:self action:@selector(showColorSelect) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.segment.hidden=YES;
        cell.operationLabel.hidden=NO;
        cell.backgroundColor=[UIColor clearColor];
        cell.titleImage.enabled=NO;
    }
    
    cell.timeLabel.text=[[dateArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    cell.timeLabel.backgroundColor =[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([[[dateArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue]==1) {
        int red=[[[dateArray objectAtIndex:indexPath.row] objectForKey:@"red"] intValue];
        int green=[[[dateArray objectAtIndex:indexPath.row] objectForKey:@"green"] intValue];
        int blue=[[[dateArray objectAtIndex:indexPath.row] objectForKey:@"blue"] intValue];
        cell.titleImage.backgroundColor=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    }else{
        cell.titleImage.backgroundColor=[UIColor blackColor];
    }
    
    cell.segment.selectedSegmentIndex = [[[dateArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue];
    
    
    
    
    if ([[[dateArray objectAtIndex:indexPath.row] objectForKey:@"status"]intValue]==0)
    {
        NSString* string1=NSLocalizedStringFromTable(@"Timer_Channel_OFF", @"Locale", nil);
        NSString*   string2= [NSString stringWithFormat:@"%@",[[dateArray objectAtIndex:indexPath.row] objectForKey:@"commandId"]];
        
        cell.operationLabel.text=[string1 stringByAppendingString:string2];
        cell.operationLabel.backgroundColor=[UIColor clearColor];
    }
    else if ([[[dateArray objectAtIndex:indexPath.row] objectForKey:@"status"]intValue]==1)
    {
        NSString* string1=NSLocalizedStringFromTable(@"Timer_Channel_ON", @"Locale", nil);
        NSString*   string2= [NSString stringWithFormat:@"%@",[[dateArray objectAtIndex:indexPath.row] objectForKey:@"commandId"]];
        cell.operationLabel.text=[string1 stringByAppendingString:string2];;
        cell.operationLabel.backgroundColor=[UIColor clearColor];
    }
//    else
//    {
//        cell.operationLabel.text=[NSString stringWithFormat:@"取消定时,通道:%@",[[dateArray objectAtIndex:indexPath.row] objectForKey:@"commandId"]];
//    }
    
    
    return cell;
}
-(void)showColorSelect{
    
    colorView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64)];
    colorView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    
    colorImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"color_pl"]];
    colorImage.frame=CGRectMake(40, 100, 240, 240);
    [colorView addSubview:colorImage];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [colorView addGestureRecognizer:tapGesture];
    
    
    imageTip=[[UIImageView alloc]initWithFrame:CGRectMake(120, 140, 14, 13)];
    imageTip.image=[UIImage imageNamed:@"color_cursor"];
    [colorView addSubview:imageTip];
    
    
    
    SelectOverBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    SelectOverBtn.frame=CGRectMake(60, 40, 200, 40);
    SelectOverBtn.layer.cornerRadius =5;
    [SelectOverBtn addTarget:self action:@selector(selectColorOver) forControlEvents:UIControlEventTouchUpInside];
    [SelectOverBtn setTitle:NSLocalizedStringFromTable(@"Timer_Color", @"Locale", nil) forState:UIControlStateNormal];
    
    [colorView addSubview:SelectOverBtn];
    
    [self.view addSubview:colorView];
}
-(void)selectColorOver{
    [colorView removeFromSuperview];
    NSMutableDictionary *TemDic= nil;
    
    if(editRow!=-1)
    {
        TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:editRow]];
        [dateArray replaceObjectAtIndex:editRow withObject:TemDic];
        [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:editRow inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
    }else{
        TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:[dateArray count]-1]];
        [dateArray replaceObjectAtIndex:[dateArray count]-1 withObject:TemDic];
        [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[dateArray count]-1 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [TemDic setObject:[NSNumber numberWithFloat:returnColorRed] forKey:@"red"];
    [TemDic setObject:[NSNumber numberWithFloat:returnColorGreen] forKey:@"green"];
    [TemDic setObject:[NSNumber numberWithFloat:returnColorBlue] forKey:@"blue"];
    
    [userDefaults setObject:dateArray forKey:@"timerDateArray"];
    [TimerTableView reloadData];
    if (editRow!=-1&&editRow<[dateArray count]) {
        if ([[[dateArray objectAtIndex:editRow] objectForKey:@"status"] intValue]==1) {
            [self selectmyView2];
            [self performSelector:@selector(sendColorData) withObject:nil afterDelay:0.3];
        }
    }
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    if (editRow!=-1) {
        NSMutableDictionary * TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:editRow]];
        
        
        [TemDic setObject:[NSNumber numberWithInteger:Index] forKey:@"status"];
        [dateArray replaceObjectAtIndex:editRow withObject:TemDic];
        [userDefaults setObject:dateArray forKey:@"timerDateArray"];
        
        [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:editRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSMutableDictionary * TemDic=[NSMutableDictionary dictionaryWithDictionary:[dateArray objectAtIndex:[dateArray count]-1]];
        
        
        [TemDic setObject:[NSNumber numberWithInteger:Index] forKey:@"status"];
        [dateArray replaceObjectAtIndex:[dateArray count]-1 withObject:TemDic];
        [userDefaults setObject:dateArray forKey:@"timerDateArray"];
        
        [TimerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[dateArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    switch (Index) {
        case 0:
            
            [self selectmyView1];
            break;
        case 1:
            [self selectmyView2];
            break;
            default:
            break;
    }
}
//定时关
-(void)selectmyView1{
    NSLog(@"定时关off");
    
    [self RTC_ALARM_OFF:[[dateArray objectAtIndex:editRow] objectForKey:@"date"]];
    NSLog(@"[dateArray objectAtIndex:editRow] =%@",[[dateArray objectAtIndex:editRow] objectForKey:@"date"]);
}
//定时开
-(void)selectmyView2{
    NSLog(@"定时开on");
    
    [self RTC_ALARM_ON:[[dateArray objectAtIndex:editRow] objectForKey:@"date"]];
    
    NSLog(@"[dateArray objectAtIndex:editRow] =%@",[[dateArray objectAtIndex:editRow] objectForKey:@"date"]);
}
//取消定时
-(void)selectmyView3{
    TcpClient *tcp = [TcpClient sharedInstance];
    NSLog(@"取消定时");
    //判断该定时是属于什么状态，status的值,0关， 1开，然后根据status的值发送取消开的命令或取消关的命令
    int status;
    NSMutableDictionary *TemDic=nil;
    //得到editRow.row该行的数据
    if(editRow!=-1)
    {
        TemDic=[dateArray objectAtIndex:editRow];
    }else{
        TemDic=[dateArray objectAtIndex:[dateArray count]-1];
    }
    timeID =[[TemDic objectForKey:@"commandId"] intValue];
    status =[[TemDic objectForKey:@"status"] intValue];
    
    if (status==0) {
        NSLog(@"定时属于“关”的状态------发送取消");
        char onstate[8]={'s','a','f','*','*','*','*','e'};
        onstate[3]=timeID;
        onstate[4]=0;
        onstate[6]=160;
        NSData *onData = [NSData dataWithBytes:onstate length:8];
        [tcp writeData:onData];
    }
    if (status==1) {
        NSLog(@"定时属于“开”的状态------，发送取消");
        char offstate[8]={'s','a','n','*','*','*','*','e'};
        offstate[3]=timeID;
        offstate[4]=0;
        offstate[6]=160;
        NSData *OffData = [NSData dataWithBytes:offstate length:8];
        [tcp writeData:OffData];
    }
    
    
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self selectmyView3];
        [dateArray removeObjectAtIndex:indexPath.row];
         editRow=lastSelectRow=-1;
        NSLog(@"删除后的dateArray%@",dateArray);
        
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [userDefaults setObject:dateArray forKey:@"timerDateArray"];
        [TimerTableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lastSelectRow=editRow;
    editRow=indexPath.row;
    
    if (lastSelectRow>=0&&editRow>=0) {
        if (lastSelectRow==editRow) {
            
            lastSelectRow=editRow=-1;
            [TimerTableView reloadData];
            
            return;
        }
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:lastSelectRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:editRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (UIColor *)colorAtPixel:(CGPoint)point {
    point= CGPointMake(point.x,  point.y);
    
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(40.0f,100.0f, colorImage.bounds.size.width,colorImage.bounds.size.height), point)) {
        NSLog(@"不在区域");
        return nil;
    }
    
    NSInteger pointX = trunc(point.x-40);
    NSInteger pointY = trunc(point.y-100);
    CGImageRef cgImage = colorImage.image.CGImage;
    NSUInteger width = colorImage.bounds.size.width;
    NSUInteger height =colorImage.bounds.size.height;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast |kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context,kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] /255.0f;
    CGFloat green = (CGFloat)pixelData[1] /255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] /255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] /255.0f;
    
    returnColorRed=pixelData[0];
    returnColorGreen=pixelData[1];
    returnColorBlue=pixelData[2];
    
    
    
    SelectOverBtn.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
-(void)tapAction:(UITapGestureRecognizer*) tap {
    CGPoint p = [tap locationInView:tap.view];
    
    imageTip.center=p;
    [self colorAtPixel:p];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
