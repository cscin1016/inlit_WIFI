//
//  XIDingDeng.m
//  AD_BL
//
//  Created by apple on 14-6-14.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "XIDingDeng.h"
#import "draw_graphic.h"
#import "TcpClient.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface XIDingDeng (){
    draw_graphic *myView;
    UIImageView *sanjiaoView;
    NSDate *LastSendTime;
    float jiaodu;
    UIImageView *imageTip;
    int selectButton;
    float lastjiaodu;
    
}

@end

@implementation XIDingDeng

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectButton=2;
    // Do any additional setup after loading the view.
    LastSendTime= [[NSDate alloc]init];
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    self.view.tag=10000;
    //调亮图
    UIImageView *brightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160-18, 17, 360, 350)];
    brightView.image = [UIImage imageNamed:@"yuan"];
    brightView.userInteractionEnabled=NO;
    [self.view addSubview:brightView];
    
    //三角图
    sanjiaoView= [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160-18, 17, 360, 350)];
    sanjiaoView.image = [UIImage imageNamed:@"三角(1)"];
    [self.view addSubview:sanjiaoView];
    sanjiaoView.transform=CGAffineTransformMakeRotation(-3.1415926*42/180);
    
    CGRect initr=CGRectMake(SCREENWIDTH/2-160+26, 54, 272, 272);
    myView=[[draw_graphic alloc] initWithFrame:initr];
    myView.opaque=YES;
    myView.userInteractionEnabled=NO;
    myView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myView];
    
    myView.transform=CGAffineTransformMakeRotation(3.1415926*120/180);
    

    UIButton *blueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [blueButton setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [blueButton addTarget:self action:@selector(blueButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [blueButton setFrame:CGRectMake(SCREENWIDTH/2-160+49, 86, 100, 210)];
    [self.view addSubview:blueButton];
    
    UIButton *whiteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [whiteButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [whiteButton addTarget:self action:@selector(whiteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteButton setFrame:CGRectMake(SCREENWIDTH/2-160+113, 79, 170, 111)];
    [self.view addSubview:whiteButton];
    
    UIButton *yellowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [yellowButton setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [yellowButton addTarget:self action:@selector(yellowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [yellowButton setFrame:CGRectMake(SCREENWIDTH/2-160+123, 190, 150, 113)];
    [self.view addSubview:yellowButton];
    
    [self setupLeftMenuButton];
}
-(void)blueButtonAction{
    NSLog(@"得到角度值＝%f",jiaodu);
    if (!jiaodu) {
        lastjiaodu= 303;
    }else
    {
        lastjiaodu= jiaodu;
    }
    selectButton=1;
    TcpClient *tcp =[TcpClient sharedInstance];
    char strcommand[8]={'s','R','G','B','W','*','f','e'};
    strcommand[3] =0;
    strcommand[2] = (int)(255*(lastjiaodu/303));
    strcommand [1] =0; //blue
    strcommand [4] = 0;  //white
    strcommand[6] =0x93;//保存
    
    myView.angle=jiaodu;
    myView.red=129*jiaodu/303.0;
    myView.green=137*jiaodu/303.0;
    myView.blue=239*jiaodu/303.0;;
    [myView setNeedsDisplay];
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcp writeData:cmdData];

}
-(void)whiteButtonAction{
    if (!jiaodu) {
        lastjiaodu= 303;
    }else
    {
        lastjiaodu = jiaodu;
    }
    selectButton=2;
    TcpClient *tcp =[TcpClient sharedInstance];
    char strcommand[8]={'s','R','G','B','W','*','f','e'};
    strcommand[3] =(int)(255/2*(lastjiaodu/303))+1;
    strcommand[2] = (int)(255/2*(lastjiaodu/303))+1;
    strcommand [1] =0; //blue
    strcommand [4] = 0;  //white
    strcommand[6] =0x93;//保存
    
    myView.angle=jiaodu;
    myView.red=255*jiaodu/303.0;
    myView.green=255*jiaodu/303.0;
    myView.blue=255*jiaodu/303.0;;
    [myView setNeedsDisplay];
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcp writeData:cmdData];
}
-(void)yellowButtonAction{
    if (!jiaodu) {
        lastjiaodu= 303;
    }else
    {
        lastjiaodu = jiaodu;
    }

    selectButton=0;
    TcpClient *tcp =[TcpClient sharedInstance];
    char strcommand[8]={'s','R','G','B','W','*','f','e'};
    strcommand[3] =(int)(255*(lastjiaodu/303));
    strcommand[2] = 0;
    strcommand [1] =0; //blue
    strcommand [4] = 0;  //white
    strcommand[6] =0x93;//保存
    
    myView.angle=jiaodu;
    myView.red=210*jiaodu/303.0;
    myView.green=218*jiaodu/303.0;
    myView.blue=65*jiaodu/303.0;;
    [myView setNeedsDisplay];
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcp writeData:cmdData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"TITLE_Xiding", @"Locale", nil);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    imageTip.center=point;
    int x = point.x;
    int y = point.y;
    
    [self touchDraw:x :y];
}
-(void)touchDraw:(int)x :(int)y{
    
    if (x==162&&y>190) {
        return;
    }
    float jiaoduTem=atan((y-190)*1.0/(x-162))*180.0/3.1415926;
    
    
    if (x<=162) {
        jiaoduTem+=60;
    }else if(x>162){
        jiaoduTem+=240;
    }
    if (jiaoduTem<0||jiaoduTem>303) {
        return;
    }
    jiaodu=jiaoduTem;
    
    if (jiaodu<1.2) {
        jiaodu=jiaodu+1.2;
    }
    NSLog(@"jiaodu====%f",jiaodu);
    [self sendMessage];
    
}

-(void)sendMessage{
    TcpClient *tcp =[TcpClient sharedInstance];
    
    sanjiaoView.transform=CGAffineTransformMakeRotation(3.1415926*(jiaodu-42)/180);
    
    char strcommand[8]={'s','R','G','B','W','*','f','e'};
    int tempReg,tempBlue,tempGreen;

    if (selectButton==0) {//黄色，全红
        strcommand[3] =(int)(255*(jiaodu/303));
        strcommand[2] = 0;
        strcommand [1] =0; //blue
        strcommand [4] = 0;  //white


        tempReg=210;
        tempGreen=218;
        tempBlue=65;
        
    }else if (selectButton==1){//蓝色，全绿
        strcommand[3] =0;
        strcommand[2] =(int)(255*(jiaodu/303));
        strcommand [1] =0; //blue
        strcommand [4] = 0;  //white
        tempReg=129;
        tempGreen=137;
        tempBlue=239;
        
    }else if (selectButton==2){//白色，红 绿两枪
        strcommand[3] =(int)(127*(jiaodu/303))+1;
        strcommand[2] =(int)(127*(jiaodu/303))+1;
        
        strcommand [1] =0; //blue
        strcommand [4] = 0;  //white
        
        tempReg=255;
        tempGreen=255;
        tempBlue=255;
    }
    
    strcommand[6] =0x93;//保存

    
    myView.angle=jiaodu;
    myView.red=tempReg*jiaodu/303.0;
    myView.green=tempGreen*jiaodu/303.0;
    myView.blue=tempBlue*jiaodu/303.0;;
    [myView setNeedsDisplay];
    
    
    
    if ([LastSendTime timeIntervalSinceNow]<-0.10) {
        LastSendTime=[[NSDate alloc]init];
    }else{
        return;
    }
   
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcp writeData:cmdData];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    imageTip.center=point;
    int x = point.x;
    int y = point.y;
    
    [self touchDraw:x :y];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    imageTip.center=point;
    int x = point.x;
    int y = point.y;
    [self touchDraw:x :y];
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
