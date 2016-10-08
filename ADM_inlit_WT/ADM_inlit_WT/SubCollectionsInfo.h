//
//  SubCollectionsInfo.h
//  TestZJMuseum
//
//  Created by 胡 jojo on 13-8-27.
//  Copyright (c) 2013年 tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCollectionsInfo : NSObject
{

    
    NSString *_iconString;
    NSString *_niandaiString;
    NSString *_titleString;
    NSString *_contentString;
    NSString *_xmlFile;
    NSString *_idString;
    NSString *_nbidString;
    NSString *_timenmString;
    NSString *_stimeString;
    NSString *_etimeString;
    NSString *_zipFile;
    NSString *_md5String;
    
    
    NSString *_ipString;
    
    

}


@property(nonatomic,copy) NSString *iconString;
@property(nonatomic,copy) NSString *niandaiString;
@property(nonatomic,copy) NSString *titleString;
@property(nonatomic,copy) NSString *xmlFile;
@property(nonatomic,copy) NSString *idString;
@property(nonatomic,copy) NSString *contentString;
@property(nonatomic,copy) NSString *nbidString;
@property(nonatomic,copy) NSString *timenmString;
@property(nonatomic,copy) NSString *stimeString;
@property(nonatomic,copy) NSString *etimeString;
@property(nonatomic,copy) NSString *zipFile;
@property(nonatomic,copy) NSString *md5String;


@property(nonatomic,copy) NSString *ipString;

@property(nonatomic,assign) BOOL isselected;
@property(nonatomic,assign) BOOL isdownload;

@end
