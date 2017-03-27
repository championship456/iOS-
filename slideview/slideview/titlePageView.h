//
//  titlePageView.h
//  slideview
//
//  Created by amc on 2017/3/22.
//  Copyright © 2017年 amc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class titlePageView;
@protocol titlePageViewDelegate <NSObject>

- (void)changeControllerToIndex:(NSInteger )index;

@end


@interface titlePageView : UIView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSMutableArray *)titles;

- (void)progress:(CGFloat)progress sourIndex:(NSInteger)sourIntex tagetIndex:(NSInteger)targetIndex;

@property (nonatomic,weak) id<titlePageViewDelegate>deleagte;

@end
