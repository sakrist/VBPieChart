//
//  VBPieChart.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, VBPieChartAnimationOptions) {
    VBPieChartAnimationFanAll                     = 1 <<  0, // default
    VBPieChartAnimationGrowth                     = 1 <<  1,
    VBPieChartAnimationGrowthAll                  = 1 <<  2,
    VBPieChartAnimationGrowthBack                 = 1 <<  3,
    VBPieChartAnimationGrowthBackAll              = 1 <<  4,
    VBPieChartAnimationFan                        = 1 <<  5,
    
    VBPieChartAnimationTimingEaseInOut            = 1 << 16,
    VBPieChartAnimationTimingEaseIn               = 2 << 16,
    VBPieChartAnimationTimingEaseOut              = 3 << 16,
    VBPieChartAnimationTimingLinear               = 4 << 16, // default
};
    
typedef NS_ENUM(NSUInteger, VBLabelsPosition) {
    VBLabelsPositionNone        = 0, // default is no labels
    VBLabelsPositionOnChart     = 1,
    VBLabelsPositionOutChart    = 2,
    VBLabelsPositionCustom      = 3,
};
    
// returns center for label
typedef CGPoint (^VBLabelBlock)(CALayer*layer);

@interface VBPieChart : UIView

@property (nonatomic, strong) NSArray *chartValues;

@property (nonatomic, strong) UIColor *strokeColor;

// Default is NO
@property (nonatomic) BOOL enableStrokeColor;

// Default is NO
@property (nonatomic) BOOL enableInteractive;

// Default VBLabelsPositionNone
@property (nonatomic) VBLabelsPosition labelsPosition;

// for VBLabelsPositionCustom
@property (nonatomic, copy)  VBLabelBlock labelBlock;


// Hole in center of diagram, precent of radius
// Default is 0.2, from 0 to 1
@property (nonatomic) float holeRadiusPrecent;

// Radius of diagram dependce to view size
// Default is 0.9, possible value from 0 to 1.
@property (nonatomic) float radiusPrecent;

// Default is 0.25, optimal
@property (nonatomic) float maxAccentPrecent;

// Length of circle, from 0 to M_PI*2
// Default M_PI*2.
@property (nonatomic) float length;

// Start angle
@property (nonatomic) float startAngle;

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation;

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(VBPieChartAnimationOptions)options;

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(VBPieChartAnimationOptions)options;

@end
