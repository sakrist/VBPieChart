//
//  VBPiePiece.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/*!
 Structure that represent one piece of Pie Chart.
 */
@interface VBPiePiece : CAShapeLayer {
    @package
    double _innerRadius;
    double _outerRadius;
}

/*!
 Radius of pie chart.
 */
@property (nonatomic, readonly) double innerRadius;

/*!
 Radius of hole in pie chart.
 */
@property (nonatomic, readonly) double outerRadius;

/*!
 Name will be set from chartValues of VBPieChart instance or value of current instance.
 */
@property (nonatomic, strong) NSString *pieceName;

/*!
 Start angle for segment
 */
@property (nonatomic, readonly) double startAngle;

/*!
 Actual angle of segment
 */
@property (nonatomic, readonly) double angle;

/*!
 Flag that say if piece can be selected.
 Default is NO
 */
@property (nonatomic, readonly) BOOL accent;

/*!
 Vector of accent, used in case user touched piece
 */
@property (nonatomic, readonly) CGPoint accentVector;

// Default is 0.1 (i.e. 10%) of innerRadius
@property (nonatomic, readonly) double accentPrecent;

/*!
 Can be overwritten to present another type of chart
 */
- (CGMutablePathRef) generatePath;

@end
