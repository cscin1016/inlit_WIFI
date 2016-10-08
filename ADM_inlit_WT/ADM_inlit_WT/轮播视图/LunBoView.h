//版权所有：版权所有(C) 2013，爱点多媒体科技有限公司
//项目名称：ADM_LIGHT
//文件名称：LunBoView.m
//作　　者：Paul Cai
//完成日期：13-11-12
//功能说明：轮播视图
//----------------------------------------

#import <UIKit/UIKit.h>
#import "CustomUIPageControl.h"

@protocol LunBoViewDelegate <NSObject>

@optional
- (void)imageSelected:(NSString*)str;
- (void)updateTitleContentDelegateAction:(int)current_page_index;
- (void)clickLunBoImgDelegateAction:(NSInteger)img_index;
- (void) handletapImage:(UIImageView *) imageview;
@end

@interface LunBoView : UIView <UIScrollViewDelegate, CustomUIPageControlDelegate>
{
    id <LunBoViewDelegate>          _delegate;
    
    NSMutableArray                  *_images;
    UIScrollView                    *_scrollView;
    
    NSTimer                         *_timer;
    NSInteger                       _currentIndex;
    
    UIImageView                     *_pageControlBG;
    CustomUIPageControl             *_pageControl;
    UILabel                         *_focus_title_Lab;
}

@property (assign) id <LunBoViewDelegate>                       delegate;
@property (nonatomic, retain) NSMutableArray                    *images;
@property (nonatomic, retain) UIScrollView                      *scrollView;
@property (nonatomic, retain) UIImageView                       *pageControlBG;
@property (nonatomic, retain) CustomUIPageControl               *pageControl;
@property (nonatomic, retain) UILabel                           *focus_title_Lab;

- (void)setLunBoData:(NSMutableArray*)array;
- (void)setLunBoImage:(NSMutableArray*)array;
- (void)hiddenDots;
- (void)start;
- (void)stop;

@end
