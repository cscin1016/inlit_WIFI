//
//  TimerCell.h
//  AD_BL
//
//  Created by apple on 14-6-16.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerCell : UITableViewCell


@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIButton *titleImage;

@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,strong) UILabel *operationLabel;

@end
