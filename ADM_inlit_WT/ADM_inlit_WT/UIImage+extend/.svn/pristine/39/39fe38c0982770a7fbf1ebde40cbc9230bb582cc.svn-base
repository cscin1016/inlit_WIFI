//
//  UIImageRetinal.h
//  Donson template
//
//  Created by 陈双龙 on 12-8-2.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(extend)

/**
 @功能:直接从NSBundle中读取图片，不会缓存
 @参数:NSString   图片名称，必须代后缀名
 @返回值:图片对象
 */
+(UIImage*)imagePathed:(NSString*)imageName;

/**
 @功能:使用特定的颜色替换当前图片（透明部分不会被替换）
 @参数1:UIImage   目标图片
 @参数2:UIColor   要替换的颜色
 @返回值:更改后的图片对象
 */
+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;


/**
 @功能:蒙版功能
 @参数1:UIImage   目标图片
 @参数2:UIImage   蒙版图片
 @返回值:更改后的图片对象
 */
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;

/**
 @功能:缩放图片到指定大小
 @参数1:CGSize   缩放后的大小
 @返回值:更改后的图片对象
 */
-(UIImage*)imageByScalingForSize:(CGSize)targetSize;


/**
 @功能:缩放图片到指定大小，并压缩图片
 @参数1:CGSize    缩放后的大小
 @参数2:float     压缩值，百分比(0.0f-1.0f)，随着百分比的增加，压缩出来的图片大小也随之增加
 @返回值:更改后的图片对象
 */
-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize percent:(float)percent;

/**
 @功能:圆形图片
 @参数1:UIImage   目标图片
 @参数2:inset     圆形坐标
 @返回值:更改后的图片对象
 */
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;

/**
 @功能:UIColor转换成UIImage
 @参数1:UIColor   颜色
 @返回值:图片对象
 */

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;


@end