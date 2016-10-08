//
//  ASIDownCacheNew.m
//  BaseLibrary
//
//  Created by qianzhenlei on 12-3-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASIDownloadCacheNew.h"

@implementation ASIDownloadCacheNew

-(id)init 
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)cacheFilePath:(NSURL *)url
{ 
	NSString *extension = [[url path] pathExtension];
	if (![extension length] || 
        [[[self class] fileExtensionsToHandleAsHTML] containsObject:[extension lowercaseString]]) 
    {
		extension = @"html";
	}
    
	return [NSString stringWithFormat:@"%@/PermanentStore/%@",[self storagePath],[[[self class] keyForURL:url] stringByAppendingPathExtension:extension]];
}

@end
