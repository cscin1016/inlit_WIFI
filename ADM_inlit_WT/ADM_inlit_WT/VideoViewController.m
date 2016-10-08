//
//  VideoViewController.m
//  ADM_Lights
//
//  Created by admin on 14-4-24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController (){
    NSArray *mediaItems;
    NSMutableArray *tempList;
    NSMutableArray *URLList;
}
- (void)loadMediaItemsForMediaType:(MPMediaType)mediaType;
@end

@implementation VideoViewController
- (void)loadMediaItemsForMediaType:(MPMediaType)mediaType
{
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    NSNumber *mediaTypeNumber= [NSNumber numberWithInt:mediaType];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:mediaTypeNumber forProperty:MPMediaItemPropertyMediaType];
    [query addFilterPredicate:predicate];
    mediaItems = [query items];
//    NSLog(@"mediaItems:%@",mediaItems);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMediaItemsForMediaType:MPMediaTypeMusic];
    tempList =[[NSMutableArray alloc] initWithCapacity:30];
    URLList =[[NSMutableArray alloc] initWithCapacity:30];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    

    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ok"] style:UIBarButtonItemStylePlain target:self action:@selector(OKClick)];
    //    myAddButton.tintColor=[UIColor greenColor];
    self.navigationItem.rightBarButtonItem = myAddButton;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor greenColor];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return  mediaItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];// 防止cell重用错乱，cell ID 应该不一致

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        
    }
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    MPMediaItem *item = [mediaItems objectAtIndex:row];
    cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
    cell.tag = row;
    
    return cell;
    
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //根据当前行的值,代理传值

    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tempList addObject:[mediaItems objectAtIndex:indexPath.row]];
        
        
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tempList removeObject:[mediaItems objectAtIndex:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)OKClick
{
    for (int i=0; i<tempList.count; i++) {
        MPMediaItem *item = [tempList objectAtIndex:i];
        
        NSURL* assetUrl = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:assetUrl,@"the",[item valueForProperty:MPMediaItemPropertyTitle],@"songName", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:dic];
    }
   
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
