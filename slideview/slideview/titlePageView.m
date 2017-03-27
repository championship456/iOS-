//
//  titlePageView.m
//  slideview
//
//  Created by amc on 2017/3/22.
//  Copyright © 2017年 amc. All rights reserved.
//

#import "titlePageView.h"



#define KscrollviewlineH   2
#define KscrollviewbottonlineH 0.5

#define   sourcered   85
#define   sourcegreen   85
#define   sourceblue   85

#define   targetred   255
#define   targetgreen   128
#define   targetblue   0

@interface titlePageView  ()

@property (nonatomic,strong)NSMutableArray *titles;
@property (nonatomic,weak)UIScrollView     *scrollview;
@property (nonatomic,strong)NSMutableArray *titleLabels;

@property (nonatomic,weak)UILabel          *scrollerlbal;
@property (nonatomic,weak)UILabel          *bottonline;
@property (nonatomic,assign)NSInteger       selectIndex;

@end


@implementation titlePageView


- (instancetype)initWithFrame:(CGRect)frame titles:(NSMutableArray *)titles
{
    if (self) {
            self.titles = titles;
            self =    [super initWithFrame:frame];
        //1 创建scrollerview  防止进入懒加载死循环中
          [self addSubview:self.scrollview];
          _scrollview.frame =self.bounds;
        //2 添加label
        [self addTitleLabelson];
        //3 添加底部横条 和底部细线
        [self addbottonline];
        _selectIndex = 0;
    }
    return self;
}

#pragma mark - 创建scrollerview
- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        UIScrollView *scrollview = [[UIScrollView alloc]init];
        _scrollview = scrollview;
        _scrollview.scrollsToTop = NO;
        _scrollview.pagingEnabled = NO;
    }
    return _scrollview;
}


- (void)addTitleLabelson
{
    self.titleLabels = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *titlelabel = [UILabel new];
        titlelabel.text = self.titles[i];
        titlelabel.font = [UIFont systemFontOfSize:12];
        titlelabel.textColor = [UIColor darkGrayColor];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        CGFloat titlelabelW = self.frame.size.width/self.titles.count;
        CGFloat titlelabelX = titlelabelW *i;
        CGFloat titlelabelY =0;
        CGFloat titlelabelH = self.frame.size.height - KscrollviewlineH - KscrollviewbottonlineH;
        titlelabel.frame = CGRectMake(titlelabelX, titlelabelY, titlelabelW, titlelabelH);
        titlelabel.tag = i;
        titlelabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *labtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changetitles:)];
        [titlelabel addGestureRecognizer:labtap];
        [self addSubview:titlelabel];
        [_titleLabels addObject:titlelabel];
        if (i == 0) {
            titlelabel.textColor = [UIColor colorWithRed:targetred/255.0 green:targetgreen/ 255.0 blue:targetblue/255.0 alpha:1];
        }
    }
}

- (void)addbottonline
{
    UILabel *scrolllab = [UILabel new];
    scrolllab.backgroundColor = [UIColor orangeColor];
    CGFloat scrollabY = self.frame.size.height - KscrollviewbottonlineH - KscrollviewlineH;
    self.scrollerlbal = scrolllab;
    scrolllab.frame = CGRectMake(0, scrollabY, self.frame.size.width/self.titles.count, KscrollviewlineH);     [self addSubview:scrolllab];
    UILabel *bottonlab = [UILabel new];
    bottonlab.backgroundColor = [UIColor lightGrayColor];
    bottonlab.frame = CGRectMake(0, self.frame.size.height - KscrollviewbottonlineH, self.frame.size.width, KscrollviewbottonlineH);
    [self addSubview:bottonlab];
    self.bottonline = bottonlab;
}

#pragma mark - ulabel点击手势
- (void)changetitles:(UITapGestureRecognizer *)tap{
    UILabel *selectLa = (UILabel *)tap.view;
    //先前的label改变颜色
    UILabel *startlab = self.titleLabels[_selectIndex];
    startlab.textColor = [UIColor darkGrayColor];
    _selectIndex  = selectLa.tag;
    //改变后面label的颜色
    UILabel *endlab = self.titleLabels[_selectIndex];
    endlab.textColor = [UIColor colorWithRed:targetred/255.0 green:targetgreen/255.0 blue:targetblue/255.0 alpha:1];
    [UIView animateWithDuration:0.15 animations:^{
        self.scrollerlbal.frame = CGRectMake(self.frame.size.width/self.titles.count * selectLa.tag, self.frame.size.height - KscrollviewbottonlineH - KscrollviewlineH, self.frame.size.width/self.titles.count, KscrollviewlineH);
    }];
    if ([self.deleagte respondsToSelector:@selector(changeControllerToIndex:)]) {
        [self.deleagte changeControllerToIndex:_selectIndex];
    }
}

- (void)progress:(CGFloat)progress sourIndex:(NSInteger)sourIntex tagetIndex:(NSInteger)targetIndex
{
    
    UILabel  *sourcelab = self.titleLabels[sourIntex];
    UILabel  *targetlab = self.titleLabels[targetIndex];
    NSInteger moveTotalX = targetlab.frame.origin.x - sourcelab.frame.origin.x;
    CGFloat  moveX = progress *moveTotalX;
    self.scrollerlbal.frame = CGRectMake(sourcelab.frame.origin.x + moveX, self.frame.size.height - KscrollviewbottonlineH - KscrollviewlineH, self.frame.size.width/self.titles.count, KscrollviewlineH);
    CGPointMake(sourcelab.frame.origin.x + moveX, 0);
    CGFloat redrate  =   (targetred- sourcered);
    CGFloat greenrate = (targetgreen - sourcegreen);
    CGFloat bluerate  = (targetblue - sourceblue);
    sourcelab.textColor = [UIColor colorWithRed:(targetred - redrate*progress)/255.0 green:(targetgreen - greenrate *progress)/255.0 blue:(targetblue - bluerate *progress)/255.0 alpha:1];
    targetlab.textColor = [UIColor colorWithRed:(sourcered + redrate*progress)/255.0 green:(sourcegreen + greenrate*progress)/255.0 blue:(sourceblue + bluerate*progress)/255.0 alpha:1];
    _selectIndex = targetIndex;
}


@end
