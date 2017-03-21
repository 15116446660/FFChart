//
//  FFStacklineChart.m
//  FFChart
//
//  Created by wangpengfei on 2014/3/17.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "FFStacklineChart.h"
#import "FFBar.h"
#import "UIColor+ChartColor.h"

@implementation FFStacklineChart

- (void)stroke {
    
    [self clearChart];
    [self setupUI];
    [self setupBar];    //Add background bar
    [self showLines];   //Add lines
}

- (void)setupBar {
    
    if (self.showBar == NO) {
        return;
    }
    
    CGFloat offsetX = self.x_w/2;
    CFTimeInterval duration = 1.0f;
    
    for (int i = 0; i < self.values.count; i++) {
        if (self.showBar == YES) {
            UIBezierPath *barPath = [UIBezierPath bezierPath];
            [barPath moveToPoint:CGPointMake(self.x_spacing + i*(2*self.x_spacing + self.x_w) + offsetX , self.scrollView.frame.size.height - self.origin.y)];
            [barPath addLineToPoint:CGPointMake(self.x_spacing + i*(2*self.x_spacing + self.x_w) + offsetX , 0.f)];
            
            CAShapeLayer *barLayer = [CAShapeLayer layer];
            barLayer.path = barPath.CGPath;
            barLayer.strokeColor = [UIColor lavender].CGColor;
            barLayer.fillColor = [UIColor redColor].CGColor;
            barLayer.lineWidth = self.x_w;
            [self.scrollView.layer addSublayer:barLayer];
            
            //增加动画
            CABasicAnimation *barAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            barAnimation.fromValue = @0.f;
            barAnimation.toValue = @1.f;
            barAnimation.duration = duration;
            barAnimation.beginTime = CACurrentMediaTime() + i*duration/self.values.count;
            barAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            barAnimation.fillMode = kCAFillModeBackwards;
            barAnimation.removedOnCompletion = YES;
            [barLayer addAnimation:barAnimation forKey:nil];
        }
        
    }
    
}

- (void)showLines {
    
    CGFloat offsetX = self.x_w/2;
    CGFloat radius = 1.5f;   //拐点图形半径
    CFTimeInterval duration = 1.5f;
    NSMutableArray *lineArray = [NSMutableArray array]; //各系列曲线数组
    NSMutableArray *dotsArray = [NSMutableArray array];    //缓存最大值点
    
    for (int i = 0; i < self.series.count; i++) {
        NSMutableArray *linePoints = [NSMutableArray array];    //线上的点
        NSMutableArray *dots = [NSMutableArray array];
        
        float maxProgress = 0.f;
        
        for (int j = 0; j < self.values.count; j++) {
            NSArray *subVlaues = self.values[j];
            NSAssert([subVlaues[i] isKindOfClass:[NSString class]], @"数值 数据类型 不是 字符串！");
            NSString *valueStr = subVlaues[i];
            
            float progress = [self progressOfValue:valueStr];
            
            NSNumber *isMax = [NSNumber numberWithBool:NO];
            if (progress >= maxProgress) {
                maxProgress = progress;
                isMax = [NSNumber numberWithBool:YES];
            }
            [dots addObject:isMax];
            
            NSValue *point = [NSValue valueWithCGPoint:CGPointMake(self.x_spacing + offsetX + j*(2*self.x_spacing + self.x_w), (self.scrollView.frame.size.height - self.origin.y)*(1-progress))];
            [linePoints addObject:point];
        }
        [lineArray addObject:linePoints];
        [dotsArray addObject:dots];
    }
    
    for (int i = 0; i < lineArray.count; i++) {
        NSArray *linePoints = lineArray[i];
        NSArray *dots = dotsArray[i];
        UIColor *color = self.colors[i];
        
        //点path
        for (int j = 0; j < linePoints.count; j++) {
            //
            NSNumber *isMax = dots[j];
            
            UIBezierPath *dotPath = [UIBezierPath bezierPath];
            NSValue *point = linePoints[j];
            [dotPath addArcWithCenter:[point CGPointValue] radius:radius startAngle:0.f endAngle:2*M_PI clockwise:YES];
            
            CAShapeLayer *dotLayer = [CAShapeLayer layer];
            dotLayer.path = dotPath.CGPath;
            dotLayer.strokeColor = color.CGColor;
            dotLayer.fillColor = [isMax boolValue] ? color.CGColor : [UIColor clearColor].CGColor;
            dotLayer.lineWidth = 1.f;
            [self.scrollView.layer addSublayer:dotLayer];
            
        }
        
        //折线path
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        for (int j = 0; j < linePoints.count; j++) {
            //
            NSValue *point = linePoints[j];
            CGPoint pt = [point CGPointValue];
            CGPoint lastPoint = linePath.empty ? CGPointZero : linePath.currentPoint;
            
            if (lastPoint.x != 0 && lastPoint.y != 0) {
                [linePath moveToPoint:CGPointMake(lastPoint.x + 2*radius, lastPoint.y)];
            }
            
            if (j == 0) {
                [linePath moveToPoint:CGPointMake(pt.x-radius, pt.y)];    //对x 偏移，以免占用空心点位置
            } else {
                [linePath addLineToPoint:CGPointMake(pt.x - radius, pt.y)];
            }
        }
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.path = linePath.CGPath;
        lineLayer.lineWidth = 1.f;
        lineLayer.strokeColor = color.CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.scrollView.layer addSublayer:lineLayer];
        
        //增加动画
        CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        lineAnimation.duration = duration;
        lineAnimation.beginTime = CACurrentMediaTime() + i*duration/2.f;
        lineAnimation.fromValue = @0.f;
        lineAnimation.toValue = @1.f;
        lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        lineAnimation.fillMode = kCAFillModeBackwards;
        lineAnimation.removedOnCompletion = YES;
        [lineLayer addAnimation:lineAnimation forKey:nil];
    }
}

- (float)progressOfValue:(NSString *)string {
    return [string floatValue]/self.upper_limit;
}

@end
