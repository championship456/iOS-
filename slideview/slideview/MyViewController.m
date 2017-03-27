
//
//  MyViewController.m
//  slideview
//
//  Created by amc on 2017/3/22.
//  Copyright © 2017年 amc. All rights reserved.
//

#import "MyViewController.h"
#import "titlePageView.h"

#import "pageContainView.h"
@interface MyViewController ()<titlePageViewDelegate,pageContainViewDelegate>

@property (nonatomic,weak)titlePageView *titleview;
@property (nonatomic,strong)pageContainView *pageview;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, 40);
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"游戏",@"娱乐",@"趣味",@"好玩", nil];
    titlePageView *pageview = [[titlePageView alloc]initWithFrame:rect titles:titles];
    self.titleview = pageview;
    [self.view addSubview:pageview];
    
    CGRect viewrect = CGRectMake(0, 64 + 40 , self.view.frame.size.width, self.view.frame.size.height - 64 - 40);
    pageview.deleagte = self;
    NSMutableArray *viewcontrollers = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIViewController *vc  = [[UIViewController alloc]init];
        [viewcontrollers addObject:vc];
        vc.view.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
//        if (i == 1) {
//            vc.view.backgroundColor = [UIColor yellowColor];
//        }else if (i == 3){
//            vc.view.backgroundColor = [UIColor magentaColor];
//        }
    }
    pageContainView *pagecontain = [[pageContainView alloc]initWithFrame:viewrect viewController:viewcontrollers parentviewcontroller:self];
    pagecontain.delegate = self;
    [self.view addSubview:pagecontain];
    self.pageview = pagecontain;
    self.title = @"斗鱼直播";
}

- (void)changeControllerToIndex:(NSInteger)index
{
    [self.pageview collectionViewScrollToPageIndex:index];

}

- (void)scrollPress:(CGFloat)progress soureIndex:(NSInteger)sourIndex targetIndex:(NSInteger)targetIndex
{

    [self.titleview progress:progress sourIndex:sourIndex tagetIndex:targetIndex];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
