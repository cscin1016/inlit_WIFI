//
//  AboutOurVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "AboutOurVC.h"
#define LUNBO_VIEW_HEIGHT 180


@interface AboutOurVC ()

@end

@implementation AboutOurVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedStringFromTable(@"TITLE_About", @"Locale", nil);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"music_bg@2x.png"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    
    UILabel *oneAbout = [[UILabel alloc] initWithFrame:CGRectMake(77,15, 166, 21)];
    oneAbout.backgroundColor = [UIColor clearColor];
    oneAbout.text = @"Product instructions";
    oneAbout.font = [UIFont systemFontOfSize:17];
    //    oneAbout.lineBreakMode = NSLineBreakByWordWrapping;
    //    oneAbout.numberOfLines =20;
    oneAbout.textAlignment = NSTextAlignmentCenter;
    oneAbout.textColor = [UIColor blackColor];
    //    [self.view addSubview:oneAbout];
    
    
    UILabel *oneAbout1 = [[UILabel alloc] initWithFrame:CGRectMake(18,48,55, 21)];
    oneAbout1.backgroundColor = [UIColor clearColor];
    oneAbout1.text = @"Step 1.";
    oneAbout1.font = [UIFont systemFontOfSize:17];
    //    oneAbout.lineBreakMode = NSLineBreakByWordWrapping;
    //    oneAbout.numberOfLines =20;
    oneAbout1.textAlignment = NSTextAlignmentCenter;
    oneAbout1.textColor = [UIColor whiteColor];
    //    [self.view addSubview:oneAbout1];
    
    
    UILabel *oneAbout2 = [[UILabel alloc] initWithFrame:CGRectMake(34,70,286,61)];
    oneAbout2.backgroundColor = [UIColor clearColor];
    oneAbout2.text = @"Ensure your light device is turned on,then in the mobile phone setting connect your iPhone to the wifi network named Inlit_WT100, and enter the password: 12345678";
    oneAbout2.font = [UIFont systemFontOfSize:12];
    oneAbout2.lineBreakMode = NSLineBreakByWordWrapping;
    oneAbout2.numberOfLines =5;
    oneAbout2.textAlignment = NSTextAlignmentLeft;
    oneAbout2.textColor = [UIColor whiteColor];
    //    [self.view addSubview:oneAbout2];
    
    
    UILabel *oneAbout3 = [[UILabel alloc] initWithFrame:CGRectMake(18,142,55, 21)];
    oneAbout3.backgroundColor = [UIColor clearColor];
    oneAbout3.text = @"Step 2.";
    oneAbout3.font = [UIFont systemFontOfSize:17];
    //    oneAbout.lineBreakMode = NSLineBreakByWordWrapping;
    //    oneAbout.numberOfLines =20;
    oneAbout3.textAlignment = NSTextAlignmentCenter;
    oneAbout3.textColor = [UIColor whiteColor];
    //    [self.view addSubview:oneAbout3];
    
    
    UILabel *oneAbout4 = [[UILabel alloc] initWithFrame:CGRectMake(34,158,286,61)];
    oneAbout4.backgroundColor = [UIColor clearColor];
    oneAbout4.text = @"Open your app, click the Settings button, and add your lamp to a wifi network, if it was successfully added, than search your device under the wifi network.";
    oneAbout4.font = [UIFont systemFontOfSize:12];
    oneAbout4.lineBreakMode = NSLineBreakByWordWrapping;
    oneAbout4.numberOfLines =5;
    oneAbout4.textAlignment = NSTextAlignmentLeft;
    oneAbout4.textColor = [UIColor whiteColor];
    //    [self.view addSubview:oneAbout4];
    
    
    
    
    
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
    //    [self.view addSubview:lunBoView];
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
