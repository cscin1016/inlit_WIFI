//版权所有：版权所有(C) 2013，爱点多媒体科技有限公司
//项目名称：ADM_LIGHT
//文件名称：LunBoView.m
//作　　者：Paul Cai
//完成日期：13-11-12
//功能说明：轮播视图
//----------------------------------------
#import "LunBoView.h"
#import "NetImageView.h"

#define SECONDS 4.0             //轮播间隔时间
#define PageControlBGHeight 21  //PageControl背景高度

@implementation LunBoView

@synthesize delegate        = _delegate;
@synthesize images          = _images;
@synthesize scrollView      = _scrollView;
@synthesize pageControlBG   = _pageControlBG;
@synthesize pageControl     = _pageControl;
@synthesize focus_title_Lab = _focus_title_Lab;

- (void)dealloc
{
    [self stop];
    self.pageControlBG = nil;
    self.pageControl = nil;
    self.images = nil;
    self.scrollView = nil;
    self.focus_title_Lab = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubviews];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - 轮播焦点图初始化(scroll、pageControll) -
- (void)createSubviews
{
    //轮播视图的默认背景图
    UIImageView *selfBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    selfBG.backgroundColor = [UIColor clearColor];
    selfBG.image = [UIImage imagePathed:@"xiaoxi_ad_photo@2x.png"];
    selfBG.userInteractionEnabled = YES;
    [self addSubview:selfBG];
    [selfBG release];
    
    //创建可滑动的轮播视图
    if (!self.scrollView)
    {
        UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        aScrollView.backgroundColor = [UIColor clearColor];
        aScrollView.showsHorizontalScrollIndicator = NO;
        aScrollView.showsVerticalScrollIndicator = NO;
        aScrollView.pagingEnabled = YES;
        aScrollView.delegate = self;
        aScrollView.directionalLockEnabled = YES;
        aScrollView.bounces = YES;
        self.scrollView = aScrollView;
        [self addSubview:aScrollView];
        [aScrollView release];
        
        //添加单击手势接受事件
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
        [gesture addTarget:self action:@selector(imageTapped)];
        [self.scrollView addGestureRecognizer:gesture];
        [gesture release];
    }
    
    //创建pageControl的背景
    if (!self.pageControlBG)
    {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, self.frame.size.width, PageControlBGHeight)];
        bg.backgroundColor = [UIColor clearColor];
        bg.userInteractionEnabled = YES;
        self.pageControlBG = bg;
        [self addSubview:bg];
        [self insertSubview:bg aboveSubview:self.scrollView];
        [bg release];
    }
    
    //创建pageControl
    if (!self.pageControl)
    {
        CGFloat width = self.pageControlBG.frame.size.width/4;
        CustomUIPageControl *pageControl = [[CustomUIPageControl alloc] initWithFrame:CGRectMake(self.pageControlBG.frame.size.width-(int)width, 0, (int)width, self.pageControlBG.frame.size.height)];
        pageControl.numberOfPages = 0;
        pageControl.currentPage = 0;
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.delegate = self;
        [pageControl setImagePageStateNormal:[UIImage imageNamed:@"home_img_ratio@2x.png"]];
        [pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"home_img_ratio_selected@2x.png"]];
        self.pageControl = pageControl;
        [self.pageControlBG addSubview:pageControl];
        [pageControl release];
        
        _focus_title_Lab = [[UILabel alloc] initWithFrame:CGRectMake(28/2, 5, 210, self.pageControlBG.frame.size.height-14/2)];
        [_focus_title_Lab setFont:GETFONT(14.0)];
        [_focus_title_Lab setBackgroundColor:[UIColor clearColor]];
        [_focus_title_Lab setText:@""];
        [_focus_title_Lab setTextColor:[UIColor whiteColor]];
        [self.pageControlBG addSubview:_focus_title_Lab];
    }
}

#pragma mark - 轮播条隐藏 -
- (void)hiddenDots
{
    if (self.pageControlBG)
    {
        self.pageControlBG.hidden = YES;
    }
}

#pragma mark - 轮播图 -
- (void)setLunBoData:(NSMutableArray*)array
{
    NSArray *subView = [self.scrollView subviews];
    
    for (UIView *view in subView ) {
        [view removeFromSuperview];
    }
    
    //
    self.images = [NSMutableArray arrayWithArray:array];
    
    //
    if (self.images && [self.images count] && self.scrollView)
    {
        NSInteger count = [self.images count];
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        
        for (NSInteger i = 0; i < count; i++)
        {
            NSString *str = [self.images objectAtIndex:i];
            
            NetImageView *aView = [[NetImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height-64)];
            [aView.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            aView.image = GETIMG(@"xiaoxi_ad_photo@2x.png");
            aView.imageURL = str;
            [self.scrollView addSubview:aView];
            
            [aView release];
        }
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.contentSize = CGSizeMake(width*count, height);
        //add by liyuelin
        if ([self.images count]==1) {
            self.pageControl.hidden = YES;
        }
    }
    
    //
    _currentIndex = 0;
    
    //
    if (self.pageControl)
    {
        self.pageControl.numberOfPages = [self.images count];
        self.pageControl.currentPage = 0;
        [self.pageControl updateDots:0];
    }
    
    //
    //    [self performSelector:@selector(start) withObject:nil afterDelay:SECONDS];
}

- (void) handleTapView:(UITapGestureRecognizer*) tapGestureRecognizer
{
    UIImageView *imageview = (UIImageView*)tapGestureRecognizer.view;
    
    if ( self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(handletapImage:)] ) {
        [self.delegate handletapImage:imageview];
    }
}

- (void)setLunBoImage:(NSMutableArray*)array
{
    //
    NSArray *subView = [self.scrollView subviews];
    for (UIView *view in subView )
    {
        [view removeFromSuperview];
    }
    
    //
    self.images = [NSMutableArray arrayWithArray:array];
    
    //
    if (self.images && [self.images count] && self.scrollView)
    {
        NSInteger count = [self.images count];
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        
        for (NSInteger i = 0; i < count; i++)
        {
            id object = [self.images objectAtIndex:i];
            if (object && [object isKindOfClass:[NSString class]])
            {
                NSString *str = (NSString*)object;
                NetImageView *aView = [[NetImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height-64)];
                [aView.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                aView.image = GETIMG(@"xiaoxi_ad_photo@2x.png");
                aView.imageURL = str;
                //                aView.contentMode = UIViewContentModeScaleAspectFill;
                [self.scrollView addSubview:aView];
                
                aView.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
                [gesture addTarget:self action:@selector(handleTapView:)];
                [aView addGestureRecognizer:gesture];
                [gesture release];
                
                [aView release];
            }
            
            if (object && [object isKindOfClass:[UIImage class]])
            {
                UIImage *image = (UIImage*)object;
                NetImageView *aView = [[NetImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height-64)];
                [aView.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                aView.image = image;
                [self.scrollView addSubview:aView];
                
                //                aView.contentMode = UIViewContentModeScaleAspectFill;
                aView.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
                [gesture addTarget:self action:@selector(handleTapView:)];
                [aView addGestureRecognizer:gesture];
                [gesture release];
                
                [aView release];
                
                            }
            
        }
        
       
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.contentSize = CGSizeMake(width*count, height);
        
        //add by liyuelin
        if ([self.images count]==1)
        {
            self.pageControl.hidden = YES;
        }
    }
    
    //
    _currentIndex = 0;
    
    //
    if (self.pageControl)
    {
        self.pageControl.numberOfPages = [self.images count];
        self.pageControl.currentPage = 0;
        [self.pageControl updateDots:0];
    }
    
    
    //    [self performSelector:@selector(start) withObject:nil afterDelay:SECONDS];
}



-(void)dismissViewVC
{
    NSLog(@"点击消失点击三小");
}

#pragma mark - 轮播动画启动 -
- (void)start
{
    //
    [self stop];
    
    //
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:SECONDS
                                                  target:self
                                                selector:@selector(lunboShow)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

#pragma mark - 轮播动画停止 -
- (void)stop
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)lunboShow
{
    //
    _currentIndex++;
    
    //
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    
    if (self.images && _currentIndex >= [self.images count])
    {
        _currentIndex = 0;
        [self.scrollView scrollRectToVisible:CGRectMake(_currentIndex*width, 0, width, height) animated:NO];
        [self.pageControl updateDots:_currentIndex];
    }
    else
    {
        [self.scrollView scrollRectToVisible:CGRectMake(_currentIndex*width, 0, width, height) animated:YES];
    }
}

#pragma mark - 轮播焦点图点击事件 -
- (void)imageTapped
{
    if (_currentIndex < [self.images count])
    {
        //选中图片，返回当前选中图片地址
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageSelected:)])
        {
            [self.delegate imageSelected:[self.images objectAtIndex:_currentIndex]];
        }
    }
    //点击轮播图返回当前图下标
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLunBoImgDelegateAction:)])
    {
        [self.delegate clickLunBoImgDelegateAction:_currentIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
    CGFloat pageWidth = scrollView.frame.size.width;
    int index = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    _currentIndex = index;
    [self.pageControl updateDots:index];
    if ([self.delegate respondsToSelector:@selector(updateTitleContentDelegateAction:)]) {
        [self.delegate updateTitleContentDelegateAction:index];
    }
    
#if 0
    //
    CGFloat width = ([self.images count]-1)*scrollView.frame.size.width;
    if (scrollView.contentOffset.x >= width+100)
    {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
        _currentIndex = 0;
    }
    
    if (scrollView.contentOffset.x <= -60)
    {
        [scrollView scrollRectToVisible:CGRectMake(width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
        _currentIndex = [self.images count]-1;
    }
#endif
}

#pragma mark - CustomUIPageControlDelegate
- (void)pageControlMoveToIndex:(NSInteger)index
{
    // ...
}

@end
