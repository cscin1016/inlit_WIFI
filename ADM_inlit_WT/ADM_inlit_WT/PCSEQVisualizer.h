//
//  HNHHEQVisualizer.h
//  HNHH
//
//  Created by Dobango on 9/17/13.
//  Copyright (c) 2013 RC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol MusicDelegate1 <NSObject>

-(void)musicPlaying:(float)maxVoice;

@end

@interface PCSEQVisualizer : UIView


@property (nonatomic, retain) UIColor* barColor;
@property (assign,nonatomic)BOOL musicModeID;


- (id)initWithNumberOfBars:(int)numberOfBars;

//Starts NSTimer and begins the animation
-(void)start;


-(void)sethight:(NSNumber*)hin;
//Stops NSTimer by invalidating and stops the animation
-(void)stop;
@property (assign) id <MusicDelegate1> delegate;

@end
