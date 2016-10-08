//
//  SubCollectionsInfo.m
//  TestZJMuseum
//
//  Created by 胡 jojo on 13-8-27.
//  Copyright (c) 2013年 tracy. All rights reserved.
//

#import "SubCollectionsInfo.h"

@implementation SubCollectionsInfo

@synthesize iconString=_iconString;
@synthesize titleString=_titleString;
@synthesize niandaiString=_niandaiString;
@synthesize xmlFile=_xmlFile;
@synthesize idString=_idString;
@synthesize contentString=_contentString;
@synthesize nbidString=_nbidString;
@synthesize timenmString=_timenmString;
@synthesize stimeString=_stimeString;
@synthesize etimeString=_etimeString;
@synthesize zipFile=_zipFile;
@synthesize md5String=_md5String;

@synthesize ipString=_ipString;
@synthesize isselected;
@synthesize isdownload;


- (id)init
{
    if (self=[super init])
    {
        _iconString = nil;
        _titleString = nil;
        _niandaiString = nil;
        _xmlFile=nil;
        _idString=nil;
        _contentString=nil;
        _nbidString=nil;
        _timenmString=nil;
        _stimeString=nil;
        _etimeString=nil;
        _zipFile=nil;
        _md5String=nil;
        _ipString =nil;
        
        isselected=NO;
        isdownload=NO;
        
    }
    return self;
}



@end
