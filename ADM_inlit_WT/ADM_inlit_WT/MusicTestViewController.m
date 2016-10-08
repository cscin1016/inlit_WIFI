//
//  MusicTestViewController.m
//  ADM_Lights
//
//  Created by admin on 14-4-19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "MusicTestViewController.h"

#import "PCSEQVisualizer.h"
#import "VideoViewController.h"

@interface MusicTestViewController ()
{
    float  *_waveformData;
    UInt32 _waveformDrawingIndex;
    UInt32 _waveformFrameRate;
    UInt32 _waveformTotalBuffers;
    
    PCSEQVisualizer* eq;
    NSMutableArray*MP3Arr;
    NSInteger index;//标记当前播放歌曲MP3Arr index
    VideoViewController *videoView;
    
    NSTimer *Timer;//播放计时器
}

@end

static int TimerValue=0;

@implementation MusicTestViewController
@synthesize playButton;
@synthesize currTime,endTime;
@synthesize framePositionSlider;

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
    
    MP3Arr = [[NSMutableArray alloc]init];
    
    
    //获取工程所有mp3文件
    NSString *fileManage = [[NSBundle mainBundle]  resourcePath ];
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath: fileManage ];
    for (int n = 0;n< fileNames.count; n++) {
        NSString*temp = [fileNames objectAtIndex:n];
        NSRange range = [temp rangeOfString:@"mp3"];
        if (range.length >0){
            NSString*path = [fileManage stringByAppendingPathComponent:temp];
            [MP3Arr addObject:path];
        }
    }
    index = 0 ;
    [self openFileWithFilePathURL:[NSURL fileURLWithPath:[MP3Arr objectAtIndex:0] ]];
    //建立 柱形效果图
    eq = [[PCSEQVisualizer alloc]initWithNumberOfBars:46];
    CGRect frame = eq.frame;
    frame.origin.x = (self.view.frame.size.width - eq.frame.size.width)/2;
    frame.origin.y = (self.view.frame.size.height - eq.frame.size.height)/3;
    eq.frame = frame;
    eq.musicModeID = 0;
    
    [self.view addSubview:eq];
    eq.backgroundColor = [UIColor clearColor];
    [eq start];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(update:) name:@"update" object:nil];
    
    //音频时间
    currTime.text =@"00:00";
    endTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.audioFile.totalDuration/60,(int)self.audioFile.totalDuration%60];
    
    //颜色亮度切换
    musicMode=[[UISegmentedControl alloc] initWithItems:nil];
    [musicMode insertSegmentWithTitle: NSLocalizedStringFromTable(@"Music_Color", @"Locale", nil) atIndex: 0 animated: NO ];
    [musicMode insertSegmentWithTitle: NSLocalizedStringFromTable(@"Music_Bright", @"Locale", nil) atIndex: 1 animated: NO ];
    musicMode.selectedSegmentIndex=0;
    musicMode.frame=CGRectMake(28,33,124, 29);
    musicMode.backgroundColor =[UIColor clearColor];
    [ musicMode addTarget:self action: @selector(musicModeActon:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:musicMode];
}


-(void)update:(NSNotification*) notification{
    NSURL *num = [[notification userInfo] objectForKey:@"the"];
    for (int i=1; i<MP3Arr.count; i++) {
        NSLog(@"MP3Arr.count:%lu",(unsigned long)MP3Arr.count);
        if ([num isEqual:[[MP3Arr objectAtIndex:i] objectForKey:@"the"]]){
            NSLog(@"相等");
            return;
        }else{
            NSLog(@"不相等");
        }
    }
  
    index=MP3Arr.count;
    [MP3Arr addObject:[notification userInfo]];
    
    if( ![[EZOutput sharedOutput] isPlaying] ){
        if( self.eof ){
            [self.audioFile seekToFrame:0];
        }
        [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
        [EZOutput sharedOutput].outputDataSource = self;
    }else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
        [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedStringFromTable(@"TITLE_Music", @"Locale", nil);
    //右按钮添加文件
    endTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.audioFile.totalDuration/60,(int)self.audioFile.totalDuration%60];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_list"] style:UIBarButtonItemStylePlain target:self action:@selector(addList)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
}



-(void)musicModeActon:(id)sender
{
    eq.musicModeID=musicMode.selectedSegmentIndex;
}


-(void)addList
{
    videoView=[[VideoViewController alloc]init];
    [self.navigationController pushViewController:videoView animated:YES];
    
}
-(void)play:(id)sender {
    
    if ([endTime.text isEqualToString:@""])
    {
        //设置总时长
        endTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.audioFile.totalDuration/60,(int)self.audioFile.totalDuration%60];
        
    }
    if( ![[EZOutput sharedOutput] isPlaying] ){
        if( self.eof ){
            [self.audioFile seekToFrame:0];
        }
        [playButton setBackgroundImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];;
        NSLog(@"时间总长度＝%f",self.audioFile.totalDuration);
         NSLog(@"self.framePositionSlider.maximumValue==%d",(int)self.audioFile.totalFrames);
        //设置定时器
        Timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(process) userInfo:nil repeats:YES];
         TimerValue=0;
        
        
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [self StartPlayer];
        
    }else {
        [playButton setBackgroundImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
        [Timer invalidate];
        TimerValue=1;
    }
}
-(void)nextPlay:(id)sender{
    index++;
    if (index==MP3Arr.count) {
        index = 0;
    }
    
    if( ![[EZOutput sharedOutput] isPlaying] ){
        if( self.eof ){
            [self.audioFile seekToFrame:0];

        }
        if (index>0) {
            [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
        }else{
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:[MP3Arr objectAtIndex:index] ]];
        }
        [EZOutput sharedOutput].outputDataSource = self;
         [self StartPlayer];
        
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
        if (index>0) {
            [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
        }else{
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:[MP3Arr objectAtIndex:index] ]];
        }
        
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
        [self StartPlayer];
    }
}
-(void)beforePlay:(id)sender{
    index--;
    [Timer invalidate];
    if (index==-1) {
        index = MP3Arr.count-1;
    }
    if( ![[EZOutput sharedOutput] isPlaying] ){
    if( self.eof ){
        [self.audioFile seekToFrame:0];
        endTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.audioFile.totalDuration/60,(int)self.audioFile.totalDuration%60];
    }
    if (index>0) {
        NSLog(@"%@",[MP3Arr objectAtIndex:index]);
        [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
    }else{
        [self openFileWithFilePathURL:[NSURL fileURLWithPath:[MP3Arr objectAtIndex:index] ]];
    }
    [EZOutput sharedOutput].outputDataSource = self;
        [self StartPlayer];
        
    }else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
        if (index>0) {
            [self openFileWithFilePathURL:[[MP3Arr objectAtIndex:index] objectForKey:@"the"] songName:[[MP3Arr objectAtIndex:index] objectForKey:@"songName"]];
        }else{
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:[MP3Arr objectAtIndex:index] ]];
        }
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
        [self StartPlayer];
        
    }
    
    
}

//初始化播放器
-(void)StartPlayer
{
    // 0.01 秒更新一次
    Timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(process) userInfo:nil repeats:YES];
    TimerValue=0;
    endTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.audioFile.totalDuration/60,(int)self.audioFile.totalDuration%60];
}



-(void)seekToFrame:(id)sender {
    NSLog(@"self.framePositionSlider==%lld",(SInt64)[(UISlider*)sender value]);

    [self.audioFile seekToFrame:(SInt64)[(UISlider*)sender value]];

    currTime.text= [NSString stringWithFormat:@"%02d:%02d",(int)((int)self.audioFile.totalDuration*(SInt64)[(UISlider*)sender value]/(int)self.audioFile.totalFrames)/60,(int)((int)self.audioFile.totalDuration*(SInt64)[(UISlider*)sender value]/(int)self.audioFile.totalFrames)%60];
}

//计时器方法
-(void)process
{
    //注意数值类型SInt64
    currTime.text=[NSString stringWithFormat:@"%02d:%02d",(int)((int)self.audioFile.totalDuration*(SInt64)framePositionSlider.value/(int)self.audioFile.totalFrames)/60,(int)((int)self.audioFile.totalDuration*(SInt64)framePositionSlider.value/(int)self.audioFile.totalFrames)%60];
}

-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    [[EZOutput sharedOutput] stopPlayback];
    self.audioFile                 = [EZAudioFile audioFileWithURL:filePathURL];
    self.audioFile.audioFileDelegate = self;
    self.eof                       = NO;
    self.filePathLabel.text = filePathURL.lastPathComponent;
    self.framePositionSlider.maximumValue = (float)self.audioFile.totalFrames;
}

-(void)openFileWithFilePathURL:(NSURL*)filePathURL songName:(NSString *)songName{
    [[EZOutput sharedOutput] stopPlayback];
    self.audioFile                 = [EZAudioFile audioFileWithURL:filePathURL];
    self.audioFile.audioFileDelegate = self;
    self.eof                       = NO;
    self.filePathLabel.text = songName;
    self.framePositionSlider.maximumValue = (float)self.audioFile.totalFrames;
    NSLog(@"self.framePositionSlider.maximumValue==%f",(float)self.audioFile.totalFrames);
}

-(void)audioFile:(EZAudioFile *)audioFile updatedPosition:(SInt64)framePosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        if( !self.framePositionSlider.touchInside ){
            self.framePositionSlider.value = (float)framePosition;
            if ((float)framePosition==self.audioFile.totalFrames) {
                [self nextPlay:audioFile];
            }
        }
    });
}
#pragma mark - EZAudioFileDelegate
-(void)audioFile:(EZAudioFile *)audioFile readAudio:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    if( [EZOutput sharedOutput].isPlaying ){
        dispatch_async(dispatch_get_main_queue(), ^{
            //获取取音频
            NSNumber *buffe = [[NSNumber alloc]initWithFloat:**buffer];
            //设计柱子高度
            [eq sethight:buffe];
        });
    }
}

#pragma mark - EZOutputDataSource
-(AudioBufferList *)output:(EZOutput *)output needsBufferListWithFrames:(UInt32)frames withBufferSize:(UInt32 *)bufferSize {
    if( self.audioFile ){
        if( self.eof ){
            [self nextPlay:self.audioFile];
            [self.audioFile seekToFrame:0];
            self.eof = NO;
        }
        
        // 分配缓冲区列表来保存文件的数据
        AudioBufferList *bufferList = [EZAudio audioBufferList];
        BOOL eof;
        [self.audioFile readFrames:frames audioBufferList:bufferList bufferSize:bufferSize eof:&eof];
        self.eof = eof;
        // Reached the end of the file on the last read
        if( eof ){
            [EZAudio freeBufferList:bufferList];
            return nil;
        }
        return bufferList;
    }
    return nil;
}

-(AudioStreamBasicDescription)outputHasAudioStreamBasicDescription:(EZOutput *)output {
    return self.audioFile.clientFormat;
}


- (void)viewDidUnload {
    [super viewDidUnload];
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
