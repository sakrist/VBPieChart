//
//  VBPieChart.m
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import "VBPieChart.h"
#import "VBPiePiece.h"
#import "VBPiePiece_private.h"

static __inline__ CGFloat CGPointDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    
    return sqrt(dx*dx + dy*dy );
}


@interface VBPieChart () {
    CGPoint moveP;
    __strong NSMutableArray *_chartValues;
}
@property (nonatomic, strong) NSMutableArray *chartsData;
@property (nonatomic) double radius;
@property (nonatomic) double holeRadius;
@property (nonatomic, weak) VBPiePiece *hitLayer;

@property (nonatomic) BOOL presentWithAnimation;
@property (nonatomic) VBPieChartAnimationOptions animationOptions;
@property (nonatomic) double animationDuration;

@property (nonatomic, strong) NSMutableArray *pieceArray;

@end

@interface VBPiePiece ()

// setup piece Angle (then will be calcuated length) and Start Angle.
- (void) pieceAngle:(double)angle start:(double)startAngle;

// animate to accent position
- (BOOL) animateToAccent:(double)accentPrecent;

// animations methods
- (void) _animateToAngle:(double)angle startAngle:(double)startAngle;
- (void) _animate;
- (void) setAnimationOptions:(VBPieChartAnimationOptions)options;
- (void) setAnimationDuration:(double)duration;

// labels control methods
- (void) setLabelsPosition:(VBLabelsPosition)labelsPosition;
- (void) setLabelBlock:(VBLabelBlock)labelBlock;
- (void) setLabelColor:(UIColor *)labelColor;
- (void) removeLable;

- (void) setData:(VBPiePieceData*)data;

@property (nonatomic, copy) void (^endAnimationBlock)(void);
@end


@implementation VBPieChart {
    CGPoint _touchBegan;
}

- (id) init {
    self = [super init];
    [self configure];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self configure];
    return self;
}

- (void)configure {
    self.chartsData = [NSMutableArray array];
    
    self.startAngle = 0;
    self.length = M_PI*2;
    self.radiusPrecent = 0.9;
    self.holeRadius = 0;
    self.holeRadiusPrecent = 0.2;
    self.maxAccentPrecent = 0.25;
    
    [self addObserver:self
           forKeyPath:@"holeRadiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self
           forKeyPath:@"radiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
}

- (void) dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"holeRadiusPrecent"];
        [self removeObserver:self forKeyPath:@"radiusPrecent"];
    } @catch (NSException * __unused exception) {}
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"holeRadiusPrecent"] || [keyPath isEqualToString:@"radiusPrecent"]) {
        [self setFrame:self.frame];
    }
}


- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.radius = frame.size.width/2*_radiusPrecent;
    self.holeRadius = _radius*_holeRadiusPrecent;
    [self _updateCharts];
}

- (void) setLabelsPosition:(VBLabelsPosition)labelsPosition {
    _labelsPosition = labelsPosition;
    [self _updateCharts];
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

- (void) setValues:(NSDictionary*)values {
    if (![values isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"VBPieChartException" format:@"values needs to be specified with NSDictionary"];
    }
    for (NSNumber *key in [values allKeys]) {
        NSInteger index = [key intValue];
        VBPiePieceData *data = _chartsData[index];
        data.value = values[key];
        _chartValues[index][@"value"] = values[key];
    }
    [self _refreshCharts];
}

- (void) setValue:(NSNumber*)value pieceAtIndex:(NSInteger)index {
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:@"VBPieChartException" format:@"value needs to be NSNumber"];
    }
    VBPiePieceData *data = _chartsData[index];
    data.value = value;
    _chartValues[index][@"value"] = value;
    [self _refreshCharts];
}


- (void) removePieceAtIndex:(NSInteger)index {
    VBPiePiece *piece = (VBPiePiece *)_pieceArray[index];
    [piece removeLable];
    
    VBPiePieceData *data = _chartsData[index];
    data.value = @(0);
    [self _refreshCharts];
    
    void (^completionBlock)(void)  = ^(void){
        [_chartValues removeObjectAtIndex:index];
        [_chartsData removeObjectAtIndex:index];
        [piece removeFromSuperlayer];
        [_pieceArray removeObjectAtIndex:index];
        
        for (NSInteger i = index; i < _chartsData.count; i++) {
            VBPiePieceData *data = _chartsData[i];
            data.index = i;
        }
    };
    
    if ([CATransaction disableActions]) {
        completionBlock();
    } else {
        [CATransaction setCompletionBlock:completionBlock];
    }
}


- (void) insertChartValue:(NSDictionary*)chartValue atIndex:(NSInteger)index {
    if (![chartValue isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"VBPieChartException" format:@"insert value should be only NSDictionary"];
    }
    
    NSNumber *value = chartValue[@"value"];
    
    NSMutableDictionary *mutableChartValue = [NSMutableDictionary dictionaryWithDictionary:chartValue];
    mutableChartValue[@"value"] = @0;
    
    [_chartValues insertObject:mutableChartValue atIndex:index];
    _presentWithAnimation = NO;
    [self _updateCharts];
    [self setValue:value pieceAtIndex:index];
}


- (void) _refreshCharts {
    
    double fullValue = 0;
    for (VBPiePieceData *data in _chartsData) {
        fullValue += fabs([data.value doubleValue]);
    }
    
    CGFloat onePrecent = fullValue*0.01;
    CGFloat onePrecentOfChart = _length*0.01;
    CGFloat start = _startAngle;
    
    for (VBPiePieceData *data in _chartsData) {
        CGFloat pieceValuePrecents = fabs([data.value doubleValue])/onePrecent;
        CGFloat pieceChartValue = onePrecentOfChart*pieceValuePrecents;
        
        VBPiePiece *piece = (VBPiePiece *)_pieceArray[data.index];
        
        [piece _animateToAngle:pieceChartValue startAngle:start];
    
        start += pieceChartValue;
    }
}


- (double) _recreateChartsData {
    
    self.chartsData = [NSMutableArray array];
    
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
        data.index = index;
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)object;
            data.name = dict[@"name"];
            data.value = dict[@"value"];
            if (!dict[@"color"]) {
                data.color = [self defaultColors:index];
            } else {
                data.color = dict[@"color"];
            }
            
            if (!dict[@"labelColor"]) {
                data.labelColor = [UIColor whiteColor];
            } else {
                data.labelColor = dict[@"labelColor"];
            }
            
            if (dict[@"strokeColor"]) {
                data.strokeColor = dict[@"strokeColor"];
            }
            
            
            data.accent = [dict[@"accent"] boolValue];
        } else {
            data.value = (NSNumber*)object;
            if (created) {
                data.color = [self defaultColors:index];
            }
        }
        
        if (created) {
            [_chartsData addObject:data];
        }
        
        fullValue += fabs([data.value doubleValue]);
        index++;
    }
    
    return fullValue;
}


- (void) _updateCharts {

    if (!_chartValues) {
        return;
    }
    
    // Clean old layers
    NSArray *arraySublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *l in arraySublayers) {
        [l removeFromSuperlayer];
    }
    [_pieceArray removeAllObjects];
    
    // init temp variables
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    double fullValue = [self _recreateChartsData];
    
    
    CGFloat onePrecent = fullValue*0.01;
    CGFloat onePrecentOfChart = _length*0.01;
    CGFloat start = _startAngle;

    _pieceArray = [NSMutableArray array];
    
    for (VBPiePieceData *data in _chartsData) {
        
        CGFloat pieceValuePrecents = fabs([data.value doubleValue])/onePrecent;
        CGFloat pieceChartValue = onePrecentOfChart*pieceValuePrecents;
        
        VBPiePiece *piece = [[VBPiePiece alloc] init];
        [piece setFrame:rect];
        
        [piece setLabelsPosition:_labelsPosition];
        [piece setLabelBlock:_labelBlock];
        piece->_value = pieceValuePrecents;
        piece->_innerRadius = _radius;
        piece->_outerRadius = _holeRadius;
        
        [piece setData:data];
        
        [piece pieceAngle:pieceChartValue start:start];
        
        if (_presentWithAnimation) {
            [piece setHidden:YES];
        }
        [piece setAnimationDuration:_animationDuration];
        [piece setAnimationOptions:_animationOptions];
        
        [self.layer addSublayer:piece];
        [_pieceArray addObject:piece];
        start += pieceChartValue;
    }
    
    // if was selected present with animation
    if (_presentWithAnimation) {
        
        if (_animationOptions & VBPieChartAnimationGrowthAll || _animationOptions & VBPieChartAnimationGrowthBackAll || _animationOptions & VBPieChartAnimationFan) {
            
            for (VBPiePiece *piece in _pieceArray) {
                [piece _animate];
            }
            
        } else {
            
            for (NSInteger i = 0, len = _pieceArray.count; i < len; i++) {
                VBPiePiece *piece = (VBPiePiece *)_pieceArray[i];
                if (i+1 < len) {
                    __block VBPiePiece *blockPiece = (VBPiePiece *)_pieceArray[i+1];
                    [piece setEndAnimationBlock:^{
                        [blockPiece _animate];
                    }];
                }
            }
            
            VBPiePiece *piece = (VBPiePiece *)_pieceArray.firstObject;
            [piece _animate];
        }
        
        _presentWithAnimation = NO;
    }
}

- (NSArray *) chartValues {
    return [NSArray arrayWithArray:_chartValues];
}


- (void) setChartValues:(NSArray *)chartValues {
    if (![chartValues isKindOfClass:[NSArray class]]) {
        [NSException raise:@"VBPieChartException" format:@"chartValues needs to be specified with NSArray"];
    }

    _chartValues = [NSMutableArray array];
    for (NSDictionary *pieceValue in chartValues) {
        [_chartValues addObject:[pieceValue mutableCopy]];
    }
    
    [self _updateCharts];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation {
    [self setChartValues:chartValues animation:animation options:VBPieChartAnimationDefault];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(VBPieChartAnimationOptions)options {
    [self setChartValues:chartValues animation:animation duration:0.6 options:options];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(double)duration options:(VBPieChartAnimationOptions)options {
    _presentWithAnimation = animation;
    _animationOptions = options;
    _animationDuration = duration;
    [self setChartValues:chartValues];
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
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint p1 = [touch previousLocationInView:self];
//    CGPoint p2 = [touch locationInView:self];
//    CGPoint delta;
//    delta.x = (p1.x - p2.x);
//    delta.y = (p1.y - p2.y);
//        
//    if ([_hitLayer isKindOfClass:[VBPiePiece class]]) {
//        double d = _hitLayer.accentPrecent+((-delta.x+delta.y)/2/_radius);
//        d = MIN(MAX(0, d), _maxAccentPrecent);
//
//        [_hitLayer setAccentPrecent:d];
//    }
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
