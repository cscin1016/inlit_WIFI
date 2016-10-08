//
//  AboutViewController.m
//  ADM_inlit_WT
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "AboutViewController.h"
#import "LunboViewController.h"
#import "MBProgressHUD.h"
#import "InfoViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LunboViewController *lunboVC;
    InfoViewController *infoVC;
    UITableView *moreTableView;
    NSArray *moreArray;
    NSArray *imageAarry;
    MBProgressHUD *hud;

}

@end

@implementation AboutViewController

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
    [self setupLeftMenuButton];
    
    // Do any additional setup after loading the view.
    lunboVC =[[LunboViewController alloc] init];
    infoVC =[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    self.title = NSLocalizedStringFromTable(@"TITLE_About", @"Locale", nil);
    //背景图

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    [self.view addSubview:imageView];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    

    
    moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
    moreTableView.delegate= self;
    moreTableView.dataSource= self;
    moreTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moreTableView];
    
    moreArray= [[NSArray alloc] initWithObjects: NSLocalizedStringFromTable(@"About_guide", @"Locale", nil), NSLocalizedStringFromTable(@"About_version", @"Locale", nil), NSLocalizedStringFromTable(@"About_our", @"Locale", nil), nil];
    imageAarry = [[NSArray alloc] initWithObjects:@"about",@"about",@"about",@"about", nil];
    
    
}

-(void)lunbo
{
    [self.navigationController pushViewController:lunboVC animated:YES];
//    [self presentViewController:lunboVC animated:NO completion:nil];
    
}


#pragma mark UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [moreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor =[UIColor clearColor];
    cell.textLabel.text = [moreArray objectAtIndex:indexPath.row];
    
//    cell.imageView.image = [UIImage imageNamed:[imageAarry objectAtIndex:indexPath.row]];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"1111111111");
    NSInteger selectRow = [indexPath row];
    if (selectRow==0) {
        [self.navigationController pushViewController:lunboVC animated:YES];
        
    }
    if(selectRow==1)
    {
        
        UIView * hudview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        hudview.backgroundColor =[UIColor grayColor];
        hud =[[MBProgressHUD alloc] initWithView:hudview];
        hud.labelText = NSLocalizedStringFromTable(@"HUD_checkVersion", @"Locale", nil); //正在配置，请稍等
        [hud show:YES];
        [self.view addSubview:hud];
        
        [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:2.0f];
        
        
        
    }if (selectRow==2) {
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)dismissHUD
{
    [hud removeFromSuperview];
    [self  isConnectionAvailable];

}

//版本更新
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=885825488";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:0 error:&error];
    //    NSLog(@"dic=========%@",dic);
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Update_Title", @"Locale", nil) message:NSLocalizedStringFromTable(@"Update_Label", @"Locale", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Update_Close", @"Locale", nil) otherButtonTitles:NSLocalizedStringFromTable(@"Update_Godo", @"Locale", nil), nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Update_Title", @"Locale", nil) message:NSLocalizedStringFromTable(@"Update_NowVersion", @"Locale", nil)  delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil, nil];
                        alert.tag = 10001;
                        [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/inlit-wt100/id885825488?mt=8"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

//判断网络是否可用
-(BOOL) isConnectionAvailable{
    
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");//无网络 不更新
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            [self onCheckVersion];// WIFI下更新
            NSLog(@"WIFI");
            
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;

          [self onCheckVersion];// 3G下更新
            NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedStringFromTable(@"HUD_NonetWork", @"Locale", nil);
                hud.minSize = CGSizeMake(100.f, 100.0f);
                [hud hide:YES afterDelay:1];

        return NO;
    }
    
    return isExistenceNetwork;
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
