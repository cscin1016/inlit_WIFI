//
//  RecordVC.h
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AMProgressView.h"

@interface RecordVC : UIViewController<UIGestureRecognizerDelegate>
{
    UIButton *recordButton;
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    
    float Pitch;
    NSTimer *timerForPitch;
}

@property (strong, nonatomic)  UIImageView *theimageView;
@property (strong, nonatomic)  UIProgressView *progressView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSUInteger loopCount;
@property (nonatomic, strong) AMProgressView *pv1;

@end
