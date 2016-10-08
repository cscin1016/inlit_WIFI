//
//  TcpClient.m
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import "TcpClient.h"

@implementation TcpClient

@synthesize currentArray;

/**第1步: 存储唯一实例，一个静态变量_sharedInstance */
static TcpClient *_sharedInstance;

/**第2步: 分配内存时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}
/**第3步: 保证init初始化时都相同*/
+(TcpClient *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TcpClient alloc] init];
    });
    return _sharedInstance;
}

//首先是判断ip地址是否已经存在，不存在就新建，
//将ip地址对应的socket连接保存到current数组里面去，供下次发送数据使用
-(void)connectTCP:(NSArray*)IPAdresses{
    NSLog(@"连接的IPAdresses =%@",IPAdresses);
    isShowED=NO;
    if([IPAdresses count]==0){
        return;
    }
    [currentArray removeAllObjects];
    m=0;
    for(int i=0;i<[IPAdresses count];i++){
        _sendSocket[m]=[[AsyncSocket alloc] initWithDelegate: self];
        [_sendSocket[m] setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        NSLog(@"连接%@",[IPAdresses objectAtIndex:i]);
        [_sendSocket[m] connectToHost:[IPAdresses objectAtIndex:i]  onPort:8080 error:nil];
        [currentArray addObject:_sendSocket[m]];
        [socketDiction setObject:_sendSocket[m] forKey:[IPAdresses objectAtIndex:i]];
        m++;
    }
}

-(void)reconnectTCP:(NSArray *)TCPIPAdresses
{
    if([TCPIPAdresses count]==0){
        return;
    }
    for(int i=0;i< [[socketDiction allKeys] count];i++){
        _sendSocket[i]=[[AsyncSocket alloc] initWithDelegate: self];
        [_sendSocket[i] setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        [_sendSocket[i] connectToHost:[[socketDiction allKeys] objectAtIndex:i]  onPort:8080 error:nil];
        [socketDiction setObject:_sendSocket[i] forKey:[[socketDiction allKeys] objectAtIndex:i]];
    }
    [self connectTCP:TCPIPAdresses];
}

-(id)init;
{
    self = [super init];
    socketDiction=[[NSMutableDictionary alloc]initWithCapacity:30];
    currentArray =[[NSMutableArray alloc]initWithCapacity:30];
    isShowED=NO;
    return self;
}

-(void)writeData:(NSData*)data
{
    k=0;
    for(int i=0; i<m;i++ ){
        if (![[currentArray objectAtIndex:i] isConnected]) {
            k++;
            continue;
        }
//        NSLog(@"发送数据成功");
        [_sendSocket[i] writeData:data withTimeout:-1. tag:TAG_SEND];
    }
    if (k&&!isShowED) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"有%d个灯断开连接",k] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        isShowED=YES;
    }
}
-(void)writeData:(NSData*)data picNumber:(int)n
{
    if(n<currentArray.count){
        [_sendSocket[n] writeData:data withTimeout:-1. tag:TAG_SEND];
    }
}
//将要断开时
-(void) onSocket:(AsyncSocket *) sock willDisConnectWithError:(NSError *)err{
    NSLog(@"willDisConnectWithError");
    
}
// 接受数据
// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"收到数据:%@",data);
    [sock readDataWithTimeout:-1 tag:tag];
}
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSMutableArray* hostArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurConnectIP"]];
    [hostArray addObject:host];
    [[NSUserDefaults standardUserDefaults] setObject:hostArray forKey:@"CurConnectIP"];
    [sock readDataWithTimeout: -1 tag: 0];
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    sock=nil;
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"完成了数据的发送:%@,,,,,,,,,,,,,,%ld",sock,tag);
}
@end
