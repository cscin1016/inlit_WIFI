//
//  MeunViewController.m
//  Foodspotting
//
//  Created by jetson  on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeunViewController.h"
//#import "DDMenuController.h"

#import "MMDrawerController.h"
#import "MMNavigationController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "AppDelegate.h"
#import "ViewController.h"
//8功能
#import "BrignessVC.h"
#import "MusicTestViewController.h"
#import "RemoteVC.h"
#import "SleepVC.h"
#import "TimerVC.h"
#import "AboutOurVC.h"
#import "ColorPictrueVC.h"
#import "RecordVC.h"
#import "CSCViewController.h"

#import "AboutViewController.h"
#import "XIDingDeng.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"



@interface MeunViewController (){
    
    BrignessVC *ColorAndBright;
    MusicTestViewController *MusicMode;
    RemoteVC *RemoteMode;
    SleepVC * sleepMode;
    TimerVC * timerMode;
    
    AboutViewController *aboutMode;
    RecordVC *recordMode;
    CSCViewController *pictrueMode;
    XIDingDeng *xidingdeng;
    
}

@end

@implementation MeunViewController

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
    // Do any additional setup after loading the view from its nib.
    
	list = [[NSMutableArray alloc]init];
    
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ1", @"Locale", nil)];
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ2", @"Locale", nil)];
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ5", @"Locale", nil)];
	[list addObject:NSLocalizedStringFromTable(@"LISTOBJ3", @"Locale", nil)];
	[list addObject:NSLocalizedStringFromTable(@"LISTOBJ7", @"Locale", nil)];
    
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ4", @"Locale", nil)];
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ6", @"Locale", nil)];
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ8", @"Locale", nil)];
    [list addObject:NSLocalizedStringFromTable(@"LISTOBJ10", @"Locale", nil)];
    
    
    detailsList =[[NSMutableArray alloc] init];
    
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details1", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details2", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details5", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details3", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details7", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details4", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details6", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details8", @"Locale", nil)];
    [detailsList addObject:NSLocalizedStringFromTable(@"LIST_Details10", @"Locale", nil)];
    
    
    
    imageList =[[NSMutableArray alloc] init];
    NSMutableArray * array =[[NSMutableArray alloc] initWithObjects:@"home",@"color",@"music",@"picture",@"scenes",@"timer",@"sleep",@"ic_microphone",@"xiding", nil];
    [imageList addObjectsFromArray:array];
    
    
    
    
    
    
    ColorAndBright=[[BrignessVC alloc]init];
    MusicMode=[[MusicTestViewController alloc]init];
 
    
    RemoteMode=[[RemoteVC alloc]init];
    timerMode =[[TimerVC alloc] init];
    pictrueMode =[[CSCViewController alloc] init];
    aboutMode =[[AboutViewController alloc] init];
    sleepMode =[[SleepVC alloc] init];
    recordMode =[[RecordVC alloc] init];
    xidingdeng =[[XIDingDeng alloc] init];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#define macro ===========tableView============

//选中Cell响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	// set the root controller
//    DDMenuController *menuController = (DDMenuController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    MMDrawerController *drawerController = (MMDrawerController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerController;
    if(indexPath.row==0){
		//主页
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
	}
    else if(indexPath.row ==1){
        //亮度颜色
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:ColorAndBright];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
        
	}else if(indexPath.row ==2){
        //音乐
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:MusicMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
		
	}else if(indexPath.row ==3){
        //图片模式
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:pictrueMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
		
	}else if(indexPath.row ==4){
        //场景
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:RemoteMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
		
	}else if(indexPath.row ==5){
        //定时
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:timerMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
	}else if(indexPath.row ==6){
        //睡眠
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:sleepMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
	}else if(indexPath.row ==8){
        //吸顶灯
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:xidingdeng];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
	} else if(indexPath.row ==7){
        //录音
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:recordMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
	}else{
        //关于
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:aboutMode];
        [drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
        
	}
    
    
	
	
    //    //点击完毕，立即恢复颜色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
//返回TableView中有多少数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
    
}
//返回有多少个TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//组装每一条的数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
    static NSString *CustomCellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    cell.textLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor=[UIColor colorWithRed:180/255.0f green:170/255.0f blue:200/255.0f alpha:1.0f];
    
    cell.detailTextLabel.text =[detailsList objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor =[UIColor lightGrayColor];
    cell.detailTextLabel.font =[UIFont fontWithName:@"ArialMT" size:10];
    
    cell.imageView.image = [UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
    
    return cell;
    
}

@end
