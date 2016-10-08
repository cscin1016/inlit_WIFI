//
//  InfoViewController.m
//  ADM_inlit_WT
//
//  Created by admin on 14-9-15.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
{
    UILabel *copyRight;
    UILabel *copyRight_1;
}

@end

@implementation InfoViewController

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
    copyRight =[[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-44, [UIScreen mainScreen].bounds.size.width, 20)];
    copyRight.text =@"Copyright(C)2014 ADM";
    copyRight.textAlignment =NSTextAlignmentCenter;
    copyRight.textColor =[UIColor whiteColor];
    copyRight.backgroundColor =[UIColor clearColor];
    [self.view addSubview:copyRight];
    
    copyRight_1 =[[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-22, [UIScreen mainScreen].bounds.size.width, 20)];
    copyRight_1.text =@"All Rights Reserved";
    copyRight_1.textAlignment =NSTextAlignmentCenter;
    copyRight_1.textColor =[UIColor whiteColor];
    copyRight_1.backgroundColor =[UIColor clearColor];
    [self.view addSubview:copyRight_1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
