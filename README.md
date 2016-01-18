![](https://travis-ci.org/sakrist/VBPieChart.svg?branch=master)
![](https://img.shields.io/cocoapods/v/VBPieChart.svg?style=flat)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)<br \>
#VBPieChart

Animated Pie Chart control for iOS apps, based on CALayer. Very easy in use and have custom labeling.

##Usage


#####Create instance of VBPieChart:

```
VBPieChart *chart = [[VBPieChart alloc] init];
[self.view addSubview:chart];
```

#####Setup some options:

```
[chart setFrame:CGRectMake(10, 50, 300, 300)]; // frame
[chart setEnableStrokeColor:YES]; 
[chart setHoleRadiusPrecent:0.3]; /* hole inside of chart */
``` 

#####Prepare your data:

```
NSArray *chartValues = @[
 @{@"name":@"Apples", @"value":@50, @"color":[UIColor redColor]},
 @{@"name":@"Pears", @"value":@20, @"color":[UIColor blueColor]},
 @{@"name":@"Oranges", @"value":@40, @"color":[UIColor orangeColor]},
 @{@"name":@"Bananas", @"value":@70, @"color":[UIColor purpleColor]}
];
```
`chartValues` needs to be defined as an array of dictionaries.<br>
Dictionary **required** to contain value for piece with key `value`.<br>
Optional:

- `name`
- `color`
- `labelColor`
- `accent`
- `strokeColor`

#####Present pie charts with animation:

```
[chart setChartValues:chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];
```


## Documentation

`VBPieChart` is subclass of `UIView`

####Properties

`length`<br />
Length of circle pie. Min values is 0 and max value M_PI*2.

`startAngle`<br />
Start angle of pie. (M_PI will make start at left side)

`holeRadiusPrecent`<br />
hole radius in % of whole radius. Values 0..1. (acual hole radius will be calculated **radius***`holeRadiusPrecent`)

`radiusPrecent` <br />
Defines the **radius**,  **full radius** = frame.size.width/2, actual **radius** = **full radius***`radiusPrecent`. Value 0..1.

`labelBlock`<br />
Block will help to redefine positions for labels.

####Methods

Simple setup data.<br />
`- (void) setChartValues:(NSArray *)chartValues;`<br />

Setup data to pie chart with animation or not, animation options and duration.<br />
`- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(VBPieChartAnimationOptions)options;`

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
* `VBPieChartAnimationTimingLinear`

Change value for elemet at index. Value will be changed with animation. <br />
`- (void) setValue:(NSNumber*)value pieceAtIndex:(NSInteger)index;` <br />

Remove piece at index.<br />
`- (void) removePieceAtIndex:(NSInteger)index;`<br />

Change values in multiple sections. Values will be changed with animation. <br />
`- (void) setValues:(NSDictionary*)values;` <br />
Example: <br />
`[chartView setValues:@{@(0) : @(50), @(1) : @(70)}]; // set 50 for first and 70 for second sections` <br />

## Screenshots
<img src="https://raw.githubusercontent.com/sakrist/VBPieChart/master/Screenshot.png" width="50%">
