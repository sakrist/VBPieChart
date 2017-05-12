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
@property (nonatomic) double radius;
@property (nonatomic) double holeRadius;
@property (nonatomic, weak) VBPiePiece *hitLayer;

@property (nonatomic) BOOL presentWithAnimation;
@property (nonatomic) VBPieChartAnimationOptions animationOptions;
@property (nonatomic) double animationDuration;

@property (nonatomic, strong) NSMutableArray *piecesArray;

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
- (VBPiePieceData*)data;

- (CATextLayer *)label;

@property (nonatomic, copy) void (^endAnimationBlock)(void);

@end

#if TARGET_INTERFACE_BUILDER
@implementation VBPieChart (interface)
+ (NSArray*) _chartValues {
    NSString *json_example = @"[ {\"name\":\"first\", \"value\":\"50\", \"color\":\"#84C69B\", \"strokeColor\":\"#fff\"}, \
    {\"name\":\"second\", \"value\":\"60\", \"color\":\"#FECEA8\", \"strokeColor\":\"#fff\"}, \
    {\"name\":\"second\", \"value\":\"75\", \"color\":\"#F7EEBB\", \"strokeColor\":\"#fff\"}, \
    {\"name\":\"second\", \"value\":\"90\", \"color\":\"#D7C1E0\", \"strokeColor\":\"#fff\"} ]";
    NSData *data = [json_example dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *chartValues = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return chartValues;
}
@end
#endif


@implementation VBPieChart {
    CGPoint _touchBegan;
}

- (instancetype) init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configure];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self configure];
    return self;
}

- (void)configure {
    
    self.startAngle = 0;
    self.length = M_PI*2;
    self.radiusPrecent = 0.9;
    self.radius = self.frame.size.width/2*_radiusPrecent;
    self.holeRadius = _radius*_holeRadiusPrecent;
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

#if TARGET_INTERFACE_BUILDER
    [self setChartValues:[VBPieChart _chartValues]
                 animation:NO];
#endif
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


- (void) setValue:(NSNumber*)value pieceAtIndex:(NSInteger)index {
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:@"VBPieChartException" format:@"value needs to be NSNumber"];
    }
    VBPiePiece *piece = _piecesArray[index];
    piece.data.value = value;
    _chartValues[index][@"value"] = value;
    [self _refreshCharts];
}


- (void) removePieceAtIndex:(NSInteger)index {
    
    if ([CATransaction completionBlock]) {
        void (^completionBlock2)(void) = [CATransaction completionBlock];
        [CATransaction setCompletionBlock:nil];
        completionBlock2();
    }
    
    __block VBPiePiece *piece = _piecesArray[index];
    [piece removeLable];
    piece.data.value = @(0);
    [self _refreshCharts];
    [_chartValues removeObjectAtIndex:index];
    
    void (^completionBlock)(void)  = ^(void){
        
        if (piece.animationKeys.count) {
            [piece removeAllAnimations];
        }
        
        [piece removeFromSuperlayer];
        [_piecesArray removeObject:piece];
        
        for (NSInteger i = index; i < _piecesArray.count; i++) {
            VBPiePiece *piece = _piecesArray[i];
            piece.data.index = i;
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
    [_piecesArray insertObject:[[VBPiePiece alloc] init] atIndex:index];
    _presentWithAnimation = NO;
    [self _updateCharts];
    [self setValue:value pieceAtIndex:index];
}


- (void) _refreshCharts {
    
    double fullValue = 0;
    for (VBPiePiece *piece in _piecesArray) {
        fullValue += fabs([piece.data.value doubleValue]);
    }
    
    CGFloat onePrecent = fullValue*0.01;
    CGFloat onePrecentOfChart = _length*0.01;
    CGFloat start = _startAngle;
    
    for (VBPiePiece *piece in _piecesArray) {
        CGFloat pieceValuePrecents = fabs([piece.data.value doubleValue])/onePrecent;
        CGFloat pieceChartValue = onePrecentOfChart*pieceValuePrecents;
        
        [piece _animateToAngle:pieceChartValue startAngle:start];
    
        start += pieceChartValue;
    }
}


- (double) _allValuesSum {
    double allValues = 0;
    for (id object in _chartValues) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)object;
            allValues += fabs([dict[@"value"] doubleValue]);
        } else {
            allValues += fabs([object doubleValue]);
        }
    }
    return allValues;
}

- (void) _updateCharts {

    if (!_chartValues) {
        return;
    }
    
    if (!_piecesArray) {
        _piecesArray = [NSMutableArray array];
    }
    NSMutableArray *piecesArray = [_piecesArray mutableCopy];
    [_piecesArray removeAllObjects];
    
    // init temp variables
    CGRect rect = self.bounds;
    
    double allValues = [self _allValuesSum];
    
    
    CGFloat onePrecent = allValues*0.01;
    CGFloat onePrecentOfChart = _length*0.01;
    CGFloat start = _startAngle;

    
    NSInteger index = 0;
    for (NSDictionary *options in _chartValues) {

        VBPiePiece *piece = nil;
        if (piecesArray.count > 0) {
            piece = piecesArray.firstObject;
            [piecesArray removeObjectAtIndex:0];
        } else {
            piece = [[VBPiePiece alloc] init];
        }
        
        VBPiePieceData *data = [VBPiePieceData pieceDataWith:options];
        data.index = index;
        
        CGFloat pieceValuePrecents = fabs([data.value doubleValue])/onePrecent;
        CGFloat pieceAngle = onePrecentOfChart*pieceValuePrecents;

        [piece setFrame:rect];
        [piece setLabelsPosition:_labelsPosition];
        [piece setLabelBlock:_labelBlock];
        piece->_innerRadius = _radius;
        piece->_outerRadius = _holeRadius;
        
        [piece setData:data];
        
        [piece pieceAngle:pieceAngle start:start];
        
        if (_presentWithAnimation) {
            [CATransaction setDisableActions:YES];
            [piece setHidden:YES];
            [CATransaction setDisableActions:NO];
        }
        [piece setAnimationDuration:_animationDuration];
        [piece setAnimationOptions:_animationOptions];
        
        if (!piece.superlayer) {
            [self.layer addSublayer:piece];
        }
        if (![_piecesArray containsObject:piece]) {
            [_piecesArray addObject:piece];
        }
        start += pieceAngle;
        
        index++;
    }
    
    
    // remove old pieces
    for (VBPiePiece *piece in piecesArray) {
        [piece removeFromSuperlayer];
        [piece removeLable];
    }
    
    [self _runAnimation];
}


- (void) _runAnimation {
    
    // if was selected present with animation
    if (_presentWithAnimation) {
        
        if (_animationOptions & VBPieChartAnimationGrowthAll || _animationOptions & VBPieChartAnimationGrowthBackAll || _animationOptions & VBPieChartAnimationFan) {
            
            for (VBPiePiece *piece in _piecesArray) {
                [piece _animate];
            }
            
        } else {
            
            for (NSInteger i = 0, len = _piecesArray.count; i < len; i++) {
                VBPiePiece *piece = (VBPiePiece *)_piecesArray[i];
                [CATransaction setDisableActions:YES];
                [piece.label setHidden:YES];
                [CATransaction setDisableActions:NO];
                if (i+1 < len) {
                    __block VBPiePiece *blockPiece = (VBPiePiece *)_piecesArray[i+1];
                    [piece setEndAnimationBlock:^{
                        [blockPiece _animate];
                    }];
                }
            }
            
            VBPiePiece *piece = (VBPiePiece *)_piecesArray.firstObject;
            [CATransaction setDisableActions:YES];
            [piece.label setHidden:YES];
            [CATransaction setDisableActions:NO];
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
