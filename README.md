# FFChart


A simple stack bar chart and stack line chart for iOS
 
![](https://github.com/15116446660/FFChart/raw/master/chart.gif)  

Usage
-----
Copy the FFChart folder to your project

    #import "FFStackBarChart.h"
    #import "FFStacklineChart.h"

    //For stack bar chart
    self.barChart = [FFStackBarChart chartWithFrame:CGRectMake(10.f, 50.f, self.view.frame.size.width - 20.f, 180.f)];
    self.barChart.compact = NO;
    self.barChart.dataSource = self;
    [self.barChart stroke];
    [self.view addSubview:self.barChart];
    
    //For stack line chart
    self.lineChart = [FFStacklineChart chartWithFrame:CGRectMake(10.f, 280.f, self.view.frame.size.width - 20.f, 180.f)];
    self.lineChart.showBar = YES;
    self.lineChart.x_w = 25.f;
    self.lineChart.x_spacing = 2.f;
    self.lineChart.compact = YES;
    self.lineChart.origin = CGPointMake(100.f, 50.f);
    self.lineChart.yAxis = NO;
    self.lineChart.backColor = [UIColor WhiteSmoke];
    self.lineChart.dataSource = self;
    [self.lineChart stroke];
    [self.view addSubview:self.lineChart];
