//
//  FFChartView.m
//  FFChart
//
//  Created by wangpengfei on 2017/3/14.
//  Copyright © 2017年 wangpf. All rights reserved.
//

#import "FFChartView.h"
#import "NSString+PureNumber.h"
#import "UIColor+ChartColor.h"
#import <math.h>

#define BG_COLOR [UIColor colorWithRed:173.f/255.f green:216.f/255.f blue:230.f/255.f alpha:1.0]
#define TOP_VIEW_H 32.f
#define CHART_MARGIN 12.f
#define SERIES_W 50.f
#define SERIES_VIEW_WH 8.f

typedef NS_ENUM(NSInteger, FFLayoutType) {
    
    FFLayoutTypeLeftRight,
    FFLayoutTypeTopBottom,
    FFLayoutTypeInParent
};

@interface FFChartView () {
    //
    struct {
        unsigned int chartView_title : 1;
        unsigned int chartView_xLabel : 1;
        unsigned int chartView_colors : 1;
        unsigned int chartView_series : 1;
        unsigned int chartView_values : 1;
    }_dataSourceFlag;
}

/** 图表标题 */
@property (nonatomic, copy) NSString *title;

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray<UIColor *> *colors;   //系列颜色
@property (nonatomic, copy) NSArray<NSString *> *series;   //系列名称

@property (nonatomic, copy) NSArray<NSString *> *xArray;    //X 轴名称
@property (nonatomic, copy) NSArray<NSString *> *yArray;    //y 轴名称

@property (nonatomic, copy) NSArray<NSArray *> *values;

/** 最大和值 */
@property (nonatomic, assign) float totalMax;

/** 最大值 */
@property (nonatomic, assign) float max;

/** 最小上限整数值 */
@property (nonatomic, assign) float upper_limit;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FFChartView

#pragma mark - Public Method

+ (instancetype)chartWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

#pragma mark - Privice Method

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        //
        
        [self initialize];
    }
    
    return self;
}

- (void)setDataSource:(id<FFChartDataSource>)dataSource {
    
    _dataSource = dataSource;
    
    _dataSourceFlag.chartView_title = [self.dataSource respondsToSelector:@selector(chartView_title:)];
    _dataSourceFlag.chartView_xLabel = [self.dataSource respondsToSelector:@selector(chartView_xLabel:)];
    _dataSourceFlag.chartView_colors = [self.dataSource respondsToSelector:@selector(chartView_colors:)];
    _dataSourceFlag.chartView_series = [self.dataSource respondsToSelector:@selector(chartView_series:)];
    _dataSourceFlag.chartView_values = [self.dataSource respondsToSelector:@selector(chartView_values:)];
    
    //加载数据源
    [self loadData];
}

//初始化图表属性
- (void)initialize {
    
    _backColor = [UIColor whiteColor];
    _compact = NO;
    _xAxis = YES;
    _yAxis = YES;
    _origin = CGPointMake(30.f, 20.f);
    _x_w = 15.f;
    _x_spacing = 0.5*_x_w;
    _axisColor = [UIColor lavender];
}

//初始化基本UI 元素
- (void)setupUI {
    
    [self setBackColor:[UIColor whiteColor]];
    
    // 1、添加标题、标注
    [self showTopView];
    
    // 2、添加滚动视图
    [self showScrollView];
    
    // 3、添加Y 轴线
    [self showYAxis];
    
    // 4、添加Y 轴文字
    [self showYLabel];
    
    // 5、添加X 轴线
    [self showXAxis];
    
    // 6、添加Y 轴文字
    [self showXLable];
    
    // 7、设置背景颜色
    [self setColor];
    
}

- (void)loadData {
    
    if (_dataSourceFlag.chartView_title) {
        self.title = [self.dataSource chartView_title:self];
    }
    
    if (_dataSourceFlag.chartView_xLabel) {
        self.xArray = [self.dataSource chartView_xLabel:self];
    }
    
    if (_dataSourceFlag.chartView_series) {
        self.series = [self.dataSource chartView_series:self];
    }
    
    if (_dataSourceFlag.chartView_colors) {
        self.colors = [self.dataSource chartView_colors:self];
    }
    
    if (_dataSourceFlag.chartView_values) {
        self.values = [self.dataSource chartView_values:self];
    }
    NSAssert(self.xArray.count == self.values.count, @"X轴 标签数量 和 数组个数 不一致！");
    NSAssert(self.series.count == self.colors.count, @"颜色个数和系列个数必须需一致！");
    
    if (self.values.count > 0) {
        id valueObj = self.values[0];
        
        NSAssert([valueObj isKindOfClass:[NSArray class]], @"数值不为数组！");
        NSAssert([valueObj count] == self.series.count, @"数值数组元素个数和系列数不匹配！");
    }
    _totalMax = [self totalMax];
}

- (float)totalMax {
    
    _totalMax = [self totalMaxOfArray:self.values];
    return _totalMax;
}

- (float)max {
    return [self maxOfArray:self.values];
}

- (float)upper_limit {
    
    _upper_limit = [self maxOfArray:self.values];
    return upper_limit(_upper_limit);
}

//获取整数的近似数(整百、整千……)
int upper_limit(float max) {
    
    int first = get_first_num(max);
    
    if (first < 3) {
        return 3*pow(10, (get_num_len(max)-1));
    } else if (first < 5) {
        return 5*pow(10, (get_num_len(max)-1));
    } else {
        return 10*pow(10, (get_num_len(max)-1));
    }
    
    return 0;
}

//获取整数位数
int get_num_len(int x)
{
    int i=0;
    while(x!=0)
    {
        x = x/10;
        i++;
    }
    return i;
}

//获取整数首位数字
int get_first_num (int x) {
    
    if (get_num_len(x) == 1) {
        return 1;
    }
    return x/((get_num_len(x)-1)*10);
}

- (void)showTopView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f,SELF_W , TOP_VIEW_H)];
    topView.backgroundColor = [UIColor aliceBlue];
    [self addSubview:topView];
    
    if (self.series) {
        
        CGFloat referX = SELF_W;
        UIView *seriesView;
        
        for (NSInteger i = self.series.count-1; i >= 0; i--) {
            
            UIColor *color = self.colors[i];
            
            seriesView = [self seriesViewWithName:self.series[i] color:color];
            seriesView.frame = CGRectMake(referX - CGRectGetWidth(seriesView.frame), 0.f, CGRectGetWidth(seriesView.frame), CGRectGetHeight(seriesView.frame));
            [topView addSubview:seriesView];
            
            referX -= CGRectGetWidth(seriesView.frame);
        }
        self.titleLabel.frame = CGRectMake(CHART_MARGIN, CHART_MARGIN, SELF_W - self.series.count * CGRectGetWidth(seriesView.frame) - 2*CHART_MARGIN, TOP_VIEW_H - 2*CHART_MARGIN);
    } else {
        self.titleLabel.frame = CGRectMake(CHART_MARGIN, CHART_MARGIN, SELF_W - 2*CHART_MARGIN, TOP_VIEW_H - 2*CHART_MARGIN);
    }
    self.titleLabel.text = self.title;
    [topView addSubview:self.titleLabel];
    
}

- (UIView *)seriesViewWithName:(NSString *)name color:(UIColor *)color {
    
    UIView *view;
    
    CGFloat spacing = 4.f;
    view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SERIES_W, TOP_VIEW_H)];
    view.backgroundColor = [UIColor clearColor];
    
    //系列色块
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(spacing, (CGRectGetHeight(view.frame) - SERIES_VIEW_WH)/2, SERIES_VIEW_WH, SERIES_VIEW_WH)];
    colorView.backgroundColor = color;
    [view addSubview:colorView];
    
    //系列名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorView.frame) + spacing, spacing, CGRectGetWidth(view.frame) - 3*spacing - CGRectGetWidth(colorView.frame), CGRectGetHeight(view.frame) - 2*spacing)];
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:10.f];
    nameLabel.textColor = [UIColor lightSteelBlue4];
    [view addSubview:nameLabel];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    return view;
}

- (void)showScrollView {
    
    self.scrollView.frame = CGRectMake(self.origin.x, TOP_VIEW_H + CHART_MARGIN, SELF_W - self.origin.x - CHART_MARGIN, SELF_H - (TOP_VIEW_H + CHART_MARGIN));
    [self addSubview:self.scrollView];
}

- (void)showYAxis {
    
    if (self.yAxis == NO) {
        return;
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(self.origin.x, SELF_H - self.origin.y)];
    [path addLineToPoint:CGPointMake(self.origin.x, CGRectGetMinY(self.scrollView.frame))];
     
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.axisColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.layer addSublayer:shapeLayer];
}

- (void)showYLabel {
    
    CGFloat setpY = (CGRectGetHeight(self.scrollView.frame) - self.origin.y) / 5;
    for (int i = 0; i < 6; i++) {
        NSString *valueStr;
        
        if ([self isKindOfClass:[NSClassFromString(@"FFBarChartView") class]]) {
            
            valueStr = [NSString stringWithFormat:@"%.0f",self.totalMax*(i/5.0f)];
            
        } else if ([self isKindOfClass:[NSClassFromString(@"FFlineChartView") class]]) {
            valueStr = [NSString stringWithFormat:@"%.0f",self.upper_limit*(i/5.0f)];
        }
        
        [self addLabelInParentView:self point:CGPointMake(self.origin.x/2, SELF_H - self.origin.y - setpY * i) text:valueStr width:self.origin.x];
    }
}

- (void)addLabelInParentView:(UIView *)parent point:(CGPoint )point text:(NSString *)text width:(CGFloat)width {
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.bounds = CGRectMake(0.f, 0.f, width, 12.f);
    textLayer.string = text;
    textLayer.fontSize = 10.f;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = [UIColor grey51].CGColor;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.borderColor = [UIColor darkTextColor].CGColor;
    textLayer.position = point;
    [parent.layer addSublayer:textLayer];
}

- (float )totalMaxOfArray:(NSArray *)array {
    
    static float totalMax = 0;  //全局 最大和值
    
    if (array.count > 0 && ![array[0] isKindOfClass:[NSArray class]]) {
        
        float total = 0;    //局部 最大和值
        
        for (int i = 0 ; i < array.count; i++) {
            //
            NSString *value = array[i];
            NSAssert([value isPureFloat] || [value isPureInt], @"图表只能接收数值类型数据！");
            
            total += [value floatValue];
            
            totalMax = totalMax > total ? totalMax : total;
            
            //获取10进制倍数最大值
            
        }
    } else {
        
        for (int i = 0; i < array.count; i++) {
            NSArray *subArray = array[i];
            [self totalMaxOfArray:subArray];
        }
    }
    return totalMax;
}

- (float )maxOfArray:(NSArray *)array {
    
    static float max = 0;  //全局 最大和值
    
    if (array.count > 0 && ![array[0] isKindOfClass:[NSArray class]]) {
        
        for (int i = 0 ; i < array.count; i++) {
            //
            NSString *value = array[i];
            NSAssert([value isPureFloat] || [value isPureInt], @"图表只能接收数值类型数据！");
            
            max = max > [value floatValue] ? max : [value floatValue];
            
            //获取10进制倍数最大值
            
        }
    } else {
        
        for (int i = 0; i < array.count; i++) {
            NSArray *subArray = array[i];
            [self maxOfArray:subArray];
        }
    }
    return max;
}

- (void )adjustX_W {
    
    //紧凑显示
    //预设单元宽度(x_w)和间距（x_spacing）累计小于 scrollview 宽度，使缺省单元宽度失效，重新计算单元宽度，并且不能太宽
//    self.compact = YES;
    if ([self isKindOfClass:[NSClassFromString(@"FFBarChartView") class]]) {
        if (self.compact) {
            
            //1、先尝试使spacing = width
            
            CGFloat width = self.scrollView.frame.size.width / (self.values.count+1);
            CGFloat spacing = width;
            //2、如果width > 合适宽度
            if (width > 15.f) {
                width = 15.f;
                spacing = (self.scrollView.frame.size.width/self.values.count - width)/2;
            }
            self.x_w = width;
            self.x_spacing = spacing;
            
        } else {    //非紧凑显示,并重新计算，假设 spacing = 2*width
            
            CGFloat totalWidth = 5*self.values.count*self.x_w;
            
            if (totalWidth < self.scrollView.frame.size.width) {
                
                totalWidth = self.scrollView.frame.size.width;
                
                self.x_w = totalWidth/(5*self.values.count);
                self.x_spacing = 2*self.x_w;
                //2、如果width > 合适宽度
                if (self.x_w > 15.f) {
                    self.x_w = 15.f;
                    self.x_spacing = (totalWidth-self.values.count*self.x_w)/(self.values.count*2);
                }
            }
        }
    } else if ([self isKindOfClass:[NSClassFromString(@"FFlineChartView") class]]) {
        
        CGFloat totalWidth = self.values.count*self.x_w + 2*self.values.count*self.x_spacing;
        
        if (totalWidth < self.scrollView.frame.size.width) {
            self.x_w = self.scrollView.frame.size.width/self.values.count - 2*self.x_spacing;
        }
        
        if (self.compact == YES && totalWidth > self.scrollView.frame.size.width) {
            self.x_w = self.scrollView.frame.size.width/self.values.count - 2*self.x_spacing;
        }
    }
    
}

- (void)resetContentWidth {
    self.scrollView.contentSize = CGSizeMake(self.values.count * (self.x_w + 2*self.x_spacing), self.scrollView.frame.size.height);
}

- (void)showXAxis {
    
    if (self.xAxis == NO) {
        return;
    }
    
    [self adjustX_W];
    [self resetContentWidth];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, self.scrollView.frame.size.height - self.origin.y)];
    [path addLineToPoint:CGPointMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height - self.origin.y)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.axisColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.scrollView.layer addSublayer:shapeLayer];
}

- (void)showXLable {
    
    for (int i = 0; i < self.values.count; i++) {
        NSString *xLable = self.xArray[i];
        [self addLabelInParentView:self.scrollView point:CGPointMake(self.x_spacing + i*(2*self.x_spacing + self.x_w) + self.x_w/2, self.scrollView.frame.size.height - self.origin.y/2) text:xLable width:(self.x_w+2*self.x_spacing)];
    }
}

- (void)setColor {
    
    self.backgroundColor = self.backColor;
    self.scrollView.backgroundColor = self.backColor;
}

- (void)clearChart {
    
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.scrollView.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - Lazy Load

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor grey11];
    }
    
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}

@end
