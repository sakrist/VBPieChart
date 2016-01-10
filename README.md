<img src="https://travis-ci.org/sakrist/VBPieChart.svg?branch=master"><br \>

VBPieChart
==========

Animated Pie Chart control for iOS apps, based on CALayer. Very easy in use and have custom labeling.

<img src="https://raw.githubusercontent.com/sakrist/VBPieChart/master/Screenshot.png" width="50%">


Usage
-----

    VBPieChart *chart = [[VBPieChart alloc] init];
    [self.view addSubview:chart];
    [chart setFrame:CGRectMake(10, 50, 300, 300)];
    [chart setEnableStrokeColor:YES];
    [chart setHoleRadiusPrecent:0.3]; /* hole inside of chart */
    NSArray *chartValues = @[...];
    [chart setChartValues:chartValues animation:YES];
    


Animation options:

* `VBPieChartAnimationFanAll`
* `VBPieChartAnimationGrowth`
* `VBPieChartAnimationGrowthAll`
* `VBPieChartAnimationGrowthBack`
* `VBPieChartAnimationGrowthBackAll`
* `VBPieChartAnimationFan`
* `VBPieChartAnimationTimingEaseInOut`
* `VBPieChartAnimationTimingEaseIn`
* `VBPieChartAnimationTimingEaseOut`
* `VBPieChartAnimationTimingLinea`

For:<br />
    `- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(VBPieChartAnimationOptions)options;`

<br>
Version: 0.3.2<br>
License: [MIT](http://opensource.org/licenses/MIT)
<br>
Any contributions are welcome!

