//
//  VBPiePiece.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface VBPiePiece : CAShapeLayer

@property (nonatomic) float innerRadius;
@property (nonatomic) float outerRadius;

@property (nonatomic) double value;
@property (nonatomic, strong) NSString *pieceName;

/*
 Actual angle of segment
 */
@property (nonatomic, readonly) float angle;

/*
 Start angle for segment
 */
@property (nonatomic, readonly) float startAngle;

// Default is NO
@property (nonatomic, readonly) BOOL accent;

@property (nonatomic, readonly) CGPoint accentVector;

// Default is 0.1 (i.e. 10%) of innerRadius
@property (nonatomic) float accentPrecent;

// Value in range 0..1
- (BOOL) animateToAccent:(float)accentPrecent;


// Values in radians
- (void) pieceAngle:(float)angle start:(float)startAngle;


@end
