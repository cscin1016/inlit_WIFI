//
//  LunboViewController.m
//  ADM_inlit_WT
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "LunboViewController.h"
#define LUNBO_VIEW_HEIGHT 180

@interface LunboViewController ()

@end

@implementation LunboViewController

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
    // Do any additional setup after loading the view.
//    self.title = NSLocalizedStringFromTable(@"TITLE_About", @"Locale", nil);
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"music_bg@2x.png"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    UIButton *back =[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame =CGRectMake(20, 20, 60, 40);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    //图片轮播
    //    LunBoView* lunBoView =[[LunBoView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    LunBoView* lunBoView =[[LunBoView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    lunBoView.delegate = self;
    
    if (isIPhone5) {
        NSMutableArray* imgArray=[NSMutableArray arrayWithObjects:[UIImage imagePathed:@"111@2x.jpg"],[UIImage imagePathed:@"222@2x.jpg"],[UIImage imagePathed:@"333@2x.jpg"],[UIImage imagePathed:@"444@2x.jpg"], nil];
        [lunBoView setLunBoImage:imgArray];
        
        
    }else
    {
        NSMutableArray* imgArray=[NSMutableArray arrayWithObjects:[UIImage imagePathed:@"111.jpg"],[UIImage imagePathed:@"222.jpg"],[UIImage imagePathed:@"333.jpg"],[UIImage imagePathed:@"444.jpg"], nil];
        [lunBoView setLunBoImage:imgArray];
    }
    [lunBoView start];
    
    [self.view addSubview:lunBoView];
    
    
    
}

-(void)backAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
