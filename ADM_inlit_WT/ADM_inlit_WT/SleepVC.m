//
//  SleepVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "SleepVC.h"
#import "QuartzCore/QuartzCore.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface SleepVC ()
{
    UIButton * buttonTime;
}

@end

@implementation SleepVC
@synthesize timeTableView,timesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedStringFromTable(@"TITLE_Sleep", @"Locale", nil);

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupLeftMenuButton];
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"sleep_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    
    buttonTime =[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTime setTitle:NSLocalizedStringFromTable(@"Time_label", @"Locale", nil) forState:UIControlStateNormal];
    [buttonTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonTime.frame =CGRectMake(SCREENWIDTH/2-160+40, 84, 240, 40);
    buttonTime.layer.borderWidth = 1;
    buttonTime.layer.borderColor = [[UIColor blackColor] CGColor];
    buttonTime.layer.cornerRadius = 5;
    [buttonTime addTarget:self action:@selector(buttonTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTime];
    
    UIButton * okButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:NSLocalizedStringFromTable(@"queding_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 8;
    okButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:0.8]; //
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.frame =CGRectMake(SCREENWIDTH/2-160+80, 155, 160, 60);
    [okButton addTarget:self action:@selector(timeSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:okButton];
}

-(void)buttonTimeClick:(id)sender
{
    NSMutableArray * chooseArray =[NSMutableArray arrayWithObjects:@"5 min",@"10 min",@"15 min",@"20 min",@"25 min",@"30 min",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :chooseArray];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
    
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel
{
    
    dropDown = nil;
}


-(void)timeSend:(id)sender
{
    //发送时间
    
    if ([buttonTime.currentTitle isEqualToString:NSLocalizedStringFromTable(@"Time_label", @"Locale", nil)]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"Time_alert", @"Locale", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil), nil];
        [alert show];
        
    }else
    {
        int model=0;
        if ([buttonTime.currentTitle isEqualToString:@"5 min"]) {
            model =1;
        }
        if ([buttonTime.currentTitle isEqualToString:@"10 min"]) {
            model =2;
        }
        if ([buttonTime.currentTitle isEqualToString:@"15 min"]) {
            model =3;
        }
        if ([buttonTime.currentTitle isEqualToString:@"20 min"]) {
            model =4;
        }
        if ([buttonTime.currentTitle isEqualToString:@"25 min"]) {
            model =5;
        }
        if ([buttonTime.currentTitle isEqualToString:@"30 min"]) {
            model =6;
        }
        
        char strcommand[8]={'s','s','*','*','*','*','*','e'};
        
        strcommand[2]= model;
        strcommand[6] =160;
        
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        
        
        TcpClient *tcpLinkser= [TcpClient sharedInstance];
        if([tcpLinkser.currentArray count])
        {
            
            [tcpLinkser writeData:cmdData];
            NSLog(@"strcommand===%s",strcommand);
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"Time_sent", @"Locale", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil), nil];
            [alert show];
            
            
        }
        
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
