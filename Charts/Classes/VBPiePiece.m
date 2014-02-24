//
//  VBPiePiece.m
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import "VBPiePiece.h"

@implementation VBPiePiece


- (void) pieceAngle:(float)angle start:(float)startAngle; {
    
    
    CGSize size = self.frame.size;
    
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    if (_innerRadius == 0) {
        _innerRadius = size.width/2;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGAffineTransform matrix = CGAffineTransformIdentity;
    if (_accent) {
        
        float calcAngle = angle+ (M_PI*2-startAngle-angle);
        BOOL mod = YES;
        if (calcAngle > M_PI) {
            mod = NO;
            calcAngle = -((M_PI*2)-calcAngle);
        }
        
        float x = center.x + _innerRadius*cos(calcAngle/2);
        float y = center.y + _innerRadius*sin(calcAngle/2);
        
        CGPoint vector = CGPointMake(center.x-x, center.y-y);
        
        vector.x = ((mod)? fabsf(vector.x):vector.x) /_innerRadius;
        vector.y = -((mod)? fabsf(vector.y):vector.y) /_innerRadius;
        float delta = _innerRadius*.1;
        
        matrix = CGAffineTransformMakeTranslation(center.x, center.y);
        matrix = CGAffineTransformTranslate(matrix, vector.x*delta, vector.y*delta);
        matrix = CGAffineTransformTranslate(matrix,-center.x,-center.x);

        CALayer *layer = [CALayer layer];
        [layer setFrame:CGRectMake(x, y, 2, 2)];
        layer.backgroundColor = [UIColor redColor].CGColor;
        [self addSublayer:layer];
        
    }
    
    if (startAngle > -.01 && angle > -.01) {
        CGPathAddRelativeArc(path, &matrix, center.x, center.y, _innerRadius, startAngle, angle);
        CGPathAddRelativeArc(path, &matrix, center.x, center.y, _outerRadius, startAngle+angle , -angle);
        CGPathCloseSubpath(path);
    }
    
    self.path = path;
    CGPathRelease(path);
}

@end
