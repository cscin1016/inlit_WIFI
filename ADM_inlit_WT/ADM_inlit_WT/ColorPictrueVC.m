//
//  ColorPictrueVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "ColorPictrueVC.h"
#import "ViewController.h"

@interface ColorPictrueVC ()
{
    UIButton * cameraBtn;
}

@end

@implementation ColorPictrueVC
@synthesize pictureiView,imageTip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.title=@"ColorPicture";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor grayColor];
    
    //相机背景图
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-90-44, self.view.bounds.size.width, 90)];
    [imageView2 setImage:[UIImage imageNamed:@"home_index_btn@2x.png"]];
    [self.view addSubview:imageView2];

    
    
    //相机按钮
    UIImage *cameraBtnimage= [ UIImage imageNamed:@"bottom_cam_d@2x.png" ];
    cameraBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame =CGRectMake(136,[UIScreen mainScreen].bounds.size.height-90-44+13, 55 , 40 );
    [cameraBtn setBackgroundImage:cameraBtnimage forState:UIControlStateNormal];
    
    [cameraBtn addTarget:self action:@selector(cameraClick)  forControlEvents:UIControlEventTouchUpInside];
    cameraBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cameraBtn];
    
    
    
    //图片view
    
    pictureiView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-90-44)];
    [pictureiView setImage:[UIImage imageNamed:@"default_pic_4"]];
    [self.view addSubview:pictureiView];
    
    //触摸点view
    imageTip = [[UIImageView alloc] initWithFrame:CGRectMake(100,100, 14, 14)];
    [imageTip setImage:[UIImage imageNamed:@"color_cursor"]];
    [pictureiView addSubview:imageTip];
    
    
}

-(void)cameraClick
{
    NSLog(@"xx 相机");
    //Show Action Sheet: 1. Take Photo 2. Select Photo From Album
    UIActionSheet *photoBtnActionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Photo Library",@"Take Photo", nil];
    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [photoBtnActionSheet showInView:[self.view window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 0) {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:NO];
                //显示Image Picker
                [self presentViewController:imgPickerVC animated:NO completion:nil];
            }else {
                NSLog(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            NSLog(@"Album is not available.");
        }
    }
    if (buttonIndex == 1) {
        //Take Photo with Camera
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:NO];
                //显示Camera VC
                [self presentViewController:cameraVC animated:NO completion:nil];
                
            }else {
                NSLog(@"Camera is not available.");
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You don't have a camera" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
                [alert show];

            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Image Picker Controller canceled.");
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    //TODO:选择照片或者照相完成以后的处理
    NSLog(@"NSDictionary info = %@",info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"mediaType===%@",mediaType);
    
    //得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [pictureiView setImage:image];
    
    CALayer *imageLayer = pictureiView.layer;
    [imageLayer setMasksToBounds:YES];
    imageLayer.cornerRadius = CGRectGetHeight([pictureiView bounds]) / 2;;
    
    //判断是相册图还是拍照图，相册图就不保存， 拍照图就可以保存
    if ([info objectForKey:UIImagePickerControllerMediaMetadata]==nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([touches count]==1){
        self.view.backgroundColor=[self colorAtPixel:[[[touches allObjects] objectAtIndex:0] locationInView:self.view]];
        self.imageTip.center=[[[touches allObjects] objectAtIndex:0] locationInView:self.view];
    }
}

- (UIColor *)colorAtPixel:(CGPoint)point {
    point= CGPointMake(point.x,  point.y);
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f,0.0f, self.pictureiView.bounds.size.width,self.pictureiView.bounds.size.height), point)) {
        NSLog(@"不在区域");
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.pictureiView.image.CGImage;
    NSUInteger width = self.pictureiView.bounds.size.width;
    NSUInteger height =self.pictureiView.bounds.size.height;
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
    NSLog(@"R=%d   G===%d  B==%d    alpha===%d",(int)pixelData[0],(int)pixelData[1],(int)pixelData[2],(int)pixelData[3]);
    
    
    TcpClient *tcp = [TcpClient sharedInstance];
    if(tcp.currentArray.count)
    {
        
        char strcommand[8]={'s','r','g','b','w','B','#','e'};
        strcommand [3] =(int)pixelData[0];
        strcommand [2] =(int)pixelData[1];
        strcommand [1] =(int)pixelData[2];
        strcommand [4] = ((int)pixelData[0]+(int)pixelData[1]+(int)pixelData[2])/3;
        strcommand [5] = 0;
        strcommand[6] =0x91;
        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
        [tcp writeData:cmdData];
    }
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
