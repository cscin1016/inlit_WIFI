//
//  addSceneVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "addSceneVC.h"
#import "ViewController.h"
#import "RemoteVC.h"
//#import "DDMenuController.h"
#import "UIImageExtend.h" //图片压缩
@interface addSceneVC ()
{
    UIButton *RedButton;
    UIButton *GreenButton;
    UIButton *BlueButton;
    UIButton *WhiteButton;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    
    int iReg;
    int igreen;
    int iBlue;
    int iWhite;
    
    UISlider *redSlider;
    UISlider *greenSlider;
    UISlider *blueSlider;
    UISlider *whiteSlider;
    
    TcpClient *tcpLinker;
//    DDMenuController *dd;
    UINavigationBar *navBar;
    
    UITextField * nameText;
    UIButton *renameButton;
    UIButton *setPictrueButton;
    
    NSString *filePath ;//图片路径
    
     UILabel *addPictrue;
    
    
}

@end

@class DDMenuController;
@implementation addSceneVC
@synthesize selectedImage;
@synthesize delegate;

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
    
    
    UIImage *bgImage = [UIImage imageNamed:@"app_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    self.title = NSLocalizedStringFromTable(@"TITLE_ADDScenes", @"Locale", nil);
    
    //导航item
        
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 44, 24);
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Left_back_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
//    [btnLeft setBackgroundImage:[UIImage imageNamed:@"nav_Left.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 44, 24);
    [btnRight setTitle:NSLocalizedStringFromTable(@"Save_BUTTON", @"Locale", nil) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];

    
    
    
    RedButton=[UIButton buttonWithType:UIButtonTypeCustom];
    RedButton.frame=CGRectMake(SCREENWIDTH/2-160+10, 24, 50, 50);
    [RedButton.layer setMasksToBounds:YES];
    [RedButton.layer setCornerRadius:25.0];
    [RedButton.layer setBorderWidth:3.0]; //边框宽度
    [RedButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    RedButton.backgroundColor=[UIColor redColor];
    [RedButton addTarget:self action:@selector(redButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RedButton];
    
    
    GreenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    GreenButton.frame=CGRectMake(SCREENWIDTH/2-160+90, 24, 50, 50);
    [GreenButton.layer setMasksToBounds:YES];
    [GreenButton.layer setCornerRadius:25.0];
    [GreenButton.layer setBorderWidth:3.0]; //边框宽度
    [GreenButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    GreenButton.backgroundColor=[UIColor greenColor];
    [GreenButton addTarget:self action:@selector(greenButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GreenButton];
    
    
    BlueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    BlueButton.frame=CGRectMake(SCREENWIDTH/2-160+170, 24, 50, 50);
    [BlueButton.layer setMasksToBounds:YES];
     [BlueButton.layer setCornerRadius:25.0];
    [BlueButton.layer setBorderWidth:3.0]; //边框宽度
    [BlueButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    BlueButton.backgroundColor=[UIColor blueColor];
    [BlueButton addTarget:self action:@selector(blueButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BlueButton];
    
    
    WhiteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    WhiteButton.frame=CGRectMake(SCREENWIDTH/2-160+250, 24, 50, 50);
    [WhiteButton.layer setCornerRadius:25.0];
    [WhiteButton.layer setMasksToBounds:YES];
    [WhiteButton.layer setBorderWidth:3.0]; //边框宽度
    [WhiteButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    WhiteButton.backgroundColor=[UIColor whiteColor];
    [WhiteButton setTitle:@"off" forState:UIControlStateNormal];
    [WhiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [WhiteButton addTarget:self action:@selector(whiteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WhiteButton];
    
    tcpLinker=[TcpClient sharedInstance];
    
    
    label1=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+30, 84, 60, 40)];
    label1.text=@"0";
    label1.textColor=[UIColor redColor];
    label1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label1];
    
    
    
    label2=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+30, 134, 60, 40)];
    label2.text=@"0";
    label2.textColor=[UIColor greenColor];
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];
    
    
    label3=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+30, 184, 60, 40)];
    label3.text=@"0";
    label3.textColor=[UIColor blueColor];
    label3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label3];
    
    
    label4=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+30, 234, 60, 40)];
    label4.text=@"0";
    label4.textColor=[UIColor whiteColor];
    label4.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label4];
    
    
    redSlider=[[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+80, 84, 200, 40)];
    redSlider.value=255;
    redSlider.tag=0;
    redSlider.minimumValue=0;
    redSlider.maximumValue=255;
    redSlider.continuous = YES;
    [redSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:redSlider];
    
    
    greenSlider=[[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+80, 134, 200, 40)];
    greenSlider.value=255;
    greenSlider.minimumValue=0;
    greenSlider.maximumValue=255;
    greenSlider.tag=1;
    [greenSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:greenSlider];
    
    blueSlider=[[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+80, 184, 200, 40)];
    blueSlider.value=255;
    blueSlider.minimumValue=0;
    blueSlider.maximumValue=255;
    blueSlider.tag=2;
    [blueSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:blueSlider];
    
    whiteSlider=[[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+80, 234, 200, 40)];
    whiteSlider.value=255;
    whiteSlider.minimumValue=0;
    whiteSlider.maximumValue=255;
    whiteSlider.tag=3;
    [whiteSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:whiteSlider];
    
    
    //名称编辑
    nameText=[[UITextField alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-160+20, 320, 120, 30)];
    nameText.borderStyle =UITextBorderStyleNone;
    nameText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameText.placeholder = NSLocalizedStringFromTable(@"SET_Name", @"Locale", nil);
    nameText.adjustsFontSizeToFitWidth = YES;
    nameText.layer.borderColor = [UIColor colorWithRed:0 green:80 blue:80 alpha:0.7].CGColor;
    nameText.layer.borderWidth = 1.0;
    nameText.textAlignment  =NSTextAlignmentCenter;
    nameText.backgroundColor =[UIColor whiteColor];
    nameText.keyboardType = UIKeyboardTypeDefault;
    nameText.returnKeyType = UIReturnKeyDone;
    nameText.delegate = self;
    [self.view addSubview:nameText];
    
    selectedImage = [[UIImageView alloc] init];
    selectedImage.frame =CGRectMake(SCREENWIDTH/2-160+155, 304, 64, 64);
    [self.view addSubview:selectedImage];
    //设成圆
    CALayer *imageLayer = selectedImage.layer;
    [imageLayer setMasksToBounds:YES];
    imageLayer.cornerRadius = CGRectGetHeight([selectedImage bounds]) / 2;;
    
    
    
    //添加设置图片
    setPictrueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    setPictrueButton.frame=CGRectMake(SCREENWIDTH/2-160+240, 304, 60, 60);
//    setPictrueButton.layer.cornerRadius =32;
    [setPictrueButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [setPictrueButton addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setPictrueButton];
    
    addPictrue=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-160+230, 362, 80, 24)];
    addPictrue.text=NSLocalizedStringFromTable(@"Image_add_LABEL", @"Locale", nil);
    addPictrue.textColor=[UIColor whiteColor];
    addPictrue.textAlignment = NSTextAlignmentCenter;
    addPictrue.backgroundColor = [UIColor clearColor];
    [self.view addSubview:addPictrue];
    
    
    
    
    
}
-(void)updateValue:(id)sender{
    if(((UISlider*)sender).tag==0){
        iReg=((UISlider*)sender).value;
        label1.text =[NSString stringWithFormat:@"%i",(int)roundf(((UISlider*)sender).value)] ;
        
    }else if (((UISlider*)sender).tag==1){
        igreen=((UISlider*)sender).value;
        label2.text =[NSString stringWithFormat:@"%i",(int)roundf(((UISlider*)sender).value)] ;
        
    }else if (((UISlider*)sender).tag==2){
        iBlue=((UISlider*)sender).value;
        label3.text =[NSString stringWithFormat:@"%i",(int)roundf(((UISlider*)sender).value)] ;
    }else if (((UISlider*)sender).tag==3){
        iWhite=((UISlider*)sender).value;
        label4.text =[NSString stringWithFormat:@"%i",(int)roundf(((UISlider*)sender).value)] ;
    }
    if (iReg==0&&igreen==0&&iBlue==0&&iWhite==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"颜色值不能全为0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else
    {
    char strcommand[8]={'s','r','g','b','w','B','#','e'};
    strcommand [3] =iReg; //reg
    strcommand [2] =igreen; //green
    strcommand [1] =iBlue; //blue
    strcommand [4] =iWhite;  //white
    strcommand[6] =209;
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcpLinker writeData:cmdData];
    }
    NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
    [userDef setInteger:iReg forKey:@"reg"];
    [userDef setInteger:igreen forKey:@"green"];
    [userDef setInteger:iBlue forKey:@"blue"];
    [userDef setInteger:iWhite forKey:@"white"];

    
}
-(void)redButtonAction{
    NSLog(@"redButtonAction");
    label1.text=@"255";
    label2.text=@"0";
    label3.text=@"0";
    iReg=255;
    igreen=0;
    iBlue=0;
    
    redSlider.value=255;
    greenSlider.value=0;
    blueSlider.value=0;
    
    char strcommand[8]={'s','r','g','b','w','B','#','e'};
    strcommand [3] =255; //reg
    strcommand [2] =0; //green
    strcommand [1] =0; //blue
    strcommand [4] =iWhite;  //white
    strcommand[6] =209;
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcpLinker writeData:cmdData];
    NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
    [userDef setInteger:iReg forKey:@"reg"];
    [userDef setInteger:igreen forKey:@"green"];
    [userDef setInteger:iBlue forKey:@"blue"];
    [userDef setInteger:iWhite forKey:@"white"];
}
-(void)greenButtonAction{
    NSLog(@"greenButtonAction");
    label2.text=@"255";
    label1.text=@"0";
    label3.text=@"0";
    iReg=0;
    igreen=255;
    iBlue=0;
    
    redSlider.value=0;
    greenSlider.value=255;
    blueSlider.value=0;
    
    char strcommand[8]={'s','r','g','b','w','B','#','e'};
    strcommand [3] =0; //reg
    strcommand [2] =255; //green
    strcommand [1] =0; //blue
    strcommand [4] =iWhite;  //white
    strcommand[6] =209;
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcpLinker writeData:cmdData];
    NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
    [userDef setInteger:iReg forKey:@"reg"];
    [userDef setInteger:igreen forKey:@"green"];
    [userDef setInteger:iBlue forKey:@"blue"];
    [userDef setInteger:iWhite forKey:@"white"];
}

-(void)blueButtonAction{
    NSLog(@"blueButtonAction");
    label3.text=@"255";
    label2.text=@"0";
    label2.text=@"0";
    iReg=0;
    igreen=0;
    iBlue=255;
    
    redSlider.value=0;
    greenSlider.value=0;
    blueSlider.value=255;
    
    char strcommand[8]={'s','r','g','b','w','B','#','e'};
    strcommand [3] =0; //reg
    strcommand [2] =0; //green
    strcommand [1] =255; //blue
    strcommand [4] =iWhite;  //white
    strcommand[6] =209;
    
    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
    [tcpLinker writeData:cmdData];
    NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
    [userDef setInteger:iReg forKey:@"reg"];
    [userDef setInteger:igreen forKey:@"green"];
    [userDef setInteger:iBlue forKey:@"blue"];
    [userDef setInteger:iWhite forKey:@"white"];
}

-(void)whiteButtonAction{
    
    if(iWhite==0){
        iWhite=255;
        whiteSlider.value=255;
        [WhiteButton setTitle:@"on" forState:UIControlStateNormal];
    }else{
        iWhite=0;
        whiteSlider.value=0;
        [WhiteButton setTitle:@"off" forState:UIControlStateNormal];
    }
    [WhiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)save
{
    
    
    if (iReg==0&&igreen==0&&iBlue==0&&iWhite==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"WARMING_TITLE", @"Locale", nil) message:NSLocalizedStringFromTable(@"WARMING_ADDSCENES", @"Locale", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"WARMING_OKBUTTON", @"Locale", nil) otherButtonTitles:nil];
        [alert show];
        return;
        
    }else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[userDefault objectForKey:@"Scence"]];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:iReg],@"red",[NSNumber numberWithInt:igreen],@"green",[NSNumber numberWithInt:iBlue],@"blue",[NSNumber numberWithInt:iWhite],@"white",nameText.text,@"name",filePath,@"pathURL", nil];
        [arr addObject:dic];
        
        [userDefault setObject:arr forKey:@"Scence"];
        [delegate getScenceData:arr];
        NSUserDefaults *userDef= [NSUserDefaults  standardUserDefaults];
        [userDef setInteger:iReg forKey:@"reg"];
        [userDef setInteger:igreen forKey:@"green"];
        [userDef setInteger:iBlue forKey:@"blue"];
        [userDef setInteger:iWhite forKey:@"white"];
        
        
    }
    
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
}


//显示相册库进行选择图片
-(void)showImagePicker
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    //调用系统照片库
}

#pragma - mark delegate methods
//选择完成之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //改背景图为选择的图片, 并压缩图片到指定大小64*64
    setPictrueButton.imageView.image=[image imageByScalingForSize:CGSizeMake(60.0, 60.0)];
    setPictrueButton.imageView.layer.cornerRadius =30;

    
    //把该图片保存到沙盒中
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@+%@.jpg",nameText.text,[NSDate date]]];   // 保存文件的名称，不能使用png格式，png消耗内存太大。
    BOOL result = [UIImagePNGRepresentation(setPictrueButton.imageView.image) writeToFile: filePath  atomically:YES]; // 保存成功会返回YES
    if(result)
    {
        NSLog(@"save OK----%@, %@",filePath,[NSDate date]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark delegate methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消选择图片
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==nameText) {
        [nameText resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=185;
    frame.size.height +=185;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
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
