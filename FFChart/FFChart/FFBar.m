//
//  FFBar.m
//  FFChart
//
//  Created by wangpengfei on 2014/3/16.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "FFBar.h"
#import "UIColor+ChartColor.h"

@interface FFBar () {
    UIBezierPath *backgroundPath;   //背景贝塞尔路径
    CAShapeLayer *backgroundLayer;  //背景层
    CATextLayer *valueLayer;    //数值文字层
}

/** 柱子最大值 */
@property (nonatomic, assign) float totalMax;

@end

@implementation FFBar

- (instancetype)initWithFrame:(CGRect)frame maxValue:(float)totalMax {
    
    if (self = [super initWithFrame:frame]) {
        
        _totalMax = totalMax;
        
        backgroundPath = [UIBezierPath bezierPath];
        [backgroundPath moveToPoint:CGPointMake(0.f, 0.f)];
        [backgroundPath addLineToPoint:CGPointMake(self.bounds.size.width, 0.f)];
        [backgroundPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        [backgroundPath addLineToPoint:CGPointMake(0.f, self.bounds.size.height)];
        [backgroundPath addLineToPoint:CGPointMake(0.f, 0.f)];
        [backgroundPath setLineWidth:1.f];
        [backgroundPath setLineCapStyle:kCGLineCapButt];
        
        backgroundLayer = [CAShapeLayer layer];
        backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
        backgroundLayer.fillColor = [UIColor lavender].CGColor;
        backgroundLayer.frame = self.bounds;
        backgroundLayer.path = backgroundPath.CGPath;
        [self.layer addSublayer:backgroundLayer];
        
        self.duration = 2.f;
    }
    
    return self;
}


- (void)setValues:(NSArray<NSString *> *)values {
    
    _values = [values copy];
    
    if (_values == nil || _values.count == 0) {
        return;
    }
    
    float totalProgress = 0.f;
    float spacingProgress = 0.01f;  //stack bar 之间的间距
    float lastProgress = 0.f;   //下方柱形的总值
    
    for (int i = 0 ; i < _values.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height*(1-totalProgress))];
        float progress = [self progressOfValue:values[i]] - spacingProgress;    //腾出0.01 的间隔空间
        totalProgress += progress;
        [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height*(1-totalProgress))];
        path.lineWidth = self.bounds.size.width;
        path.lineCapStyle = kCGLineCapSquare;
        
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        UIColor *color = self.barColors[i];
        progressLayer.strokeColor = color.CGColor;
        progressLayer.path = path.CGPath;
        progressLayer.lineWidth = self.bounds.size.width;
        [self.layer addSublayer:progressLayer];
        
        CABasicAnimation *barAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        barAnimation.duration = progress*self.duration;
        barAnimation.beginTime = CACurrentMediaTime()+lastProgress*self.duration;
        barAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        barAnimation.fromValue = @0.0f;
        barAnimation.toValue = @1.0f;
        barAnimation.removedOnCompletion = YES;
        barAnimation.fillMode = kCAFillModeBackwards;   //显示动画的初始状态
        
        progressLayer.strokeStart = 0.f;
        progressLayer.strokeEnd = 1.0f;
        [progressLayer addAnimation:barAnimation forKey:nil];
        
        totalProgress += spacingProgress;   //补偿空间
        lastProgress = totalProgress;
    }
}

- (float)progressOfValue:(NSString *)string {
    return [string floatValue]/self.totalMax;
}

@end
