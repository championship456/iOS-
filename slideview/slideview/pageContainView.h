//
//  pageContainView.h
//  slideview
//
//  Created by amc on 2017/3/22.
//  Copyright © 2017年 amc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pageContainView;
@protocol pageContainViewDelegate <NSObject>

- (void)scrollPress:(CGFloat)progress soureIndex:(NSInteger)sourIndex targetIndex:(NSInteger)targetIndex;

@end


@interface pageContainView : UIView
- (instancetype)initWithFrame:(CGRect)frame viewController:(NSMutableArray *)viewcontrollers parentviewcontroller:(UIViewController *)parentvc;

- (void)collectionViewScrollToPageIndex:(NSInteger)index;


@property (nonatomic,weak) id <pageContainViewDelegate>delegate;

@end
