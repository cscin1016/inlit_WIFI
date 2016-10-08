//版权所有：版权所有(C) 2013，爱点多媒体科技有限公司
//项目名称：ADM_LIGHT
//文件名称：ConstsConfig.h
//作　　者：Paul Cai
//完成日期：13-11-12
//功能说明：基本宏定义文件
//----------------------------------------

#ifndef Donson_ConstsConfig_h
#define Donson_ConstsConfig_h

// 安全释放对象
#define SAFETY_RELEASE(x)   {[(x) release]; (x)=nil;}

//上部导航栏高度
#define TOPHEIGHT 44

//下部bar高度
#define BOTTOMHEIGHT 49

// 文字字体
#define DSFONT    @"MicrosoftYaHei"

//#define GETFONT(x) [UIFont fontWithName:DSFONT size:(x)]
#define GETFONT(x) [UIFont systemFontOfSize:(x)]
#define Font_HelveticaInSize(a) GETFONT(a)
#define SYSTEMFONT(x) GETFONT(x)
//#define SYSTEMBOLDFONT(x) [UIFont boldSystemFontOfSize:(x)]

//获取屏幕
#define MainScreen [[UIScreen mainScreen] bounds]
//屏幕宽度
#define SCREENWIDTH MainScreen.size.width
#define SELFVCFRAMEWITH self.view.frame.size.width
#define SELFVIEWFRAMEWIDTH self.frame.size.width
//屏幕高度
#define SCREENHEIGHT MainScreen.size.height
#define SELFVCFRAMEHEIGHT self.view.frame.size.height
#define SELFVIEWFRAMEHEIGHT self.frame.size.height

//获取本地图片的路径
#define GETIMG(name)  [UIImage imageWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]]

//RGB 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

// 是否为高清屏
#define isRetina ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))

#define isiPhone4 ( [UIScreen mainScreen].bounds.size.height == 480 )

// 判断是否为iphone5
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//版本号
#define DeviceVision [[[UIDevice currentDevice] systemVersion] floatValue]

//检测网络
#define defHasNetWork [[WatchDog luckDog] haveNetWork]
#define defAlertNetWork { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络异常,请检查网络！" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil]; [alert show]; [alert release]; }

//以上是公用模块使用的宏
///////////////////////-------------------
//以下是单独模块使用的宏

#define FAILTIPS switch (type) {\
case TimeOut:\
[self.view addHUDLabelView:@"请求超时" Image:nil afterDelay:2];\
break;\
case RequestException:\
[self.view addHUDLabelView:@"请求异常" Image:nil afterDelay:2];\
break;\
case RequestEmpty:\
[self.view addHUDLabelView:@"无数据" Image:nil afterDelay:2];\
break;\
case NotAuthorized:\
[self.view addHUDLabelView:@"没有登入" Image:nil afterDelay:2];\
break;\
case NotFound:\
[self.view addHUDLabelView:@"请求资源不存在" Image:nil afterDelay:2];\
break;\
case ServiceUnavailable:\
[self.view addHUDLabelView:@"服务的资源不可用" Image:nil afterDelay:2];\
break;\
default:\
break;\
}


typedef enum{
    kWBRequestPostDataTypeNone,
	kWBRequestPostDataTypeNormal,		// for normal data post, such as "user=name&password=psd"
	kWBRequestPostDataTypeMultipart,    // for uploading images and files.
}WBRequestPostDataType;

// 消息通知 禁止或打开scrollview的滚动
#define k_NotificationScrollViewEnabled @"k_NotificationScrollViewEnabled"

//userID
#define USERID      @"userID"

//userName
#define USERNAME      @"userName"

//usrToken
#define USERTOKEN   @"userToken"

//用户显示名称
#define USERSHOWNAME    @"userShowName"

#define YellowColor RGBCOLOR(220, 205, 164)

#define textColorYellow RGBCOLOR(53, 35, 39)



#endif
