//
//  VBPieChart.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBPieChart : UIView

@property (nonatomic, strong) NSDictionary *chartValues;

@property (nonatomic, strong) UIColor *strokeColor;

// Default is NO
@property (nonatomic) BOOL enableStrokeColor;

// Default is NO
@property (nonatomic) BOOL enableInteractive;

// Hole in center of diagram, precent of radius
// Default is 0.2, from 0 to 1
@property (nonatomic) float holeRadiusPrecent;


// Radius of diagram dependce to view size
// Default is 0.9, possible value from 0 to 1.
@property (nonatomic) float radiusPrecent;


@end
