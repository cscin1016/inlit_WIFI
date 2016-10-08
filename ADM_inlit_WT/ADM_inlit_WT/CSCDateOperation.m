//
//  CSCDateOperation.m
//  ADM_inlit_beta
//
//  Created by 陈双超 on 14-10-28.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import "CSCDateOperation.h"

@implementation CSCDateOperation
+(NSMutableDictionary*)getIPAndMACFromData:(NSData*)dataStr{
   
    NSMutableDictionary *ipAndMacDic;//返回数据
    NSString *ipAdresses=@"";
    NSString *macAdresses=@"";
    NSString *apNameStr=@"未命名";
    
    NSString* Udpinfo=[[NSString alloc] initWithData:dataStr encoding: NSASCIIStringEncoding];
    
    if ([Udpinfo hasPrefix:@"ADM"]) {
        NSString *str = @"))(";
        NSString *apStr =@")(,,)";
        NSString *nameString =@"未命名";
        //在dataStr这个字符串中搜索@"))(" ,有则判断是有ip返回
        if ([Udpinfo rangeOfString:str].location != NSNotFound)
        {
            //在dataStr这个字符串中搜索)(,,)，判断有没有,有则判断是AP模式下的ip
            if ([Udpinfo rangeOfString:apStr].location != NSNotFound)
            {
                NSRange range = [Udpinfo rangeOfString:str];
                NSString * macString = [Udpinfo substringFromIndex:range.location];
                NSString *lastMacStr= [macString substringWithRange:NSMakeRange(3,17)];
                NSString *fristIP =[[NSString alloc] init];
                fristIP =@"192.168.16.254";
                //保存ip,mac和name到字典里
                ipAndMacDic =[[NSMutableDictionary  alloc] initWithObjectsAndKeys:fristIP,@"DeviceIP",lastMacStr,@"DeviceMac",nameString,@"DeviceName", nil] ;
            }else{  //没有，则表示在路由wifi下的数据
                NSRange range = [Udpinfo rangeOfString:str];
                NSString * macString = [Udpinfo substringFromIndex:range.location];
                NSString *lastMacStr= [macString substringWithRange:NSMakeRange(3,17)];
                NSString *lastIpStr =[macString substringFromIndex:40];
                NSString *fristIP =[[NSString alloc] init];
                NSArray *theIPArray =[lastIpStr componentsSeparatedByString:@","];
                fristIP=[theIPArray objectAtIndex:0];
                //保存ip,mac和name到字典里
                ipAndMacDic =[[NSMutableDictionary  alloc] initWithObjectsAndKeys:fristIP,@"DeviceIP",lastMacStr,@"DeviceMac",nameString,@"DeviceName",  nil];
            }
        }
    }else if([Udpinfo hasPrefix:@"{(+WHO)(ADM_2)"]){
        NSArray *segmentArray=[[NSArray alloc]initWithArray:[Udpinfo componentsSeparatedByString:@")("]];
        if (segmentArray.count==5) {
            macAdresses=[segmentArray objectAtIndex:3];
            NSArray *temArray=[[segmentArray objectAtIndex:4]componentsSeparatedByString:@","];
            if ([temArray count]==3) {
                ipAdresses=[temArray objectAtIndex:0];
            }
        }
        ipAndMacDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:macAdresses,@"DeviceMac",ipAdresses,@"DeviceIP", apNameStr,@"DeviceName",nil];
    }else{
        return nil;
    }
    return ipAndMacDic;
}
@end
