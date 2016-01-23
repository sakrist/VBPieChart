[![](https://travis-ci.org/sakrist/VBPieChart.svg?branch=master)](https://travis-ci.org/sakrist/VBPieChart)
[![](https://img.shields.io/cocoapods/v/VBPieChart.svg?style=flat)](https://cocoapods.org/pods/VBPieChart)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)<br \>
#VBPieChart

Animated Pie Chart control for iOS apps, based on CALayer. Very easy in use and have custom labeling.

<img src="https://raw.githubusercontent.com/sakrist/VBPieChart/master/Screenshot.png" width="50%">

##Usage


#### Create simple pi chart with VBPieChart:

```objc
VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
[self.view addSubview:chart];

// Setup some options:
[chart setEnableStrokeColor:YES]; 
[chart setHoleRadiusPrecent:0.3]; /* hole inside of chart */

// Prepare your data
NSArray *chartValues = @[
 @{@"name":@"Apples", @"value":@50, @"color":[UIColor redColor]},
 @{@"name":@"Pears", @"value":@20, @"color":[UIColor blueColor]},
 @{@"name":@"Oranges", @"value":@40, @"color":[UIColor orangeColor]},
 @{@"name":@"Bananas", @"value":@70, @"color":[UIColor purpleColor]}
];

// Present pie chart with animation
[chart setChartValues:chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];
```

`chartValues` needs to be defined as an array of dictionaries.<br>
Dictionary **required** to contain value for piece with key `value`.<br>
Optional:

- `name`
- `color`
- `labelColor`
- `accent`
- `strokeColor`



#### Chart from JSON

```objc
VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
chart.startAngle = M_PI+M_PI_2;
chart.holeRadiusPrecent = 0.5;
[self.view addSubview:chart];
NSString *json_example = @"[ {\"name\":\"first\", \"value\":\"50\", \"color\":\"#84C69B\", \"strokeColor\":\"#fff\"}, \
{\"name\":\"second\", \"value\":\"60\", \"color\":\"#FECEA8\", \"strokeColor\":\"#fff\"}, \
{\"name\":\"second\", \"value\":\"75\", \"color\":\"#F7EEBB\", \"strokeColor\":\"#fff\"}, \
{\"name\":\"second\", \"value\":\"90\", \"color\":\"#D7C1E0\", \"strokeColor\":\"#fff\"} ]";

NSData *data = [json_example dataUsingEncoding:NSUTF8StringEncoding];
NSArray *chartValues = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

[chart setChartValues:chartValues animation:YES duration:0.5 options:VBPieChartAnimationFan];
```

#### Chart with custom label position
```objc
VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
chart.startAngle = M_PI+M_PI_2;
chart.holeRadiusPrecent = 0.5;
[self.view addSubview:chart];
[chart setLabelsPosition:VBLabelsPositionCustom];
[chart setLabelBlock:^CGPoint( CALayer *layer, NSInteger index) {
    CGPoint p = CGPointMake(sin(-index/10.0*M_PI)*50+50, index*30);
    return p;
}];

[chart setChartValues:@[
                         @{@"name":@"37%", @"value":@65, @"color":@"#5677fcaa", @"labelColor":@"#000"},
                         @{@"name":@"13%", @"value":@23, @"color":@"#2baf2baa", @"labelColor":@"#000"},
                         @{@"name":@"19.3%", @"value":@34, @"color":@"#b0bec5aa", @"labelColor":@"#000"},
                         @{@"name":@"30.7%", @"value":@54, @"color":@"#f57c00aa", @"labelColor":@"#000"}
                         ]
             animation:YES];
```

## Basic Documentation

`VBPieChart` is subclass of `UIView`.

####Properties

`length`<br />
Length of circle pie. Min values is 0 and max value 2*M_PI.

`startAngle`<br />
Start angle of pie. (M_PI will make start at left side)

`holeRadiusPrecent`<br />
hole radius in % of whole radius. Values 0..1. (acual hole radius will be calculated **radius***`holeRadiusPrecent`)

`radiusPrecent` <br />
Defines the **radius**,  **full radius** = frame.size.width/2, actual **radius** = **full radius***`radiusPrecent`. Value 0..1.

`labelBlock`<br />
Block will help to redefine positions for labels.

####Methods

Get all changed chart values back.<br />
`- (NSArray *) chartValues;`<br />

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

Insert new piece at index. Animated.
`- (void) insertChartValue:(NSDictionary*)chartValue atIndex:(NSInteger)index;`

Remove piece at index.<br />
`- (void) removePieceAtIndex:(NSInteger)index;`<br />


