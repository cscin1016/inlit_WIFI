//
//  UIImageRetinal.m
//  Donson template
//
//  Created by apple on 12-8-2.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "UIImageExtend.h"

@implementation UIImage(extend)


/**
 @功能:直接从NSBundle中读取图片，不会缓存
 @参数:NSString   图片名称，必须代后缀名
 @返回值:图片对象
 */
+(UIImage*) imagePathed:(NSString*)imageName
{
    NSString *strPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:strPath];
    
    if ( nil == img )
    {
        img = [UIImage imageNamed:imageName];
    }
    
    return img;
}

/**
 @功能:缩放图片到指定大小
 @参数1:CGSize   缩放后的大小
 @返回值:更改后的图片对象
 */
-(UIImage*)imageByScalingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if ( scaledImage == nil )
    {
        NSLog(@"UIImageRetinal:could not scale image!!!");
        return nil;
    }

    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 @功能:缩放图片到指定大小，并压缩图片
 @参数1:CGSize    缩放后的大小
 @参数2:float     压缩值，百分比(0.0f-1.0f)，随着百分比的增加，压缩出来的图片大小也随之增加
 @返回值:更改后的图片对象
 */
-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize percent:(float)percent
{
    UIImage *scaledImage = [self imageByScalingForSize:targetSize];
    
    if (scaledImage == nil)
    {
        NSLog(@"UIImageRetinal:could not scale and crop image!!!");
        return nil;
    }
    
    NSData *thumbImageData = UIImageJPEGRepresentation(scaledImage, percent);
    UIImage *newImage = [UIImage imageWithData:thumbImageData];
    return newImage;
}


/**
 @功能:使用特定的颜色替换当前图片（透明部分不会被替换）
 @参数1:UIImage   目标图片
 @参数2:UIColor   要替换的颜色
 @返回值:更改后的图片对象
 */
+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor {
    
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 @功能:蒙版功能
 @参数1:UIImage   目标图片
 @参数2:UIImage   蒙版图片
 @返回值:更改后的图片对象
 */
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage
{
	UIGraphicsBeginImageContext(baseImage.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
	CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
	
	CGImageRef maskRef = theMaskImage.CGImage;
	
	CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
	CGImageRelease(maskImage);
	
	CGContextDrawImage(ctx, area, masked);
	CGImageRelease(masked);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
	return newImage;
}

/**
 @功能:圆形图片
 @参数1:UIImage   目标图片
 @参数2:inset     圆形坐标
 @返回值:更改后的图片对象
 */
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 @功能:UIColor转换成UIImage
 @参数1:UIColor   颜色
 @返回值:图片对象
 */

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
