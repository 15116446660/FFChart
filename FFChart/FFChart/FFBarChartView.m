//
//  FFBarChartView.m
//  FFChart
//
//  Created by wangpengfei on 2014/3/15.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "FFBarChartView.h"
#import "FFBar.h"

@implementation FFBarChartView

- (void)stroke {
    
    [self clearChart];
    [self setupUI];
    
    if (self.values == nil || self.values.count == 0) {
        
        return;
    }
    
    for (int i = 0; i < self.values.count; i++) {
        //
        FFBar *bar = [[FFBar alloc] initWithFrame:CGRectMake(self.x_spacing + i*(2*self.x_spacing + self.x_w), 0.f, self.x_w, self.scrollView.frame.size.height - self.origin.y) maxValue:self.totalMax];
        bar.barColors = self.colors;
        bar.values = self.values[i];
        
        [self.scrollView addSubview:bar];
    }
}

@end
