//
//  MusicTestViewController.h
//  ADM_Lights
//
//  Created by admin on 14-4-19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "EZAudio.h"

@interface MusicTestViewController : UIViewController<EZAudioFileDelegate,EZOutputDataSource>
{
    UISegmentedControl *musicMode;
}
// EZAudioFile 表示当前选定的音频文件
@property (nonatomic,strong) EZAudioFile *audioFile;


@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *filePathLabel;
@property (weak, nonatomic) IBOutlet UILabel *currTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UISlider *framePositionSlider;
 

//指示是否已经到达文件的末尾
@property (nonatomic,assign) BOOL eof;

-(IBAction)play:(id)sender;
-(IBAction)nextPlay:(id)sender;
-(IBAction)beforePlay:(id)sender;
-(IBAction)seekToFrame:(id)sender;

@end
