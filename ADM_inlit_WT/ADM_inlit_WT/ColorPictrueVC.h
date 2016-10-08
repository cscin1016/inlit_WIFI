//
//  ColorPictrueVC.h
//  ADM_inlit_WT
//
//  Created by admin on 14-7-8.
//  Copyright (c) 2014年 com.aidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPictrueVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (retain, nonatomic)  UIImageView *pictureiView;
@property (retain, nonatomic)  UIImageView *imageTip;
@end
