//
//  NSString+PureNumber.m
//  FFChart
//
//  Created by wangpengfei on 2014/3/15.
//  Copyright © 2014年 wangpf. All rights reserved.
//

#import "NSString+PureNumber.h"

@implementation NSString (PureNumber)

- (BOOL)isPureInt {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    int value;
    
    return [scanner scanInt:&value] && [scanner isAtEnd];
}

- (BOOL)isPureFloat {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    float value;
    
    return [scanner scanFloat:&value] && [scanner isAtEnd];
}

@end
