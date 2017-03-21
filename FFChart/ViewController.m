//
//  ViewController.m
//  FFChart
//
//  Created by wangpengfei on 2014/3/14.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "ViewController.h"
#import "FFChartView.h"
#import "FFBarChartView.h"
#import "FFlineChartView.h"
#import "UIColor+ChartColor.h"

@interface ViewController () <FFChartDataSource>

@property (nonatomic, strong) FFBarChartView *barChart;
@property (nonatomic, strong) FFlineChartView *lineChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor WhiteSmoke];
    
    self.barChart = [FFBarChartView chartWithFrame:CGRectMake(10.f, 50.f, self.view.frame.size.width - 20.f, 180.f)];
    self.barChart.compact = NO;
    self.barChart.dataSource = self;
    [self.barChart stroke];
    [self.view addSubview:self.barChart];
    
    self.lineChart = [FFlineChartView chartWithFrame:CGRectMake(10.f, 280.f, self.view.frame.size.width - 20.f, 180.f)];
    self.lineChart.showBar = YES;
    self.lineChart.x_w = 25.f;
    self.lineChart.x_spacing = 2.f;
    self.lineChart.compact = YES;
//    self.lineChart.origin = CGPointMake(100.f, 50.f);
//    self.lineChart.yAxis = NO;
    self.lineChart.backColor = [UIColor WhiteSmoke];
    self.lineChart.dataSource = self;
    [self.lineChart stroke];
    [self.view addSubview:self.lineChart];
    
    UIButton *stroke = [UIButton buttonWithType:UIButtonTypeCustom];
    stroke.frame = CGRectMake((self.view.frame.size.width - 100.f)/2.f, 500, 100.f, 44.f);
    [stroke setTitle:@"重绘" forState:UIControlStateNormal];
    [stroke setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stroke setBackgroundColor:[UIColor limeGreen]];
    [stroke.layer setCornerRadius:4.f];
    [stroke addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:stroke];
}

#pragma mark - Click

- (void)click:(id)sender {
    
    [self.barChart stroke];
    [self.lineChart stroke];
}

#pragma mark - <FFChartDataSource>

- (NSString *)chartView_title:(FFChartView *)chartView {
    
    if ([chartView isEqual:self.barChart]) {
        return @"我是柱状图";
    } else if ([chartView isEqual:self.lineChart]) {
        return @"我是折线图";
    }
    
    return @"我是标题";
}

- (NSArray *)chartView_xLabel:(FFChartView *)chartView {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"A", @"B", @"C", @"D", @"E", @"F"];
}

- (NSArray<UIColor *> *)chartView_colors:(FFChartView *)chartView {
    
    return @[[UIColor dodgerBlue], [UIColor limeGreen], [UIColor darkOliveGreen4], [UIColor orangeRed3]];
}

- (NSArray<NSString *> *)chartView_series:(FFChartView *)chartView {
    return @[@"系列A", @"系列B", @"系列C", @"系列D"];
}

- (NSArray<NSArray *> *)chartView_values:(FFChartView *)chartView {
    
    return @[@[@"1", @"2", @"3", @"12"], @[@"4", @"5", @"6", @"8"], @[@"20", @"7", @"16", @"5"], @[@"1", @"2", @"3", @"25"], @[@"4", @"5", @"6", @"8"], @[@"40", @"7", @"16", @"5"], @[@"1", @"2", @"3", @"32"], @[@"4", @"5", @"6", @"8"], @[@"40", @"7", @"16", @"5"], @[@"1", @"2", @"3", @"15"], @[@"4", @"5", @"6", @"8"], @[@"30", @"7", @"16", @"5"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
