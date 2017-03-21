//
//  FFChartView.h
//  FFChart
//
//  Created by wangpengfei on 2014/3/14.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SELF_W self.frame.size.width
#define SELF_H self.frame.size.height

//typedef NS_ENUM(NSInteger, FFChartType) {
//    FFChartTypeLineChart,
//    FFChartTypeBarChart
//};

@class FFChartView;

@protocol FFChartDataSource <NSObject>

@required
- (NSString *)chartView_title:(FFChartView *)chartView;
- (NSArray<NSString *> *)chartView_xLabel:(FFChartView *)chartView;
- (NSArray<UIColor *> *)chartView_colors:(FFChartView *)chartView;
- (NSArray<NSString *> *)chartView_series:(FFChartView *)chartView;
- (NSArray<NSArray *> *)chartView_values:(FFChartView *)chartView;

//
@optional

@end

@protocol FFChartDelegate <NSObject>

//

@end

@interface FFChartView : UIView

@property (nonatomic, weak) id<FFChartDataSource> dataSource;
//@property (nonatomic, weak) id<FFChartDelegate> delegate;

/** 滚动视图 */
@property (nonatomic, readonly, strong) UIScrollView *scrollView;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *backColor;

/** 紧凑(松散)排列 */
@property (nonatomic, assign) BOOL compact;  //default is NO

@property (nonatomic, assign) CGFloat x_w;

@property (nonatomic, assign) CGFloat x_spacing;

@property (nonatomic, assign) CGPoint origin;   //垂直坐标系的原地位置（左下位置）

/** 显示X轴 */
@property (nonatomic, assign) BOOL xAxis;
/** 显示Y轴 */
@property (nonatomic, assign) BOOL yAxis;

@property (nonatomic, strong) UIColor *axisColor;

@property (nonatomic, readonly, copy) NSArray<NSString *> *series;   //系列名称

@property (nonatomic, readonly, copy) NSArray<UIColor *> *colors;   //系列颜色

@property (nonatomic, readonly, copy) NSArray<NSArray *> *values;

/** 最大和值 */
@property (nonatomic, readonly, assign) float totalMax;

/** 最小上限整数值 */
@property (nonatomic, readonly, assign) float upper_limit;

/** 最大值 */
@property (nonatomic, readonly, assign) float max;

+ (instancetype )chartWithFrame:(CGRect )frame;
- (void)setupUI;
- (void)clearChart;

@end
