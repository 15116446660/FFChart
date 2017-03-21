//
//  FFlineChartView.h
//  FFChart
//
//  Created by wangpengfei on 2014/3/17.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "FFChartView.h"

@interface FFlineChartView : FFChartView

@property (nonatomic, assign) BOOL showBar; //default YES

- (void)stroke;

@end
