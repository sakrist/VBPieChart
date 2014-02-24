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
@property (nonatomic) BOOL accent;

- (void) pieceAngle:(float)angle start:(float)startAngle;


@end
