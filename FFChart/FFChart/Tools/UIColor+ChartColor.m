//
//  UIColor+ChartColor.m
//  FFChart
//
//  Created by wangpengfei on 2017/3/16.
//  Copyright © 2017年 wangpf. All rights reserved.
//

#import "UIColor+ChartColor.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)

@implementation UIColor (ChartColor)

+ (UIColor *)dodgerBlue {
    return RGB(30, 144, 255);
}

+ (UIColor *)limeGreen {
    return RGB(50, 205, 50);
}

+ (UIColor *)lavender {
    return RGB(230, 230, 250);
}

+ (UIColor *)gray81 {
    return RGB(207, 207, 207);
}

+ (UIColor *)grey51 {
    return RGB(130, 130, 130);
}

+ (UIColor *)grey11 {
    return RGB(28, 28, 28);
}

+ (UIColor *)aliceBlue {
    return RGB(240, 248, 255);
}

+ (UIColor *)darkOliveGreen4 {
    return RGB(110, 139, 61);
}

+ (UIColor *)lightSteelBlue4 {
    return RGB(110, 123, 139);
}

+ (UIColor *)orangeRed3 {
    return RGB(205, 55, 0);
}

+ (UIColor *)WhiteSmoke {
    return RGB(245, 245, 245);
}

@end
