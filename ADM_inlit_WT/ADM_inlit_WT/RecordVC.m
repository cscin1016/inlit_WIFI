//
//  RecordVC.m
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "RecordVC.h"
#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface RecordVC ()
{
     NSDate *LastSendTime;
}


@end

@implementation RecordVC
@synthesize progressView,theimageView,shapeLayer,displayLink,loopCount;
@synthesize pv1;

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
    LastSendTime= [[NSDate alloc]init];
    // Do any additional setup after loading the view.
    self.title =NSLocalizedStringFromTable(@"TITLE_Record", @"Locale", nil);
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"app_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    
    //录音图像
    
    UIImage *recodeImage = [UIImage imageNamed:@"record"];
    
    UIImageView *recodeImageView  = [[UIImageView alloc] initWithImage:recodeImage];
    
    recodeImageView.frame =CGRectMake(0,[UIScreen mainScreen].bounds.size.height-64-recodeImage.size.height,  self.view.bounds.size.width, recodeImage.size.height);
    recodeImageView.userInteractionEnabled = YES;
    [self.view addSubview:recodeImageView];
    
    
    //最小最大按钮
    
    UIImage *minImage = [UIImage imageNamed:@"record_min"];
    
    UIImageView *minImageView  = [[UIImageView alloc] initWithImage:minImage];
    
    minImageView.frame =CGRectMake(20,[UIScreen mainScreen].bounds.size.height-64-minImage.size.height-60, minImage.size.width, minImage.size.height);
    minImageView.userInteractionEnabled = YES;
//    [self.view addSubview:minImageView];
    
    UIImage *maxImage = [UIImage imageNamed:@"record_max"];
    
    UIImageView *maxImageView  = [[UIImageView alloc] initWithImage:maxImage];
    
    maxImageView.frame =CGRectMake(270,[UIScreen mainScreen].bounds.size.height-64-maxImage.size.height-65, maxImage.size.width+5, maxImage.size.height+5);
    maxImageView.userInteractionEnabled = YES;
//    [self.view addSubview:maxImageView];
    
    
    
    //录音按钮
    
    UIImage *btView = [UIImage imageNamed:@"record_off"];
    UIImage *btViewDown = [UIImage imageNamed:@"record_on"];
    
    NSLog(@"height==%f--width==%f",btView.size.height,btView.size.width);
    
    recordButton =[UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame =CGRectMake(SCREENWIDTH/2-btView.size.width/2, [UIScreen mainScreen].bounds.size.height-64-btView.size.height, btView.size.width, btView.size.height);
    [recordButton setImage:btView forState:UIControlStateNormal];
    [recordButton setImage:btViewDown forState:UIControlStateSelected];
    recordButton.selected=NO;
    
    [recordButton addTarget:self action:@selector(isRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:recordButton];
    
    //音调长短，圆形进度条
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    
    progressView.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-btView.size.height-20, 320, 40);
    progressView.progress=0;
    [self.view addSubview:progressView];
    
    
    //    pv1 = [[AMProgressView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-btView.size.height-20, 320, 25)
    //                              andGradientColors:[NSArray arrayWithObjects:[UIColor blueColor], nil]
    //                               andOutsideBorder:NO
    //                                    andVertical:NO];
    //    // Display
    //    pv1.emptyPartAlpha = 1.0f;
    //    pv1.backgroundColor = [UIColor blackColor];
    //    [self.view addSubview:pv1];
    
    
    
    //playBUtton
    UIButton * play =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    play.frame =CGRectMake(220, 340, 60, 30);
    //    connectBt.titleLabel=@"connect";
    [ play setTitle:@"play" forState:UIControlStateNormal];
    [ play setTitle:@"playstop" forState:UIControlStateSelected];
    play.selected=NO;
    
    play.tintColor=[UIColor whiteColor];
    [play addTarget:self action:@selector(paly:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:play];
    //    [play release];
    
    
    
    [self setupLeftMenuButton];
    
    
}
-(void)paly:(UIButton*)sender
{
    if(sender.selected==YES){
        sender.selected=NO;
        
        
        [self stopPlaying];
        
        
        
    }else{
        sender.selected=YES;
        
        [self playClick];
        
    }
}

-(void)stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
    
    
}



-(void)playClick
{
    NSLog(@"playRecording");
    
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
    
}
//录音事件
-(void)isRecord:(UIButton*)sender
{
    if(sender.selected==YES){
        sender.selected=NO;
        [self stopRecording];
        self.title =NSLocalizedStringFromTable(@"Mic_OFF", @"Locale", nil);

        
        
    }else{
        sender.selected=YES;
        
        [self startRecording];
        self.title =NSLocalizedStringFromTable(@"Mic_ON", @"Locale", nil);
        
    }
    
}



-(void)startRecording
{
    audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    /////////////同时能播放音乐
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    ///////////
    UInt32 mix_override = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (mix_override), &mix_override);
    //////////
    
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    //    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.meteringEnabled = YES;
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    
    
    
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[audioRecorder updateMeters];
	NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
    
    float linear = pow (10, [audioRecorder peakPowerForChannel:0]/20 );
    NSLog(@"音量的最大值===%f",linear);//音量的最大值
    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0]/20 );
    NSLog(@"平均值===%f",linear1);//获取音量的平均值
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    TcpClient *tcp = [TcpClient sharedInstance];
    if (linear1>0.03) {
        
        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
        
        
        if(tcp.currentArray.count)
        {
            NSLog(@"to do");
            
            
            NSInteger tempReg;
            NSInteger tempGreen;
            NSInteger tempBlue;
            NSInteger tempWhite;
            tempReg     =[userDefaults integerForKey:@"reg"];
            tempGreen   =[userDefaults integerForKey:@"green"];
            tempBlue    =[userDefaults integerForKey:@"blue"];
            tempWhite   =[userDefaults integerForKey:@"white"];
            
            int iReg,igreen,iBlue,iWhite;
            
            iReg =linear1*tempReg;
            igreen  =linear1*tempGreen;
            iBlue =linear1*tempBlue;
            iWhite =linear1*tempWhite;
            NSLog(@"r=%d, g=%d, b=%d",iReg,igreen,iBlue);
            
            if ([LastSendTime timeIntervalSinceNow]<-0.1) {
                LastSendTime=[[NSDate alloc]init];
            }else{
                return;
            }
            
            char strcommand[8]={'s','r','g','b','w','B','#','e'};
            strcommand [3] =iReg;
            strcommand [2] =igreen;
            strcommand [1] =iBlue;
            strcommand [4] =iWhite;
            strcommand[6] =0x91; //保存209，16进制为0xd1
            //    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
            NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
            [tcp writeData:cmdData];
        }
        
        
    }
    else {
        
        Pitch = 0.0;
        //        if(tcp.asyncSocket.isConnected)
        //        {
        //            NSLog(@"to do");
        //
        //
        //            int tempReg;
        //            int tempGreen;
        //            int tempBlue;
        //            tempReg     =[userDefaults integerForKey:@"reg"];
        //            tempGreen   =[userDefaults integerForKey:@"green"];
        //            tempBlue    =[userDefaults integerForKey:@"blue"];
        //
        //
        //            int iReg,igreen,iBlue,iWhite;
        //
        //            iReg =tempReg;
        //            igreen  =tempGreen;
        //            iBlue =tempBlue;
        //            iWhite =tempReg;
        //            NSLog(@"r=%d, g=%d, b=%d",iReg,igreen,iBlue);
        //
        //
        //            char strcommand[8]={'s','r','g','b','w','B','#','e'};
        //            strcommand [3] =iReg;
        //            strcommand [2] =igreen;
        //            strcommand [1] =iBlue;
        //            strcommand [4] =iWhite;
        //            strcommand[6] =209; //保存209，16进制为0xd1
        //            //    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
        //            NSData *cmdData = [NSData dataWithBytes:strcommand length:9];
        //
        //            //        NSString *requestStr = [NSString stringWithFormat:@"%@\r\n",self.tftxt.text];
        //            [tcp writeData:cmdData];
        //        }
        //
    }
    //Pitch =linear1;
    NSLog(@"Pitch==%f",Pitch);
    //    _customRangeBar.value = Pitch;//linear1+.30;
    [progressView setProgress:Pitch];
    
    //    pv1.progress = Pitch;
    
    //    float minutes = floor(audioRecorder.currentTime/60);
    //    float seconds = audioRecorder.currentTime - (minutes * 60);
    
    //    NSString *time = [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];
    //    [self.statusLabel setText:[NSString stringWithFormat:@"%@ sec", time]];
    NSLog(@"recording");
    
}
-(void)stopRecording
{
    [audioRecorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    [timerForPitch invalidate];
    timerForPitch = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self stopRecording];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stopRecording];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    
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
