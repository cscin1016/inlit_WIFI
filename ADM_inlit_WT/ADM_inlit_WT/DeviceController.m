//
//  DeviceController.m
//  ADM_inlit_WT
//
//  Created by admin on 14-8-7.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "DeviceController.h"
#import "ViewController.h"


@interface DeviceController ()
{
    NSMutableArray *selectArray;
    UITextField *settingName;
    UIView *editView;
    
    UITableView *deviceList;
    NSUserDefaults *UserDefaults;
}
@end

@implementation DeviceController
@synthesize dataList,delegate,tcpClient;
@synthesize allLightMessage;

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
    
    self.title = NSLocalizedStringFromTable(@"TITLE_Group", @"Locale", nil);
    self.view.backgroundColor=[UIColor grayColor];
    
    deviceList =[[UITableView alloc] init];
    deviceList.backgroundColor = [UIColor grayColor];
   
    selectArray =[[NSMutableArray alloc] initWithCapacity:0];
    
    [deviceList setFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Left_back_BUTTON", @"Locale", nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(BackAction)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ok"] style:UIBarButtonItemStylePlain target:self action:@selector(OKClick)];
    myAddButton.tintColor=[UIColor greenColor];
    UIBarButtonItem *mySearchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(CancelClick)];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:mySearchButton, myAddButton, nil];
    self.navigationItem.rightBarButtonItems = myButtonArray;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor redColor];
    
    
    
    deviceList.dataSource= self;
    deviceList.delegate=self;
    [self.view addSubview:deviceList];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [deviceList setTableFooterView:view];
    
}

#pragma mark UITableView DataSoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==deviceList) {
        return [allLightMessage count];
    }
    return 0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
    NSString *CellWithIdentifier = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];

    cell.textLabel.text = [[allLightMessage objectAtIndex:row] objectForKey:@"DeviceMac"]; //MAc
    cell.textLabel.backgroundColor =[UIColor clearColor];
    cell.detailTextLabel.text =[[allLightMessage objectAtIndex:row] objectForKey:@"DeviceIP"]; //AP
    cell.detailTextLabel.textColor =[UIColor grayColor];
    cell.detailTextLabel.backgroundColor =[UIColor clearColor];
        
    return cell;
}


#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //根据当前行的值,代理传值

    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectArray addObject:[[allLightMessage objectAtIndex:indexPath.row] objectForKey:@"DeviceIP"]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectArray removeObject:[[allLightMessage objectAtIndex:indexPath.row] objectForKey:@"DeviceIP"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone4) {
        return 48;
    }
    return 55;
}


#pragma mark - ButtonClick
-(void)OKClick
{
    //把得到的ip数组传给LampsSettingVC页面
    if (selectArray.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        NSLog(@"selectArray:%@",selectArray);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        settingName = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 40)];
        
        settingName.placeholder =NSLocalizedStringFromTable(@"Group_NAV_Name", @"Locale", nil);
        settingName.borderStyle =UITextBorderStyleNone;
        [settingName.layer setMasksToBounds:YES];
        [settingName.layer setBorderWidth:2.0]; //边框宽度
        settingName.layer.cornerRadius = 8;
        [settingName.layer setBorderColor:[[UIColor orangeColor] CGColor]];
        settingName.backgroundColor =[UIColor clearColor];
        
        UIButton *fasongBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        fasongBut.frame = CGRectMake(250, 10, 60, 40);
        [fasongBut setTitle:NSLocalizedStringFromTable(@"Group_NAV_OK", @"Locale", nil)forState:UIControlStateNormal];
        fasongBut.titleLabel.font = [UIFont systemFontOfSize: 21];
        [fasongBut addTarget:self action:@selector(OKButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        editView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 60)];
        editView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:editView];
        [editView addSubview:settingName];
        
        [editView addSubview:fasongBut];
        
        [self pinglunAction];
        
    }
    
    
}

//下面是操作的三个方法。
-(void)pinglunAction{
    editView.hidden = NO;
    [self.view bringSubviewToFront:editView];
    [settingName becomeFirstResponder];
    
}

-(void)OKButtonclicked:(UIButton *)sender{
    NSLog(@"确定按钮点击了");
    [settingName resignFirstResponder];
    editView.hidden = YES;
    editView.center = CGPointMake(editView.center.x, [UIScreen mainScreen].bounds.size.height);
    //把该行的名称命名
    //得到该组数据在整个数组中的位置
    
    if (settingName.text.length==0) {
        return;
    }
    NSString* name = settingName.text;
    NSUserDefaults *UserDef =[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[UserDef objectForKey:@"GroupIP"]];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:selectArray,@"GroupArrayIP",name,@"GroupName", nil];
    [arr addObject:dic];
    [UserDef setObject:arr forKey:@"GroupIP"];
    [self.delegate getHostList:arr andGetMac:arr];
    [self.navigationController popViewControllerAnimated:YES];

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
        editView.center = CGPointMake(editView.center.x, SCREENHEIGHT-keyBoardEndY- editView.bounds.size.height*1.5);   // keyBoardEndY的坐标包括了状态栏的高度
    }];
}

-(void)CancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)BackAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
