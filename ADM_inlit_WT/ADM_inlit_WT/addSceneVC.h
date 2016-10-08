//
//  addSceneVC.h
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

@protocol scenceArrayDelegte <NSObject>

-(void)getScenceData:(NSMutableArray *)scenceArray;
@end

#import <UIKit/UIKit.h>
#import "UIImageExtend.h" //图片压缩
#import "UIImage+extend/UIImageExtend.h"

@class RemoteVC;


@interface addSceneVC : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    RemoteVC *remote;
   __weak id<scenceArrayDelegte>delagate;
    
}
@property (strong, nonatomic)  UIImageView *selectedImage;
@property (nonatomic,weak) id<scenceArrayDelegte> delegate;
-(void)showImagePicker;


@end
