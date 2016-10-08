//
//  CSCViewController.h
//  imageOperating
//
//  Created by apple on 14-6-11.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic)  UIImageView *selectedImage;

-(void)showImagePicker;

@end
