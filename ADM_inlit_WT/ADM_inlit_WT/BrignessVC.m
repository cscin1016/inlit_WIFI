//
//  BrignessVC.m
//  ADM_Lights
//
//  Created by admin on 14-3-7.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "BrignessVC.h"
#import "ViewController.h"
#import "EFCircularSlider.h"
#import "UIImage+Tint.h"

@interface BrignessVC ()
{
    EFCircularSlider *colorSlider;
    UIImage *imagecolor;
    UIImageView *lightImage;
    UIImageView *sanjiaoView;
    
    UIImageView *brignessImageView; //亮度圆圈
    
    float jiaodu;
    
    NSDate *LastSendTime;
    
    UISlider *whiteSlider;
    UIImageView *whiteSliderView;
    UIImageView *yuanquan;
    
    CGPoint starPoint;
    //标记亮度的改变
    int brignessFlat;
    //标记颜色的改变
    int colorFlat;
    
    UILabel * sewenlabel ;
    UILabel * whiteColorLabel;
    UIImageView *newSanjiao;
}

@end

@implementation BrignessVC
//@synthesize delegate;


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
    [formatter setDateFormat : @"MM-dd HH:mm"];
    return  [formatter stringFromDate:dateNow];
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedStringFromTable(@"TITLE_Color", @"Locale", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    brignessFlat =0;
    colorFlat=0;
    NSLog(@"色彩调节");
    
    LastSendTime= [[NSDate alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.tag=10000;
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    [self.view addSubview:imageView];
    
    //亮度圆圈
    UIImage *brignessImage = [UIImage imageNamed:@"yuan"];
    brignessImageView  = [[UIImageView alloc] initWithImage:brignessImage];
    brignessImageView.frame =CGRectMake(SCREENWIDTH/2-160-19, -2, 360, 350);
    brignessImageView.tag=10000;
    [self.view addSubview:brignessImageView];
    
    //三角图
    sanjiaoView= [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160-19, -2, 360, 350)];
    //    sanjiaoView.image = [UIImage imageNamed:@"sanjiao"];
    [self.view addSubview:sanjiaoView];
    sanjiaoView.transform=CGAffineTransformMakeRotation(-3.1415926*42/180);
    
    
    //显示多少亮度
    valueLabel =[[UILabel alloc] initWithFrame:CGRectMake(-10,180,48, 18)];
    valueLabel.backgroundColor=[UIColor blueColor];
    valueLabel.layer.cornerRadius=5.0;
    valueLabel.textAlignment  =NSTextAlignmentCenter;
    valueLabel.textColor =[UIColor whiteColor];
    valueLabel.font =[UIFont systemFontOfSize:14];
    valueLabel.text=@"1%";
    valueLabel.transform=CGAffineTransformMakeRotation(3.1415926*42/180);
    [sanjiaoView addSubview:valueLabel];
    
    //画图
    CGRect initr=CGRectMake(SCREENWIDTH/2-160+26, 34, 272, 272);
    drawView=[[draw_graphic alloc] initWithFrame:initr];
    drawView.opaque=YES;
    drawView.userInteractionEnabled=NO;
    drawView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:drawView];
    drawView.transform=CGAffineTransformMakeRotation(3.1415926*120/180);
    
    //调色版板图
    UIImage *colorImage = [UIImage imageNamed:@"color_pl"];
    UIImageView *colorImageView  = [[UIImageView alloc] initWithImage:colorImage];
    colorImageView.frame =CGRectMake(SCREENWIDTH/2-160+30,40, colorImage.size.width, colorImage.size.height);
    colorImageView.userInteractionEnabled = YES;
    [self.view addSubview:colorImageView];
    
    
    
    //滑动的圆圈
    UIImage *cursorImage =[UIImage imageNamed:@"color_cursor"];
    UIImageView *cursorImageView  = [[UIImageView alloc] initWithImage:cursorImage];
    cursorImageView.frame =CGRectMake(10,10, cursorImage.size.width, cursorImage.size.height);
    cursorImageView.userInteractionEnabled = YES;
 
    
    //白色开关按钮
    UIImage *minImage = [UIImage imageNamed:@"color_bulb__"];
    UIButton *offbt =[UIButton buttonWithType:UIButtonTypeCustom];
    [offbt setImage:minImage forState:UIControlStateNormal];
    offbt.frame =CGRectMake(SCREENWIDTH/2-160+colorImageView.frame.size.width/2+8,colorImageView.frame.size.height/2+14, minImage.size.width+20, minImage.size.height+20);
    [offbt addTarget:self action:@selector(offbtClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:offbt];
    
    
    //colorSlider颜色调节控制器
    CGRect minuteSliderFrame =CGRectMake(SCREENWIDTH/2-160+45,40, colorImage.size.width*0.7, colorImage.size.height*0.7);
    colorSlider = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    colorSlider.unfilledColor = [UIColor clearColor];
    colorSlider.filledColor = [UIColor clearColor];
    colorSlider.lineWidth = 8;
    colorSlider.minimumValue = 0;
    colorSlider.maximumValue = 360;
    colorSlider.labelColor = [UIColor colorWithRed:76/255.0f green:111/255.0f blue:137/255.0f alpha:1.0f];
    colorSlider.handleType = doubleCircleWithOpenCenter;
    colorSlider.handleColor = [UIColor whiteColor];
    [colorImageView addSubview:colorSlider];
    [colorSlider addTarget:self action:@selector(colorDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //冷暖白按钮调节
    UIButton *minBt =[UIButton buttonWithType:UIButtonTypeCustom];
    minBt.frame = CGRectMake(SCREENWIDTH/2-160+30, 340, 35, 35);
    [minBt setBackgroundImage:[UIImage imageNamed:@"暖黄"] forState:UIControlStateNormal];
    [minBt addTarget:self action:@selector(minBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:minBt];
    
    
    UIButton *maxBt =[UIButton buttonWithType:UIButtonTypeCustom];
    maxBt.frame = CGRectMake(SCREENWIDTH/2-160+255, 340, 35, 35);
    [maxBt setBackgroundImage:[UIImage imageNamed:@"冷白"] forState:UIControlStateNormal];
    [maxBt addTarget:self action:@selector(maxBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maxBt];
    
    //色温调节slider];
    whiteSliderView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"滑条"]];
    whiteSliderView.frame = CGRectMake(SCREENWIDTH/2-160+30, 385, 260, 26);
    [self.view addSubview:whiteSliderView];
    
    yuanquan =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"滑圈"]];
    yuanquan.frame = CGRectMake(0, 0, 26, 26);
    yuanquan.tag=101;
    yuanquan.userInteractionEnabled = YES;
    [whiteSliderView addSubview:yuanquan];
    
    /*
     冷暖白数据表：
     3000 ------ 6500
     R:  255         255
     G:  113         255
     B:  0           118
     W:  43          136
     
     */
    
}

-(void)draw{
    drawView.angle=drawView.angle+10;
    [drawView setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐
    
    if (point.y>0&&point.y<360) {
        int x = point.x;
        int y = point.y;
        NSLog(@"  x ＝＝%d ,  y ===%d",x,y);
        brignessFlat =1;
        [self touchDraw:x :y];
    }else if (point.y>=360){
        
        starPoint=point;
        NSLog(@"%0.0f ,  %0.0f",starPoint.x,starPoint.y);
        CGRect frame = yuanquan.frame;
        
        if (starPoint.y!=0) {
            starPoint.y=0;
        }
        if (starPoint.x<42) {
            starPoint.x=0;
            frame.origin.x = starPoint.x;
        }
        if (starPoint.x>=42&&starPoint.x<=277) {
            frame.origin.x = starPoint.x-42;
        }
        if (starPoint.x>277) {
            starPoint.x=277-42;  //235
            frame.origin.x = starPoint.x;
        }
        frame.origin.y = starPoint.y;
        yuanquan.frame = frame;
        
        NSLog(@"开始frame===%0.0f,,,,,,,%0.0f",frame.origin.x,frame.origin.y);
        
        
        TcpClient *tcp = [TcpClient sharedInstance];
        
        if(tcp.currentArray.count)
        {
            iReg =255;
            igreen=frame.origin.x*(255-113)/235+113;
            iBlue=frame.origin.x*(118-0)/235+0;
            iWhite=frame.origin.x*(136-43)/235+43;
            
            char str[8]={'s','r','g','b','w','B','#','e'};
            str [3] =iReg;
            str [2] =igreen;
            str [1] =iBlue;
            str [4] =iWhite;
            str[6] =0x93;  //209
            NSData *cmdData = [NSData dataWithBytes:str length:8];
            [tcp writeData:cmdData];
        }
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =iReg;
        saveChar [2] =igreen;
        saveChar [1] =iBlue;
        saveChar [4] =iWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
    }
}

-(void)touchDraw:(int)x :(int)y{
    
    if (x==162&&y>190) {
        return;
    }
    float jiaoduTem=atan((y-190)*1.0/(x-162))*180.0/3.1415926;
    NSLog(@"jiaoduTem得角度＝＝%f",jiaoduTem);

    if (x<=162) {
        jiaoduTem+=60;
    }else if(x>162){
        jiaoduTem+=240;
    }
    
    NSLog(@"jiaoduTem转换后得角度＝＝%f",jiaoduTem);
    
    if (jiaoduTem<1||jiaoduTem>306) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int liangdu =(int)(100*jiaoduTem/305);
    if (liangdu==0) {
        liangdu=1;
    }
    valueLabel.text =[NSString stringWithFormat:@"%d%%",liangdu];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%d",liangdu] forKey:@"brigness"];
    jiaodu=jiaoduTem;
    NSLog(@"现在得角度是==%f",jiaodu);
    if (jiaodu<1) {
        jiaodu++;
    }
    
    [self sendMessage];
}

-(void)sendMessage{
    sanjiaoView.transform=CGAffineTransformMakeRotation(3.1415926*(jiaodu-45)/180);
    valueLabel.transform=CGAffineTransformMakeRotation(-3.1415926*(jiaodu-45)/180);
    
    [drawView setNeedsDisplay];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger tempReg ;
    NSInteger tempGreen;
    NSInteger tempBlue;
    NSInteger tempWhite;
    
    TcpClient *tcp = [TcpClient sharedInstance];
    NSLog(@"to do");
    //    //判断是否开启白光YES 开
    if([userDefaults boolForKey:@"YesNO"]==YES)
    {
        
        tempReg     =[userDefaults integerForKey:@"reg1"];
        tempGreen   =[userDefaults integerForKey:@"green1"];
        tempBlue    =[userDefaults integerForKey:@"blue1"];
        tempWhite   =[userDefaults integerForKey:@"white1"];
        
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =(int)(((tempReg/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255);
        strcommand [2] =(int)(((tempGreen/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255);
        strcommand [1] =(int)(((tempBlue/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255);
        strcommand [4] =(((tempWhite/255.0)*jiaodu/305)*255);
        
        strcommand[6] =0x93;
        
        drawView.angle=jiaodu;
        drawView.red=(((tempWhite/255.0)*jiaodu/305)*255);
        drawView.green=(((tempWhite/255.0)*jiaodu/305)*255);;
        drawView.blue=(((tempWhite/255.0)*jiaodu/305)*255);
        [drawView setNeedsDisplay];
        
        if ([LastSendTime timeIntervalSinceNow]<-0.15) {
            LastSendTime=[[NSDate alloc]init];
        }else{
            return;
        }
        
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        
        [tcp writeData:cmdData];
        
        lastReg =(int)(((tempReg/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255);
        lastGreen =(int)(((tempGreen/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255);
        lastBlue =(int)(((tempBlue/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255);
        lastWhite =(((tempWhite/255.0)*jiaodu/305)*255);;
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =lastReg;
        saveChar [2] =lastGreen;
        saveChar [1] =lastBlue;
        saveChar [4] =lastWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
        
        
        
        
    }else if([userDefaults boolForKey:@"YesNO"]==NO)
    {
        
        //没有白光,只有RGB
        if ([userDefaults integerForKey:@"reg"]==0&&[userDefaults integerForKey:@"green"]==0&&[userDefaults integerForKey:@"blue"]==0) {
            tempReg=255;
            tempGreen=255;
            tempBlue=255;
            tempWhite=0;
            NSLog(@"三色全为0");
            
        }else
        {
            tempReg     =[userDefaults integerForKey:@"reg"];
            tempGreen   =[userDefaults integerForKey:@"green"];
            tempBlue    =[userDefaults integerForKey:@"blue"];
            tempWhite   =0;
            NSLog(@"三色有值");
        }
        
        
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255);
        strcommand [2] =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255);
        strcommand [1] =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255);
        strcommand [4] =tempWhite;
        
        strcommand[6] =0x93;
        drawView.angle=jiaodu;
        drawView.red=((tempWhite/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255;
        drawView.green=((tempWhite/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255;
        drawView.blue=((tempWhite/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255;
        [drawView setNeedsDisplay];
        
        if ([LastSendTime timeIntervalSinceNow]<-0.15) {
            LastSendTime=[[NSDate alloc]init];
        }else{
            return;
        }
        
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        
        [tcp writeData:cmdData];
        
        lastReg =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255);
        lastGreen =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255);
        lastBlue =(int)(((tempWhite/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255);
        lastWhite =tempWhite;
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =lastReg;
        saveChar [2] =lastGreen;
        saveChar [1] =lastBlue;
        saveChar [4] =lastWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
    }
}




-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    if (point.y>0&&point.y<360) {
        
        int x = point.x;
        int y = point.y;
        
        [self touchDraw:x :y];
    }else if (point.y>=360)
    {
        
        CGRect frame = yuanquan.frame;
        if (point.y!=0) {
            point.y=0;
        }
        if (point.x<42) {
            point.x=0;
            frame.origin.x = point.x;
        }
        if (point.x>=42&&point.x<=277) {
            frame.origin.x = point.x-42;
        }
        if (point.x>277) {
            point.x=277-42;
            frame.origin.x = point.x;
        }
        frame.origin.y = point.y;
        yuanquan.frame = frame;
        NSLog(@"移动位置:%0.0f ,,%0.0f",frame.origin.x ,frame.origin.y );
//        int temValue =frame.origin.x*(6500-3000)/235+3000;
        //        sewenlabel.text =[NSString stringWithFormat:@"%d色温",temValue];
        
        TcpClient *tcp = [TcpClient sharedInstance];
        
        if(tcp.currentArray.count)
        {
            
            
            iReg =255;
            igreen=frame.origin.x*(255-113)/235+113;
            iBlue=frame.origin.x*(118-0)/235+0;
            iWhite=frame.origin.x*(136-43)/235+43;
            
            char str[8]={'s','r','g','b','w','B','#','e'};
            str [3] =iReg;
            str [2] =igreen;
            str [1] =iBlue;
            str [4] =iWhite;
            str[6] =0x93;  //209
            NSData *cmdData = [NSData dataWithBytes:str length:8];
            [tcp writeData:cmdData];
        }
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =iReg;
        saveChar [2] =igreen;
        saveChar [1] =iBlue;
        saveChar [4] =iWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
    }
    
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    if (point.y>0&&point.y<360) {
        int x = point.x;
        int y = point.y;
        
        [self touchDraw:x :y];
        
        
    }else if (point.y>=360)
    {
        
        CGRect frame = yuanquan.frame;
        
        
        
        if (point.y!=0) {
            point.y=0;
        }
        if (point.x<42) {
            point.x=0;
            frame.origin.x = point.x;
            
        }
        if (point.x>=42&&point.x<=277) {
            frame.origin.x = point.x-42;
        }
        if (point.x>277) {
            point.x=277-42;
            frame.origin.x = point.x;
        }
        
        frame.origin.y = point.y;
        yuanquan.frame = frame;
        
        NSLog(@"离开frame===%0.0f,,,,,,,%0.0f",frame.origin.x,frame.origin.y);
        
        TcpClient *tcp = [TcpClient sharedInstance];
        
        if(tcp.currentArray.count)
        {
            
            
            iReg =255;
            igreen=frame.origin.x*(255-113)/235+113;
            iBlue=frame.origin.x*(118-0)/235+0;
            iWhite=frame.origin.x*(136-43)/235+43;
            
            char str[8]={'s','r','g','b','w','B','#','e'};
            str [3] =iReg;
            str [2] =igreen;
            str [1] =iBlue;
            str [4] =iWhite;
            str[6] =0x93;  //209
            NSData *cmdData = [NSData dataWithBytes:str length:8];
            [tcp writeData:cmdData];
        }
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =iReg;
        saveChar [2] =igreen;
        saveChar [1] =iBlue;
        saveChar [4] =iWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
    }
    
    
}


#pragma mark- 按钮点击
-(void)minBtClick
{
    NSLog(@"暖白");
    CGRect frame = yuanquan.frame;
    frame.origin.x=0;
    frame.origin.y=0;
    yuanquan.frame = frame;
    //    sewenlabel.text =@"3000色温";
    TcpClient *tcp = [TcpClient sharedInstance];
    if(tcp.currentArray.count)
    {
        //        int White,Reg,green,Blue;
        iReg =255;
        igreen=113;
        iBlue=0;
        iWhite=43;
        
        char str[8]={'s','r','g','b','w','B','#','e'};
        str [3] =iReg;
        str [2] =igreen;
        str [1] =iBlue;
        str [4] =iWhite;
        str[6] =0x93;  //209
        NSData *cmdData = [NSData dataWithBytes:str length:8];
        [tcp writeData:cmdData];
    }
    
    //保存颜色
    char saveChar[8]={'s','*','*','*','*','*','#','e'};
    saveChar [3] =iReg;
    saveChar [2] =igreen;
    saveChar [1] =iBlue;
    saveChar [4] =iWhite;
    saveChar [5] =0x00;
    saveChar[6] =0xd1;
    
    NSData *saveData = [NSData dataWithBytes:saveChar length:8];
    [tcp writeData:saveData];
    
    
}

-(void)maxBtClick
{
    NSLog(@"冷白");
    CGRect frame = yuanquan.frame;
    frame.origin.x=235;
    frame.origin.y=0;
    yuanquan.frame = frame;
    sewenlabel.text =@"6500色温";
    TcpClient *tcp = [TcpClient sharedInstance];
    
    if(tcp.currentArray.count)
    {
        //        int White,Reg,green,Blue;
        iReg =255;
        igreen=255;
        iBlue=118;
        iWhite=136;
        
        char str[8]={'s','r','g','b','w','B','#','e'};
        str [3] =iReg;
        str [2] =igreen;
        str [1] =iBlue;
        str [4] =iWhite;
        str[6] =0x93;  //209
        NSData *cmdData = [NSData dataWithBytes:str length:8];
        [tcp writeData:cmdData];
    }
    //保存颜色
    char saveChar[8]={'s','*','*','*','*','*','#','e'};
    saveChar [3] =iReg;
    saveChar [2] =igreen;
    saveChar [1] =iBlue;
    saveChar [4] =iWhite;
    saveChar [5] =0x00;
    saveChar[6] =0xd1;
    
    NSData *saveData = [NSData dataWithBytes:saveChar length:8];
    [tcp writeData:saveData];
    
}
#pragma mark -白色开关
-(void)offbtClick:(UIButton*)sender
{
    sender.selected=!sender.selected;
    TcpClient *tcp = [TcpClient sharedInstance];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    if(tcp.currentArray.count)
    //    {
    if (sender.selected) {
        isOff=YES;
        whiteColorLabel.text =@"白光已开";
        int iWhite1,iReg1,igreen1,iBlue1;
        iWhite1=255; //只有白光开
        iReg1 =0;
        igreen1=0;
        iBlue1=0;
        NSLog(@"开？？");
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg1;
        strcommand [2] =igreen1;
        strcommand [1] =iBlue1;
        strcommand [4] =iWhite1;
        strcommand[6] =0x91;  //209
        //            lightImage.image=imagecolor;
        
        NSLog(@"白光开？？ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg1,igreen1, iBlue1,iWhite1);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        
        
        drawView.red=(((iWhite1/255.0)*jiaodu/305)*255);
        drawView.green=(((iWhite1/255.0)*jiaodu/305)*255);;
        drawView.blue=(((iWhite1/255.0)*jiaodu/305)*255);
        [drawView setNeedsDisplay];
        lastReg =iReg1;
        lastGreen =igreen1;
        lastBlue =iBlue1;
        lastWhite =iWhite1;
        
        
        
        //保存当前的rgb的值
        [userDefaults setInteger:lastReg forKey:@"reg1"];
        [userDefaults setInteger:lastGreen forKey:@"green1"];
        [userDefaults setInteger:lastBlue forKey:@"blue1"];
        [userDefaults setInteger:lastWhite forKey:@"white1"];
        
    }else
    {
        
        
        isOff =NO;
        whiteColorLabel.text =@"白光已关";
        iWhite=0;  //白光关，使用RGB
        NSInteger tempReg;
        NSInteger tempGreen;
        NSInteger tempBlue;
        if (colorFlat==0) {
            tempReg     =255;
            tempGreen   =255;
            tempBlue    =255;
        }else
        {
            tempReg     =[userDefaults integerForKey:@"reg"];
            tempGreen   =[userDefaults integerForKey:@"green"];
            tempBlue    =[userDefaults integerForKey:@"blue"];

        }
        
        int jiaoduTemp =0;
        if (brignessFlat==0) {
            jiaoduTemp=305;
            
        }else
        {
            jiaoduTemp=(int)roundf(jiaodu);
             NSLog(@"关？？jiaoduTemp=%d",jiaoduTemp);
            if (jiaoduTemp==1) {
                jiaoduTemp=2;
            }
            NSLog(@"jiaoduTemp变成2＝%d",jiaoduTemp);
            
        }

        char strcommand[8]={'s','r','g','b','w','B','#','e'};

        strcommand [3] =tempReg*jiaoduTemp/305;
        strcommand [2] =tempGreen*jiaoduTemp/305;
        strcommand [1] =tempBlue*jiaoduTemp/305;
        strcommand [4] =iWhite;
        strcommand[6] =0x91;  //0xd1 保存
       
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        
        drawView.red=((0/255)*(1-jiaodu/305)+(tempReg/255.0)*jiaodu/305)*255;
        drawView.green=((0/255)*(1-jiaodu/305)+(tempGreen/255.0)*jiaodu/305)*255;
        drawView.blue=((0/255)*(1-jiaodu/305)+(tempBlue/255.0)*jiaodu/305)*255;
        [drawView setNeedsDisplay];
        
        
    }
    
    [userDefaults setBool:isOff forKey:@"YesNO"];
    //    }
}


-(void)colorDidChange:(EFCircularSlider*)slider {
    colorFlat =1;
    isOff =NO;
    whiteColorLabel.text =@"白光已关";
    //得到角度的值， 根据角度的值显示亮度
    
    
    newVal = (int)slider.currentValue <= 360 ? (int)slider.currentValue : 0;
    //数据发送
    
    //    valueLabel.text =[NSString stringWithFormat:@"%d",newVal];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    TcpClient *tcp = [TcpClient sharedInstance];
    NSLog(@"newVal====%d",newVal);
    
    NSLog(@"亮度标记＝＝%d",brignessFlat);
    
    
    
    
    if (brignessFlat==0) { //还没调过亮度0
        int jiaoduTemp =(int)roundf(jiaodu);
        NSLog(@"角度＝%d",jiaoduTemp);
        if (0<=newVal&&newVal<=45) {
            
            iReg=255,igreen=0;
            
            iBlue=(newVal)*255/45;        //0度到45度，蓝色的值改变增加
            
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (45<=newVal&&newVal<=135) {
            
            igreen =0;
            iBlue=255;
            
            iReg=(255-(newVal-45)*255/90);  //45度到135度，红色的值改变减小
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (135<=newVal&&newVal<=180) {
            
            iReg=0,iBlue=255;
            igreen=(newVal-135)*255/45;                         //135度到180度，绿色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (180<=newVal&&newVal<=225) {
            
            iReg=0,igreen=255;
            iBlue=255-(newVal-180)*255/45;                         //180度到225度，蓝色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
        }
        if (225<=newVal&&newVal<=315) {
            
            iBlue=0,igreen=255;
            iReg=(newVal-225)*255/90;                               //225度到315度，红色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (315<=newVal&&newVal<360)
        {
            
            iReg=255,iBlue=0;
            igreen=255-(newVal-315)*255/45;                         //315度到360度，绿色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =0;
            strcommand[6] =0x93;
            //            lightImage.image=[imagecolor imageWithTintColor:[UIColor colorWithRed:iReg/255.0 green:igreen/255.0 blue:iBlue/255.0 alpha:1.0]];
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.15) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        
        lastReg =iReg;
        lastGreen =igreen;
        lastBlue =iBlue;
        lastWhite =0;
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =lastReg;
        saveChar [2] =lastGreen;
        saveChar [1] =lastBlue;
        saveChar [4] =lastWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
        
    }
    
    
    
    
    
    
    if (brignessFlat==1) { //调过亮度了 1
        
        int jiaoduTemp =(int)roundf(jiaodu);
        if (jiaoduTemp==1) {
            jiaoduTemp=2;
        }
        NSLog(@"角度111111＝%d",jiaoduTemp);
        if (0<=newVal&&newVal<=45) {
            
            iReg=255,igreen=0;
            
            iBlue=(newVal)*255/45;        //0度到45度，蓝色的值改变增加
            
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (45<=newVal&&newVal<=135) {
            
            igreen =0;
            iBlue=255;
            
            iReg=(255-(newVal-45)*255/90);  //45度到135度，红色的值改变减小
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (135<=newVal&&newVal<=180) {
            
            iReg=0,iBlue=255;
            igreen=(newVal-135)*255/45;                         //135度到180度，绿色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (180<=newVal&&newVal<=225) {
            
            iReg=0,igreen=255;
            iBlue=255-(newVal-180)*255/45;                         //180度到225度，蓝色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
        }
        if (225<=newVal&&newVal<=315) {
            
            iBlue=0,igreen=255;
            iReg=(newVal-225)*255/90;                               //225度到315度，红色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        if (315<=newVal&&newVal<360)
        {
            
            iReg=255,iBlue=0;
            igreen=255-(newVal-315)*255/45;                         //315度到360度，绿色的值改变
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg*jiaoduTemp/305;
            strcommand [2] =igreen*jiaoduTemp/305;
            strcommand [1] =iBlue*jiaoduTemp/305;
            strcommand [4] =0;
            strcommand[6] =0x93;
            //            lightImage.image=[imagecolor imageWithTintColor:[UIColor colorWithRed:iReg/255.0 green:igreen/255.0 blue:iBlue/255.0 alpha:1.0]];
            
            
            drawView.red=((0/255)*(1-jiaodu/305)+(iReg/255.0)*jiaodu/305)*255;
            drawView.green=((0/255)*(1-jiaodu/305)+(igreen/255.0)*jiaodu/305)*255;
            drawView.blue=((0/255)*(1-jiaodu/305)+(iBlue/255.0)*jiaodu/305)*255;
            [drawView setNeedsDisplay];
            
            if ([LastSendTime timeIntervalSinceNow]<-0.05) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            
            
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
            
            
        }
        
        
        lastReg =iReg*jiaoduTemp/305;
        lastGreen =igreen*jiaoduTemp/305;
        lastBlue =iBlue*jiaoduTemp/305;
        lastWhite =0;
        
        //保存颜色
        char saveChar[8]={'s','*','*','*','*','*','#','e'};
        saveChar [3] =lastReg;
        saveChar [2] =lastGreen;
        saveChar [1] =lastBlue;
        saveChar [4] =lastWhite;
        saveChar [5] =0x00;
        saveChar[6] =0xd1;
        
        NSData *saveData = [NSData dataWithBytes:saveChar length:8];
        [tcp writeData:saveData];
        
        
    }
    [userDefaults setBool:isOff forKey:@"YesNO"];  //标记白色开关打开
    [userDefaults setInteger:iReg forKey:@"reg"];
    [userDefaults setInteger:igreen forKey:@"green"];
    [userDefaults setInteger:iBlue forKey:@"blue"];
    [userDefaults setInteger:0 forKey:@"white"];
    
    [userDefaults setInteger:newVal forKey:@"sliderAngle"];
    [userDefaults synchronize];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
