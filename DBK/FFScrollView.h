//
//  FFScrollView.h
//  ScrollViewDemo
//
//  Created by Juncy_Fan on 13-11-11.
//  Copyright (c) 2013年 aifeng. All rights reserved.
//

/*
 *滚动视图--图片
 */
#import <UIKit/UIKit.h>
//#import "CustomPagePoint.h"
typedef enum
{
    FFScrollViewSelecttionTypeTap = 100,  //默认的为可点击模式
    FFScrollViewSelecttionTypeNone   //不可点击的
}FFScrollViewSelecttionType;

@protocol FFScrollViewDelegate <NSObject>

@optional
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber;
-(void)thePictureClick:(NSArray*) imgArr atIndex:(int)tag;
-(void)isNormalPic;
-(void)scrollPage:(int )page;
@end

@interface FFScrollView : UIView <UIScrollViewDelegate>
{
    NSTimer *timer;
    NSArray *sourceArr;
    NSMutableArray *mArr;
    UIImageView *firstImageView ;
    UIImageView *lastImageView;

}
@property (assign, nonatomic) BOOL isLook;//yes 为图片浏览  no 为进入广告详情
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl *pageControl;
//@property (strong, nonatomic) CustomPagePoint *pageControl;
@property(assign,nonatomic) FFScrollViewSelecttionType selectionType;
@property(assign,nonatomic) id <FFScrollViewDelegate> pageViewDelegate;
@property (retain,nonatomic) NSString *placeImg;
- (id)initPageViewWithFrame:(CGRect)frame views:(NSArray *)views;
-(void)initWithImgs:(NSArray *)views;
@end
