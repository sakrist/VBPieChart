//
//  VBCViewController.m
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import "VBCViewController.h"
#import "UIColor+HexColor.h"
#import "VBPieChart.h"



@interface VBCViewController ()

@property (nonatomic, retain) VBPieChart *chart;
@end

@implementation VBCViewController
- (IBAction)valueChangedSlider:(UISlider*)sender {
    
    float value = [sender value];
    
    switch (sender.tag) {
        case 0: {
//            [_chart setFrame:CGRectMake(100, 100, value, value)];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_chart.chartValues];
            
            NSString *key = [[dict allKeys] objectAtIndex:sender.tag];
            [dict setObject:[NSNumber numberWithFloat:sender.value] forKey:key];
            _chart.chartValues = dict;
        }
            break;
            
        case 1:
            [_chart setRadiusPrecent:value];
            break;
        case 2:
            [_chart setHoleRadiusPrecent:value];
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNeedsLayout];
    
    if (!_chart) {
        _chart = [[VBPieChart alloc] init];
        [self.view addSubview:_chart];
    }
    [_chart setFrame:CGRectMake(10, 50, 300, 300)];
    [_chart setEnableStrokeColor:YES];
    _chart.length = M_PI;
    _chart.startAngle = M_PI;
    
    [_chart.layer setShadowOffset:CGSizeMake(2, 2)];
    [_chart.layer setShadowRadius:3];
    [_chart.layer setShadowColor:[UIColor blackColor].CGColor];
    [_chart.layer setShadowOpacity:0.7];
    
//    [_chart setEnableInteractive:YES];
    [_chart setHoleRadiusPrecent:0.3];
    NSDictionary *chartValues = @{
//                         @"first2":  @{@"value":@30, @"accent":@YES},
//                          @"first":  @{@"value":@30, @"accent":@YES},
                           @"firsts":  @{@"value":@35 },
                           @"first 2":  @{@"value":@20 },
                           @"first 3":  @{@"value":@10 },
                           @"first ":  @{@"value":@40},
                           @"second": @20,
                           @"third": @40,
                           @"fourth": @10,
//                           @"fourth 2": @70,
//                           @"fourth 3": @65,
//                           @"fourth 4": @23,
//                           @"fourth 5": @34,
//                           @"fourtdh 6": @54,
//                           @"fiftdh 3": @30,
//                           @"firsdt 3": @50,
//                           @"second asdf": @20,
//                           @"thirdds": @40,
//                           @"fourthasd": @10,
//                           @"fourthsdf 2": @70,
//                           @"foursth 3": @65,
//                           @"fourthsf 4": @23,
//                           @"fourftfsh 5": @34,
//                           @"fourtfh 6": @54,
//                           @"fiftfsfh 3": @30
                           };

    [_chart setChartValues:chartValues animation:YES];
//    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationGrowth];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)setanother:(id)sender {
    NSDictionary *chartValues = @{
                           @"first": @{@"value":@50, @"color":[UIColor colorWithRed:0.55 green:0.77 blue:0.53 alpha:1.0]},
                           @"second": @{@"value":@20, @"color":[UIColor colorWithRed:0.33 green:0.17 blue:0.48 alpha:1.0]},
                           @"third": @{@"value":@40, @"color":[UIColor colorWithRed:0.81 green:0.61 blue:0.02 alpha:1.0]},
                           @"fourth": @{@"value":@10, @"color":[UIColor colorWithRed:0.31 green:0.74 blue:0.91 alpha:1.0]},
                           @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithRed:0.43 green:0.02 blue:0.46 alpha:1.0]},
                           @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithRed:0.00 green:0.51 blue:0.08 alpha:1.0]},
                           @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithRed:0.84 green:0.66 blue:0.81 alpha:1.0]},
                           @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithRed:0.73 green:0.20 blue:0.63 alpha:1.0]},
                           @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithRed:0.83 green:0.20 blue:0.15 alpha:1.0]}
                           };
    
    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationGrowthAll | VBPieChartAnimationTimingEaseInOut];
}

- (IBAction)setanother1:(id)sender {
    NSDictionary *chartValues = @{
                                  @"first": @{@"value":@50, @"color":[UIColor colorWithRed:0.55 green:0.77 blue:0.53 alpha:1.0]},
                                  @"second": @{@"value":@20, @"color":[UIColor colorWithRed:0.33 green:0.17 blue:0.48 alpha:1.0]},
                                  @"third": @{@"value":@40, @"color":[UIColor colorWithRed:0.81 green:0.61 blue:0.02 alpha:1.0]},
                                  @"fourth": @{@"value":@10, @"color":[UIColor colorWithRed:0.31 green:0.74 blue:0.91 alpha:1.0]},
                                  @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithRed:0.43 green:0.02 blue:0.46 alpha:1.0]},
                                  @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithRed:0.00 green:0.51 blue:0.08 alpha:1.0]},
                                  @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithRed:0.84 green:0.66 blue:0.81 alpha:1.0]},
                                  @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithRed:0.73 green:0.20 blue:0.63 alpha:1.0]},
                                  @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithRed:0.83 green:0.20 blue:0.15 alpha:1.0]}
                                  };
    
    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationGrowth];
}

- (IBAction)setanother3:(id)sender {
    NSDictionary *chartValues = @{
                                  @"first": @{@"value":@50, @"color":[UIColor colorWithRed:0.55 green:0.77 blue:0.53 alpha:1.0]},
                                  @"second": @{@"value":@20, @"color":[UIColor colorWithRed:0.33 green:0.17 blue:0.48 alpha:1.0]},
                                  @"third": @{@"value":@40, @"color":[UIColor colorWithRed:0.81 green:0.61 blue:0.02 alpha:1.0]},
                                  @"fourth": @{@"value":@10, @"color":[UIColor colorWithRed:0.31 green:0.74 blue:0.91 alpha:1.0]},
                                  @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithRed:0.43 green:0.02 blue:0.46 alpha:1.0]},
                                  @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithRed:0.00 green:0.51 blue:0.08 alpha:1.0]},
                                  @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithRed:0.84 green:0.66 blue:0.81 alpha:1.0]},
                                  @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithRed:0.73 green:0.20 blue:0.63 alpha:1.0]},
                                  @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithRed:0.83 green:0.20 blue:0.15 alpha:1.0]}
                                  };
    
    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationGrowthBackAll | VBPieChartAnimationTimingEaseInOut];
}

- (IBAction)setanother4:(id)sender {
    NSDictionary *chartValues = @{
                                  @"first": @{@"value":@50, @"color":[UIColor colorWithRed:0.55 green:0.77 blue:0.53 alpha:1.0]},
                                  @"second": @{@"value":@20, @"color":[UIColor colorWithRed:0.33 green:0.17 blue:0.48 alpha:1.0]},
                                  @"third": @{@"value":@40, @"color":[UIColor colorWithRed:0.81 green:0.61 blue:0.02 alpha:1.0]},
                                  @"fourth": @{@"value":@10, @"color":[UIColor colorWithRed:0.31 green:0.74 blue:0.91 alpha:1.0]},
                                  @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithRed:0.43 green:0.02 blue:0.46 alpha:1.0]},
                                  @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithRed:0.00 green:0.51 blue:0.08 alpha:1.0]},
                                  @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithRed:0.84 green:0.66 blue:0.81 alpha:1.0]},
                                  @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithRed:0.73 green:0.20 blue:0.63 alpha:1.0]},
                                  @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithRed:0.83 green:0.20 blue:0.15 alpha:1.0]}
                                  };
    
    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationGrowthBack];
}


- (IBAction)setanother2:(id)sender {
    NSDictionary *chartValues = @{
                                  @"first": @{@"value":@50, @"color":[UIColor colorWithRed:0.55 green:0.77 blue:0.53 alpha:1.0]},
                                  @"second": @{@"value":@20, @"color":[UIColor colorWithRed:0.33 green:0.17 blue:0.48 alpha:1.0]},
                                  @"third": @{@"value":@40, @"color":[UIColor colorWithRed:0.81 green:0.61 blue:0.02 alpha:1.0]},
                                  @"fourth": @{@"value":@10, @"color":[UIColor colorWithRed:0.31 green:0.74 blue:0.91 alpha:1.0]},
                                  @"fourth 2": @{@"value":@70, @"color":[UIColor colorWithRed:0.43 green:0.02 blue:0.46 alpha:1.0]},
                                  @"fourth 3": @{@"value":@65, @"color":[UIColor colorWithRed:0.00 green:0.51 blue:0.08 alpha:1.0]},
                                  @"fourth 4": @{@"value":@23, @"color":[UIColor colorWithRed:0.84 green:0.66 blue:0.81 alpha:1.0]},
                                  @"fourth 5": @{@"value":@34, @"color":[UIColor colorWithRed:0.73 green:0.20 blue:0.63 alpha:1.0]},
                                  @"fourth 6": @{@"value":@54, @"color":[UIColor colorWithRed:0.83 green:0.20 blue:0.15 alpha:1.0]}
                                  };
    
    [_chart setChartValues:chartValues animation:YES options:VBPieChartAnimationFan];
}


- (IBAction) changeLenght:(id)sender {
    if (_chart.length < M_PI*2-0.01) {
        _chart.length = M_PI*2;
        _chart.startAngle = 0;
    } else {
        _chart.length = M_PI;
        _chart.startAngle = M_PI;
    }
}


//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *t = [[touches allObjects] lastObject];
//    CGPoint p1 = [t previousLocationInView:self.view];
//    CGPoint p2 = [t locationInView:self.view];
//    
//    CGPoint delta;
//    delta.x = p1.x - p2.x;
//    delta.y = p1.y - p2.y;
//    
//    _chart.layer.transform = CATransform3DRotate(_chart.layer.transform, delta.y * M_PI / 180.0f, 1, 0, 0);
////    self.layer.transform = CATransform3DRotate(self.layer2.transform, delta.y * M_PI / 180.0f, 1, 0, 0);
//
//    _chart.layer.transform = CATransform3DRotate(_chart.layer.transform, delta.x * M_PI / 180.0f, 0, -1, 0);
////    self.layer2.transform = CATransform3DRotate(self.layer2.transform, delta.x * M_PI / 180.0f, 0, -1, 0);
//
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
