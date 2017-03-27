//
//  pageContainView.m
//  slideview
//
//  Created by amc on 2017/3/22.
//  Copyright © 2017年 amc. All rights reserved.
//

#import "pageContainView.h"


@interface pageContainView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray  *controllers;
@property (nonatomic,weak)UICollectionView  *collectionview;
@property (nonatomic,weak)UIViewController  *parentvc;
@property (nonatomic,assign)CGFloat        startconstOfx;
@property (nonatomic,assign)CGFloat        endConstOfx;
@property (nonatomic,assign)NSInteger        startPage;
@property (nonatomic,assign)NSInteger        endPage;

@property (nonatomic,assign)CGFloat          pregress;
@property (nonatomic,assign)BOOL             isforbid;//禁止事件
@end


@implementation pageContainView

- (instancetype)initWithFrame:(CGRect)frame viewController:(NSMutableArray *)viewcontrollers parentviewcontroller:(UIViewController *)parentvc
{
    if (self) {
        self.parentvc = parentvc;
        self.controllers = viewcontrollers;
        self = [super initWithFrame:frame];
        NSLog(@"%d",self.controllers.count);
        //创建collectionview
//        [self addSubview:self.collectionview];
        _startPage = 0;
        _isforbid = NO;
        [self createcollectionview];
    }
    return self;
}

- (void)createcollectionview
{
    for (UIViewController *childvc in self.controllers) {
        childvc.view.frame = CGRectMake(0, 64+40, self.frame.size.width, self.frame.size.height - 64-40);
//        childvc.view.frame = self.bounds;
        [self.parentvc.view addSubview:childvc.view];
    }
    UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
    flowout.minimumLineSpacing = 0;
    flowout.minimumInteritemSpacing = 0;
    flowout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowout.itemSize =CGSizeMake(self.frame.size.width, self.frame.size.height);
    UICollectionView *collectionview = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowout];
    collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview = collectionview;
            [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    collectionview.pagingEnabled = YES;
    collectionview.clipsToBounds = YES;
    [self addSubview:_collectionview];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isforbid = NO;
    //记录先前滑动的位置
    _startconstOfx =scrollView.contentOffset.x;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_isforbid) {
        return;
    }
    //1 确定向左还是向右滑动
    _endConstOfx = scrollView.contentOffset.x;
    CGFloat  scrollw =  scrollView.bounds.size.width;
//    _endPage = _endConstOfx % (NSInteger)self.frame.size.width;
    if (_startconstOfx < _endConstOfx) {//向左
        //1 计算progress
        self.pregress = _endConstOfx/scrollw -floor(_endConstOfx/scrollw);//利用取整函数求出进度
         //2 计算sourceIndex
        _startPage = (NSInteger)_endConstOfx / scrollw;
        //3 计算targetIndex
        _endPage  = _startPage + 1;
        if (_endPage >= self.controllers.count) {
            _endPage = self.controllers.count - 1;
        }
        //4 完全滑过去
        if (_endConstOfx -_startconstOfx == scrollw) {
            self.pregress = 1;
            _endPage = _startPage;
                  }
        NSLog(@"start-----=== %d  end-----%d progress=======---%f",_startPage,_endPage,self.pregress);
    }else{//向右
        // 1 计算progress
        self.pregress = 1 - (_endConstOfx / scrollw -floor(_endConstOfx/scrollw));
        //2 计算targtindex
        _endPage = _endConstOfx / scrollw;
        //3 计算sourceindex
        _startPage = _endPage + 1;
        
        if (_startPage >= self.controllers.count) {
            _startPage = self.controllers.count - 1;
        }
        //4 当完全滑过去的时候
        if (_endConstOfx - _startconstOfx == scrollw) {
            self.pregress = 1;
            _endPage = _startPage;
        }
        NSLog(@"-----=== %d  end-----%d progress=======---%f",_startPage,_endPage,self.pregress);
    }
    if ([self.delegate respondsToSelector:@selector(scrollPress:soureIndex:targetIndex:)]) {
        [self.delegate scrollPress:_pregress soureIndex:_startPage targetIndex:_endPage];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _controllers.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    for (UIView *childv in cell.contentView.subviews) {
        [childv removeFromSuperview];
    }
    UIViewController *vc = self.controllers[indexPath.item];
    [cell.contentView addSubview:vc.view];
    vc.view.frame = cell.bounds;
    return cell;

}

- (void)collectionViewScrollToPageIndex:(NSInteger)index
{
    _isforbid = YES;
    CGFloat wideth = self.frame.size.width *index;
    self.collectionview.contentOffset = CGPointMake(wideth, 0);
    NSLog(@"-------%d",index);
}


@end
