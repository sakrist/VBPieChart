//
//  VBPieChart.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, VBPieChartAnimationOptions) {
    VBPieChartAnimationFanAll                     = 1 <<  0,
    VBPieChartAnimationGrowth                     = 1 <<  1,
    VBPieChartAnimationGrowthAll                  = 1 <<  2,
    VBPieChartAnimationGrowthBack                 = 1 <<  3,
    VBPieChartAnimationGrowthBackAll              = 1 <<  4,
    VBPieChartAnimationFan                        = 1 <<  5,
    
    VBPieChartAnimationTimingEaseInOut            = 1 << 16,
    VBPieChartAnimationTimingEaseIn               = 2 << 16,
    VBPieChartAnimationTimingEaseOut              = 3 << 16,
    VBPieChartAnimationTimingLinear               = 4 << 16,
    
    
    VBPieChartAnimationDefault = VBPieChartAnimationFanAll | VBPieChartAnimationTimingLinear, // Default
};
    
typedef NS_ENUM(NSUInteger, VBLabelsPosition) {
    VBLabelsPositionNone        = 0, // default is no labels
    VBLabelsPositionOnChart     = 1,
    VBLabelsPositionOutChart    = 2,
    VBLabelsPositionCustom      = 3,
};
    

/*!
 @abstract
 @return return CGPoint, center for label
 */
typedef CGPoint (^VBLabelBlock)(CALayer*layer, NSInteger index);


/*!
 @abstract Animatable Pie Chart control. Have abilities insert and delete values with animation.
 
 Example for simple start:
 @code
 _chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
 [self.view addSubview:_chart];
 _chart.holeRadiusPrecent = 0.2;
 _chart.startAngle = M_PI+M_PI_2;
 [_chart setChartValues:@[
     @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
     @{@"name":@"second", @"value":@20, @"color":[UIColor blueColor]},
     @{@"name":@"third", @"value":@40, @"color":[UIColor purpleColor]}]
              animation:YES];
 @endcode
 */
@interface VBPieChart : UIView

/*!
 @abstract Option to specify position of labels on the chart.
 @note Default VBLabelsPositionNone
 */
@property (nonatomic) VBLabelsPosition labelsPosition;

/*!
 @abstract Block for recalcute center of label's position.
 @note Executes only if labelsPosition = VBLabelsPositionCustom;
*/
@property (nonatomic, copy)  VBLabelBlock labelBlock;

/*!
 @abstract Hole in center of diagram, precent of radius
 @note Default is 0.2, from 0 to 1
 */
@property (nonatomic) double holeRadiusPrecent;

/*!
 @abstract Radius of diagram dependce to view size
 @note Default is 0.9, possible value from 0 to 1.
*/
@property (nonatomic) double radiusPrecent;

/*!
 @abstract Default is 0.25, i.e. 25% of radius.
 */
@property (nonatomic) double maxAccentPrecent;

/*!
 @abstract Length of circle, from 0 to M_PI*2.
 @note Default M_PI*2.
 */
@property (nonatomic) double length;

/*!
 @abstract Start angle, from 0 to M_PI*2
 @note Default 0.
 */
@property (nonatomic) double startAngle;


/*!
 @abstract Set new value by index for already exist piece. Animated.
 @param value NSNumber new value for piece at index
 @param index NSInteger index of piece
 @note To disable animation use CATransaction, example:
@code
 [CATransaction begin];
 [CATransaction setDisableActions:YES];
 [chart setValue:@50 pieceAtIndex:1];
 [CATransaction commit];
@endcode
 In example set 50 pieces at index 1.
 */
- (void) setValue:(NSNumber*)value pieceAtIndex:(NSInteger)index;


/*!
 @abstract Remove piece at index. Animated.
 @param index NSInteger index of piece which needs to be remove
 */
- (void) removePieceAtIndex:(NSInteger)index;

/*!
 @abstract Insert new piece at index. Animated.
 @param chartValue NSDictionary new item with properties, similar as to initialise one.
 @param index NSInteger insert index for new piece
 @code
 [chart insertChartValue:@{@"name":@"new item", @"value":@30} atIndex:1];
 @endcode
 */
- (void) insertChartValue:(NSDictionary*)chartValue atIndex:(NSInteger)index;


/*!
 @abstract Method to get all chart values back. Will return the same values as was setuped in case no changes.
 If any methods for modifying was applied, then chrat values will be modified too.
 @return chartValue NSArray chart values
 */
- (NSArray *) chartValues;


/*!
 @abstract Method to setup chart values without animation.
 @param chartValues NSArray main data for chart pie
 @code
 [chart setChartValues:@[
    @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
    @{@"name":@"second", @"value":@20, @"color":[UIColor blueColor]},
    @{@"name":@"third", @"value":@40, @"color":[UIColor purpleColor]},
 ]];
 @endcode
 */
- (void) setChartValues:(NSArray *)chartValues;


/*!
 @abstract Setup chart values with animation options.
 @param chartValues NSArray main data for chart pie
 @param animation BOOL flag present with animation
 @code
 [_chart setChartValues:@[
     @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
     @{@"name":@"second", @"value":@20, @"color":[UIColor blueColor]},
     @{@"name":@"third", @"value":@40, @"color":[UIColor purpleColor]},
 ]
             animation:YES];
 @endcode
 */
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation;

/*!
 @abstract Setup chart values with animation options.
 @param chartValues NSArray main data for chart pie
 @param animation BOOL flag present with animation
 @param options Options for animation.
 @code
 [_chart setChartValues:@[
     @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
     @{@"name":@"second", @"value":@20, @"color":[UIColor blueColor]},
     @{@"name":@"third", @"value":@40, @"color":[UIColor purpleColor]},
 ]
             animation:YES
             options:VBPieChartAnimationDefault];
 @endcode
 */
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(VBPieChartAnimationOptions)options;

/*!
 @abstract Setup chart values with animation options.
 @param chartValues NSArray main data for chart pie
 @param animation BOOL flag present with animation
 @param duration double Duration of animation.
 @param options Options for animation.
 @code
 [_chart setChartValues:@[
     @{@"name":@"first", @"value":@50, @"color":[UIColor redColor]},
     @{@"name":@"second", @"value":@20, @"color":[UIColor blueColor]},
     @{@"name":@"third", @"value":@40, @"color":[UIColor purpleColor]},
 ]
             animation:YES
             duration:0.5
             options:VBPieChartAnimationDefault];
 @endcode
 */
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(double)duration options:(VBPieChartAnimationOptions)options;

@end


@interface VBPieChart (_deprecated)
// to enbale interaction with chart. Deprecated because useless and can be done in another way.
@property (nonatomic) BOOL enableInteractive DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) UIColor *strokeColor DEPRECATED_MSG_ATTRIBUTE("Use strokeColor parameter for value");
@property (nonatomic) BOOL enableStrokeColor DEPRECATED_MSG_ATTRIBUTE("Use strokeColor parameter for value");
@end

