//
//  VBPieChart.m
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import "VBPieChart.h"
#import "VBPiePiece.h"

static __inline__ CGFloat CGPointDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    
    return sqrt(dx*dx + dy*dy );
}

@interface VBPiePieceData : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *labelColor;
@property (nonatomic) BOOL accent;
@end
@implementation VBPiePieceData
@end


@interface VBPieChart () {
    CGPoint moveP;
}
@property (nonatomic, retain) NSMutableArray *chartsData;
@property (nonatomic) float radius;
@property (nonatomic) float holeRadius;
@property (nonatomic, assign) VBPiePiece *hitLayer;

@property (nonatomic) BOOL presentWithAnimation;
@property (nonatomic) VBPieChartAnimationOptions animationOptions;
@property (nonatomic) float animationDuration;

@end

@interface VBPiePiece ()
- (void) _animate;
- (void) setAnimationOptions:(VBPieChartAnimationOptions)options;
- (void) setAnimationDuration:(float)duration;

- (void) setLabelsPosition:(VBLabelsPosition)labelsPosition;
- (void) setLabelBlock:(VBLabelBlock)labelBlock;
- (void) setLabelColor:(UIColor *)labelColor;

@property (nonatomic, copy) void (^endAnimationBlock)(void);
@end


@implementation VBPieChart {
    CGPoint _touchBegan;
}

- (id) init {
    self = [super init];
    self.chartsData = [NSMutableArray array];
    self.strokeColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7];
    
    self.startAngle = 0;
    self.length = M_PI*2;
    self.radiusPrecent = 0.9;
    self.holeRadius = 0;
    self.holeRadiusPrecent = 0.2;
    self.maxAccentPrecent = 0.25;
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

- (void) setLabelsPosition:(VBLabelsPosition)labelsPosition {
    _labelsPosition = labelsPosition;
    [self updateCharts];
}


- (UIColor*) defaultColors:(NSInteger)index {
    
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
            return [UIColor colorWithRed:0.31+deltaRed green:0.74+deltaGreen blue:0.91+deltaBlue alpha:alpha];
        case 1:
            return [UIColor colorWithRed:0.33+deltaRed green:0.17+deltaGreen blue:0.48+deltaBlue alpha:alpha];
        case 2:
            return [UIColor colorWithRed:0.81+deltaRed green:0.61+deltaGreen blue:0.02+deltaBlue alpha:alpha];
        case 3:
            return [UIColor colorWithRed:0.43+deltaRed green:0.02+deltaGreen blue:0.46+deltaBlue alpha:alpha];
        case 4:
            return [UIColor colorWithRed:0.55+deltaRed green:0.77+deltaGreen blue:0.53+deltaBlue alpha:alpha];
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

    if (!_chartValues) {
        return;
    }
    
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
    for (NSDictionary *object in _chartValues) {
        
        VBPiePieceData *data;
        BOOL created = NO;
        if ([_chartsData count] > index) {
            data = [_chartsData objectAtIndex:index];
        } else {
            data = [[VBPiePieceData alloc] init];
            created = YES;
        }
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)object;
            data.name = [dict objectForKey:@"name"];
            data.value = [dict objectForKey:@"value"];
            if (![dict objectForKey:@"color"]) {
                data.color = [self defaultColors:index];
            } else {
                data.color = [dict objectForKey:@"color"];
            }
            
            if (![dict objectForKey:@"labelColor"]) {
                data.labelColor = [UIColor whiteColor];
            } else {
                data.labelColor = [dict objectForKey:@"labelColor"];
            }
            
            data.accent = [[dict objectForKey:@"accent"] boolValue];
        } else {
            data.value = (NSNumber*)object;
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
    
    CGFloat onePrecent = fullValue*0.01;
    CGFloat onePrecentOfChart = _length*0.01;
    CGFloat start = _startAngle;

    for (VBPiePieceData *data in _chartsData) {
        
        CGFloat pieceValuePrecents = fabs([data.value doubleValue])/onePrecent;
        CGFloat pieceChartValue = onePrecentOfChart*pieceValuePrecents;
        
        if (pieceChartValue == 0) {
            continue;
        }
        
        VBPiePiece *piece = [[VBPiePiece alloc] init];
        [piece setFrame:rect];
        if (data.accent) {
            [piece setAccentPrecent:0.1];
        }
        
        [piece setLabelsPosition:_labelsPosition];
        [piece setLabelBlock:_labelBlock];
        [piece setLabelColor:data.labelColor];
        [piece setValue:pieceValuePrecents];
        [piece setPieceName:data.name];
        
        [piece setInnerRadius:_radius];
        [piece setOuterRadius:_holeRadius];
        piece.fillColor = data.color.CGColor;
        
        if (_enableStrokeColor) {
            piece.strokeColor = _strokeColor.CGColor;
        }
        
        [piece pieceAngle:pieceChartValue start:start];
        
        if (_presentWithAnimation) {
            [piece setHidden:YES];
        }
        [piece setAnimationDuration:_animationDuration];
        [piece setAnimationOptions:_animationOptions];
        
        [self.layer addSublayer:piece];
        
        start += pieceChartValue;
    }
    
    // if was selected present with animation
    if (_presentWithAnimation) {
        
        if (_animationOptions & VBPieChartAnimationGrowthAll || _animationOptions & VBPieChartAnimationGrowthBackAll || _animationOptions & VBPieChartAnimationFan) {
            
            for (NSInteger i = 0, len = [self.layer sublayers].count; i < len; i++) {
                VBPiePiece *piece = [[self.layer sublayers] objectAtIndex:i];
                [piece _animate];
            }
            
        } else {
            
            for (NSInteger i = 0, len = [self.layer sublayers].count; i < len; i++) {
                VBPiePiece *piece = [[self.layer sublayers] objectAtIndex:i];
                if (i+1 < len) {
                    __block VBPiePiece *blockPiece = [[self.layer sublayers] objectAtIndex:i+1];
                    [piece setEndAnimationBlock:^{
                        [blockPiece _animate];
                    }];
                }
            }
            
            VBPiePiece *piece = [[self.layer sublayers] objectAtIndex:0];
            [piece _animate];
        }
        
        _presentWithAnimation = NO;
    }
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation {
    [self setChartValues:chartValues animation:animation options:(VBPieChartAnimationFanAll | VBPieChartAnimationTimingLinear)];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(VBPieChartAnimationOptions)options {
    [self setChartValues:chartValues animation:animation duration:0.7 options:options];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(VBPieChartAnimationOptions)options {
    _presentWithAnimation = animation;
    _animationOptions = options;
    _animationDuration = duration;
    self.chartValues = chartValues;
}


- (CALayer *)layerForTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:[touch view]];
    
    for (CALayer *l in self.layer.sublayers) {
        if ([l containsPoint:location]) {
            return l;
        }
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    _touchBegan = [touch locationInView:self];
    _hitLayer = (VBPiePiece*)[self layerForTouch:touch];
    
    moveP = CGPointMake(1, 1);
    CGPoint p = [touch locationInView:self];
    if (p.y > self.center.y && p.x > self.center.x) {
        moveP.y = -1;
    }
    if (p.y > self.center.y && p.x < self.center.x) {
        moveP.y = -1;
        moveP.x = -1;
    }
    if (p.y < self.center.y && p.x < self.center.x) {
        moveP.y = 1;
        moveP.x = -1;
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint p1 = [touch previousLocationInView:self];
    CGPoint p2 = [touch locationInView:self];
    CGPoint delta;
    delta.x = (p1.x - p2.x)*moveP.x;
    delta.y = (p1.y - p2.y)*moveP.y;
    
    if (_enableInteractive) {
        self.layer.transform = CATransform3DRotate(self.layer.transform, delta.y * M_PI / 180.0f, 1, 0, 0);
        self.layer.transform = CATransform3DRotate(self.layer.transform, delta.x * M_PI / 180.0f, 0, -1, 0);
    }
    
    if ([_hitLayer isKindOfClass:[VBPiePiece class]]) {
        float d = _hitLayer.accentPrecent+((-delta.x+delta.y)/2/_radius);
        d = MAX(0, d);
        d = MIN(d, _maxAccentPrecent);

        [_hitLayer setAccentPrecent:d];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGPointDistanceBetweenTwoPoints(point, _touchBegan) < 5) {
        _hitLayer = (VBPiePiece*)[self layerForTouch:touch];
        
        if (_hitLayer.accentPrecent < FLT_EPSILON) {
            [_hitLayer animateToAccent:_maxAccentPrecent];
        } else {
            [_hitLayer animateToAccent:0];
        }
    }
}

@end
