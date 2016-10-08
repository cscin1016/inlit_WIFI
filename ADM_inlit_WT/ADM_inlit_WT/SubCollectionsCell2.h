//
//  SubCollectionsCell2.h
//  TestZJMuseumIpad
//
//  Created by 胡 jojo on 13-10-10.
//  Copyright (c) 2013年 tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCollectionCellView.h"

@interface SubCollectionsCell2 : UITableViewCell
{

    SubCollectionCellView *_cellView1;
    
    SubCollectionCellView *_cellView2;



}

@property(retain,nonatomic) SubCollectionCellView *cellView1;
@property(retain,nonatomic) SubCollectionCellView *cellView2;

-(void) initUI;

@end
