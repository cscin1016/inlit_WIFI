//
//  RemoteVC.m
//  ADM_Lights
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 admin. All rights reserved.
//


#define DefaultButtonNum 9
#define DefaultRowNum 3
#define DefaultColumnNum 3

//删除按钮tag
#define BtnTag 400
//BigView的tag
#define BgViewTag 300

#define BrightButtonTag 101
#define CoolButtonTag 102
#define FestiveButtonTag 103
#define NightButtonTag 104
#define ReadButtonTag 105
#define RepeatButtonTag 106
#define SkinButtonTag 107
#define SpringButtonTag 108
#define WarmButtonTag 109

#import "RemoteVC.h"
#import "ViewController.h"
#import "addSceneVC.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageExtend.h" //图片压缩



@interface RemoteVC ()
{
    BOOL _edit; //是否编辑
    NSMutableArray *arr;
    UIView *bgView;  //自定义场景的画板view
    UIView * ScenceView;
    
    
    UIButton *scenebutton;
    UIImageView * jinshu;
    UILabel *label;
    
    int iReg;
    int igreen;
    int iBlue;
    int iWhite;
    
    
    NSMutableArray *newArry;
    UIView *newBgView;  //自定义场景的画板view
    
    
    
    
    NSInteger flat; //标记场景添加
    NSUserDefaults *userDefault;
}

@end

@implementation RemoteVC
@synthesize picScroller;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    arr=[[NSMutableArray alloc]initWithArray:[userDefault objectForKey:@"Scence"]];
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+ (arr.count/3+1)*88+40);
    [picScroller setContentSize:newSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    userDefault = [NSUserDefaults standardUserDefaults];
    //标题
    self.title = NSLocalizedStringFromTable(@"TITLE_Scenes", @"Locale", nil);
    
    //导航栏右侧按钮
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(SCREENWIDTH/2-160+0, 0, 44, 24);
    [btnRight setTitle:NSLocalizedStringFromTable(@"Right_add_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    //初始化滚动视图
    picScroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    picScroller.backgroundColor = [UIColor clearColor];
    picScroller.showsHorizontalScrollIndicator = NO;
    picScroller.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+ (arr.count/3+1)*88+20);
    [picScroller setContentSize:newSize];
    [self.view addSubview:picScroller];
    
    
    //每个按钮的tag值
    int tagArray[] = {BrightButtonTag,CoolButtonTag,FestiveButtonTag,NightButtonTag,
        ReadButtonTag,RepeatButtonTag,SkinButtonTag,SpringButtonTag,WarmButtonTag};
    
    //每个按钮的标题
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button1", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button2", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button3", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button4", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button5", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button6", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button7", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button8", @"Locale", nil)];
    [titleArray addObject:NSLocalizedStringFromTable(@"SCENES_Button9", @"Locale", nil)];
    
    //每个按钮的图片
    NSArray *imageArray = [NSArray arrayWithObjects:@"scene_bright",@"scene_read",@"scene_warm",@"scene_spring",@"scene_cool",@"scene_festive",@"scene_night",@"scene_skin",@"scene_repeat", nil];
    
    
    for(int i =0 ;i <DefaultButtonNum;i++)
    {
        CGFloat width = 64.f , height = 64.f;
        CGFloat space = 27.f;
        scenebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        scenebutton.tag = tagArray[i];
        [scenebutton setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        if (i%DefaultColumnNum == 0 ) {
            scenebutton.frame = CGRectMake(SCREENWIDTH/2-160+27.0, i/DefaultRowNum*(height+space+7)+space+40, width, height);
        }else if (i%DefaultColumnNum == 2 ) {
            scenebutton.frame = CGRectMake(SCREENWIDTH/2-160+229.0,i/DefaultRowNum*(height+space+7)+space+40, width, height);
        }else {
            scenebutton.frame = CGRectMake(SCREENWIDTH/2-160+128.0, i/DefaultRowNum*(height+space+7)+space+40, width, height);
        }
        [picScroller addSubview:scenebutton];
        
        
        switch (scenebutton.tag-101) {
            case 0:
                [scenebutton addTarget:self action:@selector(Button1Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [scenebutton addTarget:self action:@selector(Button2Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [scenebutton addTarget:self action:@selector(Button3Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                [scenebutton addTarget:self action:@selector(Button4Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 4:
                [scenebutton addTarget:self action:@selector(Button5Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 5:
                [scenebutton addTarget:self action:@selector(Button6Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 6:
                [scenebutton addTarget:self action:@selector(Button7Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 7:
                [scenebutton addTarget:self action:@selector(Button8Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 8:
                [scenebutton addTarget:self action:@selector(Button9Click) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(scenebutton.frame.origin.x-6, scenebutton.frame.origin.y+height, scenebutton.frame.size.width+12,20.f)];
        label.text = [titleArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor =[UIColor whiteColor];
        [picScroller addSubview:label];
        
    }
    
    arr=[[NSMutableArray alloc]initWithArray:[userDefault objectForKey:@"Scence"]];
    [self createScence];  //加载增加场景数据
}

//新增场景委托方法
-(void)getScenceData:(NSMutableArray *)scenceArray
{
    _edit = NO;
    flat=1;
    
    newArry=[[NSMutableArray alloc]initWithArray:scenceArray];
    NSLog(@"新加的这个场景数据＝》》》》%@",newArry);
    [bgView removeFromSuperview];
    [newBgView removeFromSuperview];
    newBgView =[[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160+0,350, 320, self.view.frame.size.height* (newArry.count/3+2))];
    newBgView.tag=BgViewTag+100;
    [picScroller addSubview:newBgView];
    
    
    for (int i=0;i<[newArry count];i++) {
        NSInteger index = i % 3;  // 列数
        NSInteger page = i / 3;  //行数
        

        //每个场景背景
        UIView * newScenceView;
        newScenceView =[[UIView alloc] initWithFrame:CGRectMake(index * 102 + 16, page  * 90, 88, 88)];
        [newBgView addSubview:newScenceView];
        
        
        //金属边框初始化
        UIImageView * newJinshu;
        newJinshu =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_set"]];
        newJinshu.frame =CGRectMake(12, 0, 64, 64);
        newJinshu.layer.cornerRadius=32.0;    //设成imgview高的一半，即成圆
        newJinshu.userInteractionEnabled = YES;
        
        
        //得到image 的路径
        NSData *data = [NSData dataWithContentsOfFile:[[newArry objectAtIndex:i] objectForKey:@"pathURL"]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        //将金属边框的背景颜色设置成获得的图像
        newJinshu.backgroundColor=[UIColor colorWithPatternImage:img];
        [newScenceView addSubview:newJinshu];
        
        
        //场景名称
        UILabel *newLabel;
        newLabel = [[UILabel alloc] init];
        newLabel.frame = CGRectMake(newJinshu.frame.origin.x-6, newJinshu.frame.origin.y+64, newJinshu.frame.size.width+12,20.f);
        newLabel.text = [[newArry objectAtIndex:i] objectForKey:@"name"];
        newLabel.textAlignment = NSTextAlignmentCenter;
        newLabel.font = [UIFont boldSystemFontOfSize:14];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.textColor =[UIColor whiteColor];
        [newScenceView addSubview:newLabel];
        
        
        //添加删除按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(newScenceView.frame.size.width - 35, 6, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        button.tag =1000+i;
        newScenceView.tag=11000+i;
        [button addTarget:self action:@selector(newButtonChange:) forControlEvents:UIControlEventTouchUpInside];
        [newScenceView addSubview:button];
        button.hidden = YES;
        
        
        //在jinshu上添加点击手势事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(newtapOnContentView:)];
        [newScenceView addGestureRecognizer:tapGestureRecognizer];
        
        
    }
    //长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newLongPressGestureRecognizer:)];
    [newBgView addGestureRecognizer:longGesture];
    
    
}
////////
#pragma mark 手势

//手势事件
- (void)newtapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (_edit) {
        [self editView:!_edit];
    }else{
        [self selectImage:tapGestureRecognizer.view.tag];
    }
}

//长按事件
- (void)newLongPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        [self editView:!_edit];
    }
}

//点击图标删除事件，删除时把bgView上所有的view遍历一遍。把当前view删除，并使其后面的view.frame==前面的view.frame,并动画移动后面的view。
-(void)newButtonChange:(UIButton*)sender
{
    
    [bgView removeFromSuperview];
    NSArray *views = newBgView.subviews;  // 得到新增场景bgView上的所有视图数组
    
    NSInteger index = sender.tag+10000; //sender.tag从1000开始 ＋＋1；,index=11000,11001...
    
    UIView *obj = [newBgView viewWithTag:index];
    
    int number=obj.frame.origin.x/106+obj.frame.origin.y/30;  //number的值＝？
    
    NSLog(@"%@,   number===%d",obj,number);
    
    CGRect newframe=obj.frame;
    CGRect nextframe=obj.frame;
    
    [obj removeFromSuperview];
    
    for (int i = number+1; i < [newArry count]; i++)
    {
        UIView *currentView= [views objectAtIndex:i];
        nextframe = currentView.frame;
        //并且位置动画改变,后面的位置等于删除的位置
        [UIView animateWithDuration:0.1 animations:^
         {
             currentView.frame=newframe;
             
         }];
        newframe=nextframe;
        
    }
    
    //数组中的数据移除,还应该删除沙盒中的缓存图片资源
    [newArry removeObjectAtIndex:number];
    NSLog(@"$$$$$$$$%@",newArry);
    
    //重新保存数据
    [userDefault setObject:newArry forKey:@"Scence"];
}





/////////////////////////

#pragma mark 增加的View method
-(void)createScence
{
    
    _edit = NO;
    flat =0;
    bgView =[[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160+0,360, 320, self.view.frame.size.height* (arr.count/3+2))];
    bgView.tag=BgViewTag;
    
    [picScroller addSubview:bgView];
    
    
    
    //加载arr场景的数据
    for (int i=0;i<[arr count];i++) {
        NSInteger index = i % 3;  // 列数
        NSInteger page = i / 3;  //行数
        
        //每个场景背景
        ScenceView =[[UIView alloc] initWithFrame:CGRectMake(index * 102 + 14, page  * 90, 88, 88)];
        
        [bgView addSubview:ScenceView];
        
        
        //金属边框初始化
        jinshu =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_set"]];
        
        jinshu.frame =CGRectMake(14, 0, 64, 64);
        jinshu.layer.cornerRadius=32.0;    //设成imgview高的一半，即成圆
        jinshu.userInteractionEnabled = YES;
        
        //得到image 的路径
        NSData *data = [NSData dataWithContentsOfFile:[[arr objectAtIndex:i] objectForKey:@"pathURL"]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        //将金属边框的背景颜色设置成获得的图像
        jinshu.backgroundColor=[UIColor colorWithPatternImage:img];
        [ScenceView addSubview:jinshu];
        
        
        //场景名称
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(jinshu.frame.origin.x-6, jinshu.frame.origin.y+64, jinshu.frame.size.width+12,20.f);
        label.text = [[arr objectAtIndex:i] objectForKey:@"name"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor =[UIColor whiteColor];
        [ScenceView addSubview:label];
        
        
        
        //添加删除按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScenceView.frame.size.width - 35, 6, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        button.tag =1000+i;
        ScenceView.tag=11000+i;
        [button addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [ScenceView addSubview:button];
        button.hidden = YES;
        
        
        //在jinshu上添加点击手势事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
        [ScenceView addGestureRecognizer:tapGestureRecognizer];
        
        
    }
    
    
    //长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGestureRecognizer:)];
    [bgView addGestureRecognizer:longGesture];
    
    
    
}

///////////////////////


#pragma mark 手势

//手势事件
- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"tag:%ld  ,%@",(long)tapGestureRecognizer.view.tag,tapGestureRecognizer.view);
    if (_edit) {
        [self editView:!_edit];
        
    }else{
        [self selectImage:tapGestureRecognizer.view.tag];
    }
}

//长按事件
- (void)LongPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        [self editView:!_edit];
        NSLog(@"长按事件");
    }
}

//点击图标删除事件，删除时把bgView上所有的view遍历一遍。把当前view删除，并使其后面的view.frame==前面的view.frame,并动画移动后面的view。
-(void)buttonChange:(UIButton*)sender
{
    
    NSArray *views = bgView.subviews;  // 得到新增场景bgView上的所有视图数组
    
    NSInteger index = sender.tag+10000; //sender.tag从1000开始 ＋＋1；,index=11000,11001...
    
    UIView *obj = [bgView viewWithTag:index];
    
    int number=obj.frame.origin.x/106+obj.frame.origin.y/30;  //number的值＝？
    NSLog(@"%@,   number===%d",obj,number);
    
    CGRect newframe=obj.frame;
    CGRect nextframe=obj.frame;
    
    [obj removeFromSuperview];
    
    for (int i = number+1; i < [arr count]; i++)
    {
        UIView *currentView= [views objectAtIndex:i];
        nextframe = currentView.frame;
        
        //并且位置动画改变,后面的位置等于删除的位置
        [UIView animateWithDuration:0.1 animations:^
         {
             currentView.frame=newframe;
             
         }];
        newframe=nextframe;
        
    }
    
    //数组中的数据移除
    [arr removeObjectAtIndex:number];
    
    //重新保存数据
    [userDefault setObject:arr forKey:@"Scence"];
    
    
}


//是否编辑中，编辑时使其每个view上的删除按钮出现hidden=no
- (void)editView:(BOOL)isEdit
{
    _edit = isEdit;
    if (flat==0) {
        for (UIView *view in bgView.subviews){
            for (UIView *v in view.subviews){
                //所有的删除uibutton是否显示
                if ([v isMemberOfClass:[UIButton class]])
                    [v setHidden:!isEdit];
            }
        }
        
    }else if (flat==1){
        for (UIView *view in newBgView.subviews){
            
            for (UIView *v in view.subviews){
                //所有的删除uibutton是否显示
                if ([v isMemberOfClass:[UIButton class]])
                    [v setHidden:!isEdit];
            }
        }
    }
    
}

#pragma mark - 新添加场景点击事件
//view 点击事件
-(void)selectImage:(NSInteger)index
{
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[userDefault objectForKey:@"Scence"]];
    
    TcpClient *tcp = [TcpClient sharedInstance];
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =[[[array objectAtIndex:index-11000] objectForKey:@"red"] intValue]; //reg
        strcommand [2] =[[[array objectAtIndex:index-11000] objectForKey:@"green"] intValue]; //green
        strcommand [1] =[[[array objectAtIndex:index-11000] objectForKey:@"blue"] intValue]; //blue
        strcommand [4] =[[[array objectAtIndex:index-11000] objectForKey:@"white"] intValue];  //white
        strcommand[6] =209;
        
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:[[[array objectAtIndex:index-11000] objectForKey:@"red"] intValue] forKey:@"reg"];
        [userDef setInteger:[[[array objectAtIndex:index-11000] objectForKey:@"green"] intValue] forKey:@"green"];
        [userDef setInteger:[[[array objectAtIndex:index-11000] objectForKey:@"blue"] intValue] forKey:@"blue"];
        [userDef setInteger:[[[array objectAtIndex:index-11000] objectForKey:@"white"] intValue] forKey:@"white"];
    }
    
}


#pragma mark- 9个按钮事件
//shangliang
-(void)Button1Click
{
    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =255;
    igreen =255;
    iBlue=255;
    iWhite=255;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
 
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
    }
    NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
    [userDef setInteger:iReg forKey:@"reg"];
    [userDef setInteger:igreen forKey:@"green"];
    [userDef setInteger:iBlue forKey:@"blue"];
    [userDef setInteger:iWhite forKey:@"white"];
}

//yuedu
-(void)Button2Click
{
 
    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =0;
    igreen =0;
    iBlue=0;
    iWhite=255;
    if(tcp.currentArray.count)
    {
        NSLog(@"方法不走了-->");
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//wennuan
-(void)Button3Click
{

    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =127;
    igreen =0;
    iBlue=0;
    iWhite=255;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//chunyi
-(void)Button4Click
{

    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =0;
    igreen =255;
    iBlue=0;
    iWhite=0;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//qingliang
-(void)Button5Click
{

    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =127;
    igreen =255;
    iBlue=127;
    iWhite=255;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//xiqing
-(void)Button6Click
{

    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =255;
    igreen =0;
    iBlue=0;
    iWhite=0;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];

    }
}


//yewan

-(void)Button7Click
{

    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =0;
    igreen =0;
    iBlue=0;
    iWhite=100;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//hufu
-(void)Button8Click
{
    
    TcpClient *tcp = [TcpClient sharedInstance];
    iReg =255;
    igreen =0;
    iBlue=0;
    iWhite=127;
    if(tcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =iReg; //reg
        strcommand [2] =igreen; //green
        strcommand [1] =iBlue; //blue
        strcommand [4] =iWhite;  //white
        strcommand[6] =209;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
    }
}

//chongfu
-(void)Button9Click
{
    
    TcpClient *tcp = [TcpClient sharedInstance];
    if(tcp.currentArray.count)
    {
        
        char strcommand[8]={'s','*','*','*','*','*','#','e'};
    
        strcommand[6] =0x85;
        //        NSLog(@"ireg1 =%d,igreen1=%d,iblue1===%d,iwhite1=%d",iReg,igreen, iBlue,iWhite);
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
        
        
    }
}

-(void)addClick
{
    NSLog(@"添加场景");
    addSceneVC * addscene =[[addSceneVC alloc] init];
    addscene.delegate = self;
    [self.navigationController pushViewController:addscene animated:YES];
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
