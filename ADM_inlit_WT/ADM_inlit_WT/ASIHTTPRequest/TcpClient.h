//
//  TcpClient.h
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface TcpClient : NSObject
{
    long TAG_SEND;
    
    NSMutableArray *recivedArray;
    
    AsyncSocket  *_sendSocket[100];
    int m;//当前已有多少个TCP连接
    int k;//有多少灯是断开连接的
    NSMutableDictionary *socketDiction;//用于查找ip地址对应的连接
    BOOL isShowED;
   
}


@property (nonatomic,retain) NSMutableArray *currentArray;//保存当前要发数据的所有对象


+ (TcpClient *)sharedInstance;

-(void)writeData:(NSData*)data;
-(void)writeData:(NSData*)data picNumber:(int)n;

-(void)connectTCP:(NSArray*)IPAdresses;
-(void)reconnectTCP:(NSArray *)TCPIPAdresses;


@end
