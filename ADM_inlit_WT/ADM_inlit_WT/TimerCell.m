//
//  TimerCell.m
//  AD_BL
//
//  Created by apple on 14-6-16.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "TimerCell.h"


@implementation TimerCell
@synthesize timeLabel,titleImage,segment,operationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleImage = [[UIButton alloc]init];
        self.titleImage.frame = CGRectMake(250, 14, 60, 60);
        [self addSubview:self.titleImage];
        
        
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 240, 30)];
        self.timeLabel.font=[UIFont systemFontOfSize:24];
        self.timeLabel.textColor=[UIColor grayColor];
        [self addSubview:self.timeLabel];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 87, SCREENWIDTH, 1)];
        line.backgroundColor=[UIColor whiteColor];
        [self addSubview:line];
        
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedStringFromTable(@"Timer_OFF", @"Locale", nil),NSLocalizedStringFromTable(@"Timer_ON", @"Locale", nil),nil];
        self.segment=[[UISegmentedControl alloc]initWithItems:segmentedArray];
        self.segment.frame=CGRectMake(50, 46, 150, 30);
        self.segment.hidden=YES;
        [self addSubview:self.segment];
        
        
        self.operationLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 36, 180, 30)];
        self.operationLabel.font=[UIFont systemFontOfSize:16];
        self.operationLabel.text=NSLocalizedStringFromTable(@"Timer_OFF", @"Locale", nil);
        self.operationLabel.textAlignment =NSTextAlignmentCenter;
        self.operationLabel.textColor=[UIColor darkGrayColor];
        [self addSubview:self.operationLabel];
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
