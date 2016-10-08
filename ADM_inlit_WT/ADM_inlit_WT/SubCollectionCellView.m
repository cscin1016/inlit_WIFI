//
//  SubCollectionCellView.m
//  TestZJMuseumIpad
//
//  Created by 胡 jojo on 13-10-11.
//  Copyright (c) 2013年 tracy. All rights reserved.
//

#import "SubCollectionCellView.h"

@implementation SubCollectionCellView

@synthesize iconImageView=_iconImageView;
@synthesize niandaiLabel=_niandaiLabel;
@synthesize titleLabel=_titleLabel;
@synthesize nameLabel=_nameLabel;
@synthesize contentLabel=_contentLabel;
@synthesize ipLabel=_ipLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initUI];
        
    }
    return self;
}


-(void) initUI
{

    self.userInteractionEnabled=YES;
    self.backgroundColor=[UIColor clearColor];
    //圆圈亮度条
    _iconImageView=[[UIImageView alloc] init];
    [_iconImageView setFrame:CGRectMake(10, self.frame.size.height/2-140/2, 140, 140)];

    [self addSubview:_iconImageView];

    //亮度值
     _niandaiLabel=[[UILabel alloc] init];
//    [_niandaiLabel setFrame:CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+10,_iconImageView.frame.origin.y, self.frame.size.width, 16)];
     [_niandaiLabel setFrame:CGRectMake(_iconImageView.frame.size.width/2-50, 10, _iconImageView.frame.size.width-40, 40)];
    [_niandaiLabel setBackgroundColor:[UIColor clearColor]];
    [_niandaiLabel setTextColor:[UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0]];
    [_niandaiLabel setFont:[UIFont fontWithName:@"Helvetica" size:28]];
    [_niandaiLabel setTextAlignment:NSTextAlignmentCenter];
    [_iconImageView addSubview:_niandaiLabel];
    
    // 百分值
     _titleLabel=[[UILabel alloc] init];
    [_titleLabel setFrame:CGRectMake(_iconImageView.frame.size.width/2-20, _niandaiLabel.frame.origin.y+25, _iconImageView.frame.size.width-40, 20)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0]];
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_iconImageView addSubview:_titleLabel];
    
    // name
    _nameLabel=[[UILabel alloc] init];
    [_nameLabel setFrame:CGRectMake(_iconImageView.frame.size.width/2-50, _titleLabel.frame.origin.y+25, _iconImageView.frame.size.width-40, 20)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [_iconImageView addSubview:_nameLabel];


    
    //lamps mac
     _contentLabel=[[UILabel alloc] init];
    [_contentLabel setFrame:CGRectMake(_iconImageView.frame.origin.x-20,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+15, self.frame.size.width, 55)];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setTextColor:[UIColor whiteColor]];
    [_contentLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
    [_contentLabel setTextAlignment:NSTextAlignmentCenter];
    [_iconImageView addSubview:_contentLabel];
    
    //lamps IP
    _ipLabel=[[UILabel alloc] init];
    [_ipLabel setFrame:CGRectMake(_iconImageView.frame.origin.x+20,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+55, 80, 11)];
    [_ipLabel setBackgroundColor:[UIColor clearColor]];
    [_ipLabel setTextColor:[UIColor whiteColor]];
    [_ipLabel setFont:[UIFont fontWithName:@"Helvetica" size:7]];
    [_ipLabel setTextAlignment:NSTextAlignmentCenter];
    [_iconImageView addSubview:_ipLabel];



}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
