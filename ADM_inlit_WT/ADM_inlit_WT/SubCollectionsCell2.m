//
//  SubCollectionsCell2.m
//  TestZJMuseumIpad
//
//  Created by 胡 jojo on 13-10-10.
//  Copyright (c) 2013年 tracy. All rights reserved.
//


#define rowcellCount 2
#define RMarginX 0
#define RMarginY 0
#import "SubCollectionsCell2.h"

@implementation SubCollectionsCell2

@synthesize cellView1=_cellView1;
@synthesize cellView2=_cellView2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self initUI];
        
    }
    
    return self;
}



-(void) initUI
{


    NSInteger width = 320/rowcellCount;
    
        
    _cellView1=[[SubCollectionCellView alloc] initWithFrame:CGRectMake(0*width + RMarginX, RMarginY, width - 2*RMarginX, 160 - 2*RMarginY)];
        
    [self.contentView addSubview:_cellView1];

        
 
    _cellView2=[[SubCollectionCellView alloc] initWithFrame:CGRectMake(1*width + RMarginX, RMarginY, width - 2*RMarginX, 160 - 2*RMarginY)];
    
    [self.contentView addSubview:_cellView2];


    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}


@end
