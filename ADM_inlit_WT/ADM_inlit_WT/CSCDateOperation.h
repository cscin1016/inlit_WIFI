//
//  CSCDateOperation.h
//  ADM_inlit_beta
//
//  Created by 陈双超 on 14-10-28.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCDateOperation : NSObject
//ap模式下解析各个版本的返回数据
+(NSMutableDictionary*)getIPAndMACFromData:(NSData*)dataStr;

@end
