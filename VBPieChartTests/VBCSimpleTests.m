//
//  VBCSimpleTests.m
//  VBPieChart
//
//  Created by Volodymyr Boichentsov on 18/01/2016.
//  Copyright © 2016 SAKrisT. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VBPieChart.h"

@interface VBCSimpleTests : XCTestCase {
    VBPieChart *_chart;
    NSArray *chartValues;
    
    UIView *view;
}
@end

@implementation VBCSimpleTests

- (void)setUp {
    [super setUp];
    
    view = [[[UIApplication sharedApplication] keyWindow].subviews lastObject];
    
    if (!_chart) {
        _chart = [[VBPieChart alloc] init];
        [view addSubview:_chart];
    }
    [_chart setFrame:CGRectMake(10, 50, 300, 300)];
    [_chart setHoleRadiusPrecent:0.3];
    _chart.startAngle = M_PI+M_PI_2;
    
    [_chart setHoleRadiusPrecent:0.3];
    
    [_chart setLabelsPosition:VBLabelsPositionOnChart];
    
    
    chartValues = @[
                         @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
                         @{@"name":@"sec", @"value":@20, @"color":[UIColor greenColor]},
                         @{@"name":@"third", @"value":@40, @"color":[UIColor orangeColor]},
                         @{@"name":@"fourth", @"value":@70, @"color":[UIColor groupTableViewBackgroundColor]},
                         @{@"value":@65, @"color":[UIColor scrollViewTexturedBackgroundColor]},
                         @{@"value":@23, @"color":[UIColor whiteColor]},
                         @{@"value":@34, @"color":[UIColor purpleColor]},
                         @{@"name":@"stroke", @"value":@54, @"color":[UIColor yellowColor], @"strokeColor":[UIColor whiteColor]}
                         ];
    
    [_chart setChartValues:chartValues];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testEmptyArrayAndAnimated {
    [_chart setChartValues:chartValues animation:YES];
    [_chart setChartValues:@[] animation:YES];
}


- (void) testEmptyArrayAndAnimatedOptions {
    [_chart setChartValues:chartValues animation:YES];
    [_chart setChartValues:@[] animation:YES duration:.6 options:0];
}

- (void) testEmptyArray {
    [_chart setChartValues:chartValues animation:YES];
    [_chart setChartValues:@[]];
}

- (void) testRemoveAtIndexAndExceptionTest {
    [_chart setChartValues:chartValues animation:NO];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    [_chart removePieceAtIndex:0];
    XCTAssertThrowsSpecific([_chart removePieceAtIndex:0], NSException);
    [CATransaction commit];
}


- (void) testSetValueAtIndex {
    [_chart setChartValues:chartValues animation:NO];
    
    [_chart setValue:@"sss" pieceAtIndex:3]; // test for wrong

    XCTAssertThrowsSpecific([_chart setValue:@{} pieceAtIndex:3], NSException); // test for wrong

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_chart setValue:@50 pieceAtIndex:3];
    [CATransaction commit];
}



- (void) testSetValues {
    [_chart setChartValues:chartValues animation:NO];
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    NSDictionary *dict = @{@"ss":@"", @{}:@{}};

    XCTAssertThrowsSpecific([_chart setValues:dict], NSException); // wrong

    [_chart setValues:@{@1:@50,
                        @2:@100}]; // correct
    
    XCTAssertThrowsSpecific([_chart setValues:@{@200:@100}], NSException); // wrong, because we have only chartValues.count, no pieces with index 200
    
    
    [CATransaction commit];
}



@end
