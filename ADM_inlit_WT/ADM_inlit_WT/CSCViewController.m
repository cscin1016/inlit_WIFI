//
//  CSCViewController.m
//  imageOperating
//
//  Created by apple on 14-6-11.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#define MAX_NUMBER_LIGHT 10
#define DIAMETER 50

#import "CSCViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface CSCViewController (){
    
    NSInteger numberOfLight;//当前连接了多少个灯
    int selectLightMove;//选中某个圈进行移动。-1表示未选中,0-9表示移动的哪个灯
    
    UIImageView *ColorView[MAX_NUMBER_LIGHT];//10个圈
    CGRect mPieRect[MAX_NUMBER_LIGHT];//每个圈的坐标
    NSMutableArray *IPArray;
}

@end

@implementation CSCViewController

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
    //改背景图为选择的图片
    self.selectedImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark delegate methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消选择图片
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    UIBarButtonItem *mySearchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(showImagePicker)];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:mySearchButton, nil];
    self.navigationItem.rightBarButtonItems = myButtonArray;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    selectLightMove=-1;//设置当前能移动的灯泡为未选中
    
    
    self.view.tag=10000;
    
    //默认一张背景图片
    self.selectedImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64-30)];
    self.selectedImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"11.jpg"]];
    self.selectedImage.userInteractionEnabled=NO;
    [self.view addSubview:self.selectedImage];
    
    self.title = NSLocalizedStringFromTable(@"TITLE_Picture", @"Locale", nil);
    
    //设置10个默认感应区域
    CGPoint point;
    for (int i = 0; i < MAX_NUMBER_LIGHT; i++){
        point.x = 80+(DIAMETER/2+20)*(i%5);
		point.y = 80+(DIAMETER/2+40)*(i/5);
        mPieRect[i] =CGRectMake (point.x - DIAMETER/2, point.y - DIAMETER, DIAMETER, DIAMETER); //每个圈的坐标
        
        ColorView[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_cursor.png"]];
        ColorView[i].frame =mPieRect[i];
        ColorView[i].backgroundColor=[UIColor clearColor];
        ColorView[i].hidden=NO;
        ColorView[i].userInteractionEnabled=NO;
        
        [self.view addSubview:ColorView[i]];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    IPArray = [[NSMutableArray alloc] initWithCapacity:0];
    IPArray=[userDefaults objectForKey:@"numberOfLight"]; // 得到连接灯泡的数组
    NSLog(@"灯的数组IP＝＝%@",IPArray);
    
    numberOfLight=[userDefaults integerForKey:@"numberOfLight"]; //获取灯泡的连接个数
    if (numberOfLight!=0) {
        for (int i=0; i<numberOfLight; i++) {
            if (i<10) {
                ColorView[i].hidden=NO;  //显示几个灯泡图标
            }
        }
    }
    //隐藏剩下的灯泡图标
    for (NSInteger i=numberOfLight; i<10; i++) {
        ColorView[i].hidden=YES;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self.view];
    for (int i=0; i<numberOfLight; i++) {
        if (CGRectContainsPoint (mPieRect[i], touched)){
            selectLightMove=i;
            NSLog(@"selectLightMove.tag===%d",selectLightMove);
            break;
        }
    }
    if (selectLightMove>=0) {//如果有选中，则改变背景图，selectLightMove作为标记
        self.view.backgroundColor=[self colorAtPixel:CGPointMake(touched.x+25, touched.y+DIAMETER)];
        
        ColorView[selectLightMove].center=CGPointMake(touched.x+DIAMETER/2, touched.y+DIAMETER/2);
        if (touched.x>=0&&touched.x<=300) {
            mPieRect[selectLightMove]=CGRectMake(touched.x, touched.y, DIAMETER, DIAMETER); // 得到选择灯的坐标
        }
        [ColorView[selectLightMove] setImage:[UIImage imageNamed:@"photo_cursor.png"]];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self.view];
    if (selectLightMove>=0) {
        self.view.backgroundColor=[self colorAtPixel:CGPointMake(touched.x+25, touched.y+DIAMETER)];
        if (touched.x>=0&&touched.x<=300) {
            ColorView[selectLightMove].center=CGPointMake(touched.x+DIAMETER/2, touched.y+DIAMETER/2);
            mPieRect[selectLightMove]=CGRectMake(touched.x, touched.y, DIAMETER, DIAMETER);
        }
        
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self.view];
    if (selectLightMove>=0) {
         [ColorView[selectLightMove] setImage:[UIImage imageNamed:@"photo_cursor.png"]];
         if (touched.x>=0&&touched.x<=300) {
        mPieRect[selectLightMove]=CGRectMake(touched.x, touched.y, DIAMETER, DIAMETER);
         }
    }
    selectLightMove=-1; //移动结束标记 －1未选中
}

- (UIColor *)colorAtPixel:(CGPoint)point {
    point= CGPointMake(point.x,  point.y);
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f,0.0f, self.selectedImage.bounds.size.width,self.selectedImage.bounds.size.height), point)) {
        NSLog(@"不在区域");
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.selectedImage.image.CGImage;
    NSUInteger width = self.selectedImage.bounds.size.width;
    NSUInteger height =self.selectedImage.bounds.size.height;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast |kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context,kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] /255.0f;
    CGFloat green = (CGFloat)pixelData[1] /255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] /255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] /255.0f;
    
    
    NSLog(@"selectLightMove--->>> %d",selectLightMove);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int tempWhite   =(int)[userDefaults integerForKey:@"white"];
    TcpClient *temptcp = [TcpClient sharedInstance];
    
    if(temptcp.currentArray.count)
    {
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =(tempWhite*(1-alpha)+red*alpha)*255; //reg;
        strcommand [2] =(tempWhite*(1-alpha)+green*alpha)*255; //green;
        strcommand [1] =(tempWhite*(1-alpha)+blue*alpha)*255; //blue;
        strcommand [4] = tempWhite;  //white
        strcommand [5] = 0;
        strcommand[6] =0x91;
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [temptcp writeData:cmdData picNumber:selectLightMove];
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
