//
//  SubCollectionCellView.h
//  TestZJMuseumIpad
//
//  Created by 胡 jojo on 13-10-11.
//  Copyright (c) 2013年 tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCollectionCellView : UIView
{

    UIImageView *_iconImageView;//圆圈
    
    UILabel *_niandaiLabel; //亮度值

    UILabel *_titleLabel;  // 百分值
    
    UILabel *_nameLabel; // name
    
    UILabel *_contentLabel; //lamps mac 地址
    UILabel *_ipLabel; //lamps ip 地址
}

@property(retain,nonatomic) UIImageView *iconImageView;
@property(retain,nonatomic) UILabel *niandaiLabel;
@property(retain,nonatomic) UILabel *titleLabel;
@property(retain,nonatomic) UILabel *nameLabel;
@property(retain,nonatomic) UILabel *contentLabel;
@property(retain,nonatomic) UILabel *ipLabel;

-(void) initUI;

@end
