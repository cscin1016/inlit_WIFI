//
//  GuidePageViewController.m
//  Buickhousekeeper
//
//  Created by 李黎明 on 13-7-26.
//  Copyright (c) 2013年 calinks. All rights reserved.
//

#import "GuidePageViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define guide_image_1 isIPhone5?@"1.jpg":@"1@2x.jpg"
#define guide_image_2 isIPhone5?@"2.jpg":@"2@2x.jpg"
#define guide_image_5 isIPhone5?@"3.jpg":@"3@2x.jpg"
#define guide_image_4 isIPhone5?@"4.jpg":@"4@2x.jpg"



#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)



@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

//禁止横屏
- (BOOL)shouldAutorotate{
    return NO;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
        case UIDeviceOrientationUnknown:
            break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[GuidePageViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[GuidePageViewController sharedGuide].view];
        NSLog(@"showGuide引导");
		
		_animating = NO;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[GuidePageViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[GuidePageViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[GuidePageViewController sharedGuide] view] removeFromSuperview];
    
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        NSLog(@"------%@",[app.delegate window]);
        return [app.delegate window];
    }
    else
    {
        NSLog(@"------%@",[app keyWindow]);
        return [app keyWindow];
    }
}

+ (void)show
{
    [[GuidePageViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[GuidePageViewController sharedGuide] showGuide];
    NSLog(@"引导界面显示");
}

+ (void)hide
{
	[[GuidePageViewController sharedGuide] hideGuide];
    //    [DisclaimerViewController show];
    NSLog(@"引导界面隐藏");
}

#pragma mark -

+ (GuidePageViewController *)sharedGuide
{
    @synchronized(self)
    {
        static GuidePageViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
            NSLog(@"初始化单列GuidePageViewController");
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    exit(0);
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"引导界面");
    
    
    self.view.backgroundColor = [UIColor blueColor];
    NSArray *imageNameArray = [NSArray arrayWithObjects:guide_image_1, guide_image_2,guide_image_5,guide_image_4, nil];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
    self.pageScroll.bounces = NO;
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20)];
        backImage.image = [UIImage imageNamed:imgName];
        [view addSubview:backImage];
        
        [self.pageScroll addSubview:view];
        if (i==3) {
            //透明的按钮 覆盖“马上体验Inlit”处
            UIButton * joinBt =[UIButton buttonWithType:UIButtonTypeCustom];
            joinBt.frame =CGRectMake(SCREENWIDTH/2-160+30, 380+SCREENHEIGHT-568, 260+SCREENWIDTH-320, 80);
            joinBt.backgroundColor =[UIColor clearColor];
            [joinBt setTitle:nil forState:UIControlStateNormal];
            [joinBt addTarget:self action:@selector(hideGuide) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:joinBt];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    pageControlView.currentPage=offset.x/320.0f;
    
    if (offset.x>1280) {
        [self hideGuide];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    pageControlView.currentPage=offset.x/320.0f;
}

-(void)pageTurn:(UIPageControl *)aPageControl
{
    NSInteger whichPage=aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    _pageScroll.contentOffset=CGPointMake(320*whichPage, 0);
    [UIView commitAnimations];
    if (whichPage==0) {
        [self.view setNeedsLayout];
    }
}


@end
