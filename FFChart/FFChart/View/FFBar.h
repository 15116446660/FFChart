//
//  FFBar.h
//  FFChart
//
//  Created by wangpengfei on 2017/3/16.
//  Copyright © 2017年 wangpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFBar : UIView

/** 柱子最大和值 */
@property (nonatomic, readonly, assign) float totalMax;

/** 动画时长 */
@property (nonatomic, assign) NSTimeInterval duration;

/** 柱子数值 */
@property (nonatomic, copy) NSArray<NSString *> *values;

/** 背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;

/** 柱子颜色*/
@property (nonatomic, strong) NSArray<UIColor *> *barColors;


- (instancetype)initWithFrame:(CGRect)frame maxValue:(float)totalMax;

@end
