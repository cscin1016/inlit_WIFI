//
//  HNHHEQVisualizer.m
//  HNHH
//
//  Created by Dobango on 9/17/13.
//  Copyright (c) 2013 RC. All rights reserved.
//

#import "PCSEQVisualizer.h"
#import "UIImage+Color.h"
#import "ViewController.h"

#define kWidth 4
#define kHeight 80
#define kPadding 01
static  int mm = 0;    //标记柱子轮到那个柱子涨高低

#define  MUSICRATE 0.1
#define  MUSICRATESECOND 0.3
#define  MUSICRATETHRID 0.5

#define  LAYENUMBER 10

@implementation PCSEQVisualizer
{
    NSTimer* timer;
    NSArray* barArray;
    NSNumber*hing;
    NSDate *LastSendTime;
    
    int oldMusicNumber;
    int oldOneMusicNumber;
    int oldTwoMusicNumber;
    int oldThreeMusicNumber;
    int oldFourMusicNumber;
    
    int  oldSectNumber;
    int  newSectNumber;
    int  whoNumber;
}
@synthesize delegate;
@synthesize musicModeID;
- (id)initWithNumberOfBars:(int)numberOfBars
{
    self = [super init];
    if (self) {
        LastSendTime= [[NSDate alloc]init];
        hing = [[NSNumber alloc]init];
        
        self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(kWidth*numberOfBars), kHeight);
        
        NSMutableArray* tempBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        
        for(int i=0;i<numberOfBars;i++){
            UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth+i*kPadding, 0, kWidth, 1)];
            bar.image = [UIImage imageWithColor:self.barColor];
            [self addSubview:bar];
            [tempBarArray addObject:bar];
        }
        
        barArray = [[NSArray alloc]initWithArray:tempBarArray];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*2);
        self.transform = transform;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopTimer" object:nil];
    }
    return self;
}


-(void)start{
    self.hidden = NO;
}


-(void)stop{
    [timer invalidate];
    timer = nil;
}

-(void)sethight:(NSNumber*)hin{
    hing = hin;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (mm< [barArray count]) {
            
            UIImageView* bar = [barArray objectAtIndex:mm];
            CGRect rect = bar.frame;
            rect.origin.y =0;
            CGFloat hh = [hing floatValue];
            hh = fabs(hh);
            rect.size.height = hh*100; //0 -
            bar.frame = rect;
            mm++;
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            TcpClient *tcp = [TcpClient sharedInstance];
            if(tcp.currentArray.count)
            {
                NSInteger tempReg;
                NSInteger tempGreen;
                NSInteger tempBlue;
                NSInteger tempWhite;
                NSInteger iReg=0,igreen=0,iBlue=0,iWhite=0;
                
                if (musicModeID) {
                    
                    if([userDefaults boolForKey:@"YesNO"]==YES)
                    {
                        NSLog(@"亮度后后————————》》");
                        tempReg     =[userDefaults integerForKey:@"reg1"];
                        tempGreen   =[userDefaults integerForKey:@"green1"];
                        tempBlue    =[userDefaults integerForKey:@"blue1"];
                        tempWhite   =[userDefaults integerForKey:@"white1"];
                        
                        iReg    =   (rect.size.height*tempReg/255)*4;
                        igreen  =   (rect.size.height*tempGreen/255)*4;
                        iBlue   =   (rect.size.height*tempBlue/255)*4;
                        iWhite  =   (rect.size.height*tempWhite/255)*4;
                        
                        ////算法二
                        
                        
                        if ([LastSendTime timeIntervalSinceNow]<-0.07) {
                            LastSendTime=[[NSDate alloc]init];
                        }else{
                            return;
                        }
                        char strcommand[8]={'s','r','g','b','w','B','#','e'};
                        strcommand [3] =iReg;
                        strcommand [2] =igreen;
                        strcommand [1] =iBlue;
                        strcommand [4] =iWhite;
                        strcommand[6] =0x91; //保存209，16进制为0xd1  , 0x91
                        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
                        [tcp writeData:cmdData];
                        
                    }
                    else if ([userDefaults boolForKey:@"YesNO"]==NO)
                    {
                        //                        NSLog(@"亮度前前——》》》》》》");
                        tempReg     =(int)[userDefaults integerForKey:@"reg"];
                        tempGreen   =(int)[userDefaults integerForKey:@"green"];
                        tempBlue    =(int)[userDefaults integerForKey:@"blue"];
                        tempWhite   =(int)[userDefaults integerForKey:@"white"];
                        ////算法一
                        
                        
                        iReg    =   (rect.size.height*tempReg/255)*4;
                        igreen  =   (rect.size.height*tempGreen/255)*4;
                        iBlue   =   (rect.size.height*tempBlue/255)*4;
                        iWhite  =   (rect.size.height*tempWhite/255)*4;
                        //                NSLog(@"r=%d, g=%d, b=%d",iReg,igreen,iBlue);
                        ////算法二
                        
                        
                        if ([LastSendTime timeIntervalSinceNow]<-0.09) {
                            LastSendTime=[[NSDate alloc]init];
                        }else{
                            return;
                        }
                        char strcommand[8]={'s','r','g','b','w','B','#','e'};
                        strcommand [3] =iReg;
                        strcommand [2] =igreen;
                        strcommand [1] =iBlue;
                        strcommand [4] =iWhite;
                        strcommand[6] =0x91; //保存209，16进制为0xd1  , 0x91 不保存
                        //    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
                        NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
                        [tcp writeData:cmdData];
                    }
                }
                else
                {
                    switch (whoNumber) {
                        case 0:
                            oldMusicNumber=rect.size.height;
                            break;
                        case 1:
                            oldOneMusicNumber=rect.size.height;
                            break;
                        case 2:
                            oldTwoMusicNumber=rect.size.height;
                            break;
                        case 3:
                            oldThreeMusicNumber=rect.size.height;
                            break;
                        case 4:
                            oldFourMusicNumber=rect.size.height;
                            break;
                        default:
                            break;
                    }
                    whoNumber++;
                    if (whoNumber<4) {
                        return;
                    }else{
                        whoNumber=0;
                    }
                    
                    newSectNumber=(oldThreeMusicNumber+oldTwoMusicNumber+oldOneMusicNumber+oldMusicNumber)/4;
                    
                    if (newSectNumber>oldSectNumber) {
                        NSLog(@"最大:%d",newSectNumber);
                        oldSectNumber=newSectNumber;
                    }
                    
                    switch ([self levelChange:newSectNumber])
                    {
                        case 0:
                            iBlue   =   2+newSectNumber/2;
                            iReg    =   newSectNumber/3;
                            break;
                        case 1:
                            iReg   = newSectNumber/2;
                            igreen  = 10*(newSectNumber-10)/LAYENUMBER;
                            break;
                        case 2:
                            iBlue=15;
                            igreen=15;
                            break;
                        case 3:
                            igreen=20;
                            break;
                        case 4:
                            igreen  =   255.0*MUSICRATE*5*(newSectNumber-LAYENUMBER*3)/LAYENUMBER+20;
                            iReg    =   255.0*MUSICRATE*5*(LAYENUMBER*4-newSectNumber)/LAYENUMBER+20;
                            break;
                        case 5:
                            iReg    =   255.0*MUSICRATE*5*(LAYENUMBER*5-newSectNumber)/LAYENUMBER+40;
                            break;
                        case 6:
                            iReg    =   255.0*MUSICRATE*5*(newSectNumber-LAYENUMBER*5)/LAYENUMBER;
                            if(iReg>255){
                                iReg=255;
                                iWhite=255;
                            }
                            break;
                        default:
                            break;
                    }
                    
                    
                    char strcommand[8]={'s','r','g','b','w','B','#','e'};
                    strcommand [3] =iReg;
                    strcommand [2] =igreen;
                    strcommand [1] =iBlue;
                    strcommand [4] =iWhite;
                    strcommand [6] =0x91; //保存209，16进制为0xd1  , 0x91 不保存
                    NSData *cmdData = [NSData dataWithBytes:strcommand length:8];
                    [tcp writeData:cmdData];
                }
            }
        }else{
            mm=0;
            UIImageView* bar = [barArray objectAtIndex:mm];
            CGRect rect = bar.frame;
            rect.origin.y =0;
            CGFloat hh = [hing floatValue];
            hh = fabs(hh);
            rect.size.height = hh*130;
            bar.frame = rect;
            mm++;
        }
    }];
}

-(int)levelChange:(int)musicNumber{
    if (musicNumber>LAYENUMBER*5) {
        return 6;
    }else{
        return musicNumber/LAYENUMBER;
    }
}


-(void)ticker{
    
    [UIView animateWithDuration:.35 animations:^{
        for(UIImageView* bar in barArray){
            CGRect rect = bar.frame;
            rect.origin.y = 0;
            rect.size.height = arc4random() % kHeight + 1;
            bar.frame = rect;
        }
    }];
}

@end
