//
//  FFScrollView.m
//  ScrollViewDemo
//
//  Created by Juncy_Fan on 13-11-11.
//  Copyright (c) 2013年. All rights reserved.
//

#import "FFScrollView.h"
//#import "UIImageView+WebCache.h"

@implementation FFScrollView
@synthesize scrollView;
@synthesize pageControl;
@synthesize selectionType;
@synthesize pageViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark-- init methods
- (id)initPageViewWithFrame:(CGRect)frame views:(NSMutableArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
//        _isLook=YES;
        selectionType = FFScrollViewSelecttionTypeTap;
        sourceArr = views;
        self.userInteractionEnabled = YES;
        [self iniSubviewsWithFrame:frame];
    }
    return self;
}
-(void)initWithImgs:(NSArray *)views
{
    selectionType = FFScrollViewSelecttionTypeTap;
//    if ([views isKindOfClass:[NSArray class]]) {
        sourceArr =[[NSArray alloc]initWithArray:views?views:@[]];
//    }
    
    self.userInteractionEnabled = YES;
    [self iniSubviewsWithFrame:self.frame];
}
-(void)iniSubviewsWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGRect fitRect = CGRectMake(0, 0, width, height);
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview],self.scrollView=nil;
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:fitRect];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(width*(sourceArr.count+2), height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    if (firstImageView) {
        [firstImageView removeFromSuperview],firstImageView=nil;
        [timer invalidate];
    }
    firstImageView = [[UIImageView alloc]initWithFrame:fitRect];

     firstImageView.image = [UIImage imageNamed:[sourceArr lastObject]]; // -----需要修改-----
    firstImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:firstImageView];
    
    for (int i = 0; i < sourceArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(i+1), 0, width, height)];
        imageview.image = [UIImage imageNamed:[sourceArr objectAtIndex:i]];

        imageview.contentMode=UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageview];
    }
    if (lastImageView) {
        [lastImageView removeFromSuperview],lastImageView=nil;
    }
    
    lastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*(sourceArr.count+1), 0, width, height)];
    if (sourceArr.count==0) {

        lastImageView.image = [UIImage imageNamed:@"s1"];  // 默认图片
    }
    else
    {

        lastImageView.image = [UIImage imageNamed:[sourceArr objectAtIndex:0]];
    }
    lastImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:lastImageView];
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview],self.pageControl=nil;
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
    self.pageControl.numberOfPages = sourceArr.count;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
    
//    self.pageControl=[[CustomPagePoint alloc]initWithFrame:CGRectMake(100, height-20, ScreenWidth, 5) ];
//    self.pageControl.pageCount=sourceArr.count;
//    [self.pageControl curentPage:0];
//    [self addSubview:self.pageControl];
    
    [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (sourceArr.count>1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        self.scrollView.scrollEnabled=YES;
    }
    else
    {
        self.scrollView.scrollEnabled=NO;
    }
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}

#pragma mark --- custom methods
//自动滚动到下一页
-(IBAction)nextPage:(id)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = self.scrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.pageControl.currentPage = sourceArr.count-1;
        //[self.pageControl curentPage:sourceArr.count-1];
    }
    else if (currentPage == sourceArr.count+1) {
        self.pageControl.currentPage = 0;
//        [self.pageControl curentPage:0];
    }
    else {
        self.pageControl.currentPage = currentPage-1;
//        [self.pageControl curentPage:currentPage-1];
    }
    NSInteger currPageNumber = self.pageControl.currentPage;
    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    currPageNumber++;
    if (currPageNumber == sourceArr.count)
    {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.scrollView scrollRectToVisible:newRect animated:NO];
        currPageNumber = 0;
    }
    self.pageControl.currentPage = currPageNumber;
    if ([pageViewDelegate respondsToSelector:@selector(scrollPage:)])
    {
        //[pageViewDelegate scrollPage:self.pageControl.currentPage];
    }
}

//点击图片的时候 触发
- (void)singleTap:(UITapGestureRecognizer *)tapGesture
{
    if (selectionType != FFScrollViewSelecttionTypeTap) {
        return;
    }
    
//     NSLog(@"点击了图片：%i",self.pageControl.courent);
    
    if(sourceArr.count==1&&[[[sourceArr objectAtIndex:0] objectForKey:@"medium"] isEqualToString:@""])
    {
        if ([pageViewDelegate respondsToSelector:@selector(isNormalPic)]) {
            [pageViewDelegate isNormalPic];
        }
    }
    else
    {
        if (pageViewDelegate && [pageViewDelegate respondsToSelector:@selector(scrollViewDidClickedAtPage:)]) {
            [pageViewDelegate scrollViewDidClickedAtPage:self.pageControl.currentPage];

//            NSLog(@"点击了图片：%i",self.pageControl.courent);
        }
    }
    
}

#pragma mark---- UIScrollView delegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    [timer invalidate];
    timer = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat heigth = self.scrollView.frame.size.height;
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    int currentPage = self.scrollView.contentOffset.x/width;
    if (currentPage == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(width*sourceArr.count, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = sourceArr.count-1;
//        [self.pageControl curentPage:sourceArr.count-1];
    }
    else if (currentPage == sourceArr.count+1) {
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, heigth) animated:NO];
        self.pageControl.currentPage = 0;
//        [self.pageControl curentPage:0];
    }
    else {
        self.pageControl.currentPage = currentPage-1;
//        [self.pageControl curentPage:currentPage-1];
    }
    //拖动完毕的时候 重新开始计时器控制跳转
//    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
    if (sourceArr.count>1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        self.scrollView.scrollEnabled=YES;
    }
    else
    {
        self.scrollView.scrollEnabled=NO;
    }
    
    if ([pageViewDelegate respondsToSelector:@selector(scrollPage:)]) {
        [pageViewDelegate scrollPage:self.pageControl.currentPage];
    }
}

@end
