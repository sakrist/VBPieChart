//
//  VBPieChart.m
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import "VBPieChart.h"
#import "VBPiePiece.h"

@interface VBPiePieceData : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) BOOL accent;
@end
@implementation VBPiePieceData
@end


@interface VBPieChart ()
@property (nonatomic, retain) NSMutableArray *chartsData;
@property (nonatomic) float radius;
@property (nonatomic) float holeRadius;
@end


@implementation VBPieChart

- (id) init {
    self = [super init];
    self.chartsData = [NSMutableArray array];
    self.strokeColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7];
    self.holeRadius = 0;
    self.holeRadiusPrecent = 0.2;
    self.radiusPrecent = 0.9;
    self.enableStrokeColor = NO;
    [self addObserver:self
           forKeyPath:@"chartValues"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self
           forKeyPath:@"enableStrokeColor"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self
           forKeyPath:@"holeRadiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self
           forKeyPath:@"radiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    return self;
}

- (void) dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"chartValues"];
        [self removeObserver:self forKeyPath:@"enableStrokeColor"];
        [self removeObserver:self forKeyPath:@"holeRadiusPrecent"];
        [self removeObserver:self forKeyPath:@"radiusPrecent"];
    } @catch (NSException * __unused exception) {}
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"chartValues"] || [keyPath isEqualToString:@"enableStrokeColor"]) {
        [self updateCharts];
    }
    if([keyPath isEqualToString:@"holeRadiusPrecent"] || [keyPath isEqualToString:@"radiusPrecent"]) {
        [self setFrame:self.frame];
    }
}


- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.radius = frame.size.width/2*_radiusPrecent;
    self.holeRadius = _radius*_holeRadiusPrecent;
    [self updateCharts];
}

- (UIColor*) defaultColors:(int)index {
    
    // It's better then just a random

    float deltaRed = 0;
    float deltaGreen = 0;
    float deltaBlue = 0;
    float alpha = 1;
    
    if (index > 7) {
        deltaRed = (arc4random() % 500)/2555.0f;
        deltaGreen = (arc4random() % 500)/2555.0f;
        deltaBlue = (arc4random() % 500)/2555.0f;
        index = index % 8;
    }
    
    switch (index) {
        case 0:
            return [UIColor colorWithRed:0.55+deltaRed green:0.77+deltaGreen blue:0.53+deltaBlue alpha:alpha];
        case 1:
            return [UIColor colorWithRed:0.33+deltaRed green:0.17+deltaGreen blue:0.48+deltaBlue alpha:alpha];
        case 2:
            return [UIColor colorWithRed:0.81+deltaRed green:0.61+deltaGreen blue:0.02+deltaBlue alpha:alpha];
        case 3:
            return [UIColor colorWithRed:0.31+deltaRed green:0.74+deltaGreen blue:0.91+deltaBlue alpha:alpha];
        case 4:
            return [UIColor colorWithRed:0.43+deltaRed green:0.02+deltaGreen blue:0.46+deltaBlue alpha:alpha];
        case 5:
            return [UIColor colorWithRed:0.00+deltaRed green:0.51+deltaGreen blue:0.08+deltaBlue alpha:alpha];
        case 6:
            return [UIColor colorWithRed:0.84+deltaRed green:0.66+deltaGreen blue:0.81+deltaBlue alpha:alpha];
        case 7:
            return [UIColor colorWithRed:0.73+deltaRed green:0.20+deltaGreen blue:0.63+deltaBlue alpha:alpha];
            
        default:
            return [UIColor colorWithRed:(arc4random() % 255)/255.0f green:(arc4random() % 255)/255.0f blue:(arc4random() % 255)/255.0f alpha:alpha];
    }
}

- (void) updateCharts {

    // Clean old layers
    NSArray *arraySublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *l in arraySublayers) {
        [l removeFromSuperlayer];
    }
    arraySublayers = nil;
    
    // init temp variables
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    double fullValue = 0;
    
    NSUInteger index = 0;
    for (NSString *key in _chartValues) {
        id object = [_chartValues objectForKey:key];
        
        VBPiePieceData *data;
        BOOL created = NO;
        if ([_chartsData count] > index) {
            data = [_chartsData objectAtIndex:index];
        } else {
            data = [[VBPiePieceData alloc] init];
            created = YES;
        }
        data.name = key;
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)object;
            data.value = [dict objectForKey:@"value"];
            if (![dict objectForKey:@"color"]) {
                data.color = [self defaultColors:index];
            } else {
                data.color = [dict objectForKey:@"color"];
            }
            data.accent = [[dict objectForKey:@"accent"] boolValue];
        } else {
            data.value = object;
            if (created) {
                data.color = [self defaultColors:index];
            }
        }
        
        if (created) {
            [_chartsData addObject:data];
        }
        
        fullValue += fabsf([data.value floatValue]);
        index++;
    }
    
    double onePrecent = fullValue*0.01;
    double onePrecentOfChart = M_PI*2*0.01;
    double start = 0;
    
    for (VBPiePieceData *data in _chartsData) {
        
        double pieceValuePrecents = fabsf([data.value floatValue])/onePrecent;
        double pieceChartValue = onePrecentOfChart*pieceValuePrecents;
        
        if (pieceChartValue == 0) {
            continue;
        }
        
        VBPiePiece *piece = [[VBPiePiece alloc] init];
        [piece setFrame:rect];
        [piece setAccent:data.accent];
        [piece setInnerRadius:_radius];
        [piece setOuterRadius:_holeRadius];
        piece.fillColor = data.color.CGColor;
        
        if (_enableStrokeColor) {
            piece.strokeColor = _strokeColor.CGColor;
        }
        
        [piece pieceAngle:pieceChartValue start:start];
        [self.layer addSublayer:piece];
        
        start += pieceChartValue;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_enableInteractive) {
        UITouch *t = [[touches allObjects] lastObject];
        CGPoint p1 = [t previousLocationInView:self];
        CGPoint p2 = [t locationInView:self];
        
        CGPoint delta;
        delta.x = p1.x - p2.x;
        delta.y = p1.y - p2.y;
        
        self.layer.transform = CATransform3DRotate(self.layer.transform, delta.y * M_PI / 180.0f, 1, 0, 0);
        self.layer.transform = CATransform3DRotate(self.layer.transform, delta.x * M_PI / 180.0f, 0, -1, 0);
    }
}


@end
