VBPieChart
==========

Charts iOS Control with animations


<img src="https://github.com/sakrist/VBPieChart/blob/master/demonstration.gif">


Usage
-----

    VBPieChart *chart = [[VBPieChart alloc] init];
    [self.view addSubview:chart];
    [chart setFrame:CGRectMake(10, 50, 300, 300)];
    [chart setEnableStrokeColor:YES];
    [chart setHoleRadiusPrecent:0.3]; /* hole inside of chart */
    NSDictionary *chartValues = @{...};
    [chart setChartValues:chartValues animation:YES duration:0.7 options:(VBPieChartAnimationFanAll | VBPieChartAnimationTimingLinear)];
    /* similar to default */
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


Version: 0.2.0
-----

License: [MIT](http://opensource.org/licenses/MIT)
-----

Twitter: [@SAKrisT](https://twitter.com/SAKrisT)
