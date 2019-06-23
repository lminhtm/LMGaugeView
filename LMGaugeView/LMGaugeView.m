//
//  LMGaugeView.m
//  LMGaugeView
//
//  Created by LMinh on 01/08/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "LMGaugeView.h"

#define kDefaultStartAngle                      M_PI_4 * 3
#define kDefaultEndAngle                        M_PI_4 + 2 * M_PI
#define kDefaultMinValue                        0
#define kDefaultMaxValue                        120
#define kDefaultLimitValue                      50
#define kDefaultNumOfDivisions                  6
#define kDefaultNumOfSubDivisions               10

#define kDefaultRingThickness                   15
#define kDefaultRingBackgroundColor             [UIColor colorWithWhite:0.9 alpha:1]
#define kDefaultRingColor                       [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]

#define kDefaultDivisionsRadius                 1.25
#define kDefaultDivisionsColor                  [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultDivisionsPadding                12

#define kDefaultSubDivisionsRadius              0.75
#define kDefaultSubDivisionsColor               [UIColor colorWithWhite:0.5 alpha:0.5]

#define kDefaultLimitDotRadius                  2
#define kDefaultLimitDotColor                   [UIColor redColor]

#define kDefaultValueFont                       [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:140]
#define kDefaultValueTextColor                  [UIColor colorWithWhite:0.1 alpha:1]
#define kDefaultMinMaxValueFont                 [UIFont fontWithName:@"HelveticaNeue" size:12]
#define kDefaultMinMaxValueTextColor            [UIColor colorWithWhite:0.3 alpha:1]

#define kDefaultUnitOfMeasurement               @"km/h"
#define kDefaultUnitOfMeasurementFont           [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]
#define kDefaultUnitOfMeasurementTextColor      [UIColor colorWithWhite:0.3 alpha:1]

@interface LMGaugeView ()

// For calculation
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat divisionUnitAngle;
@property (nonatomic, assign) CGFloat divisionUnitValue;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *unitOfMeasurementLabel;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;

@end

@implementation LMGaugeView

#pragma mark - INIT

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    // Set default values
    _startAngle = kDefaultStartAngle;
    _endAngle = kDefaultEndAngle;
    
    _value = kDefaultMinValue;
    _minValue = kDefaultMinValue;
    _maxValue = kDefaultMaxValue;
    _limitValues = @[@(kDefaultLimitValue)];
    _numOfDivisions = kDefaultNumOfDivisions;
    _numOfSubDivisions = kDefaultNumOfSubDivisions;
    
    // Ring
    _showRingBackground = YES;
    _ringThickness = kDefaultRingThickness;
    _ringBackgroundColor = kDefaultRingBackgroundColor;
    
    // Divisions
    _divisionsRadius = kDefaultDivisionsRadius;
    _divisionsColor = kDefaultDivisionsColor;
    _divisionsPadding = kDefaultDivisionsPadding;
    
    // Subdivisions
    _subDivisionsRadius = kDefaultSubDivisionsRadius;
    _subDivisionsColor = kDefaultSubDivisionsColor;
    
    // Limit dot
    _showLimitDot = YES;
    _limitDotRadius = kDefaultLimitDotRadius;
    _limitDotColors = @[kDefaultLimitDotColor];
    
    // Value Text
    _valueFont = kDefaultValueFont;
    _valueTextColor = kDefaultValueTextColor;
    _showMinMaxValue = YES;
    _minMaxValueFont = kDefaultMinMaxValueFont;
    _minMaxValueTextColor = kDefaultMinMaxValueTextColor;
    
    // Unit Of Measurement
    _showUnitOfMeasurement = YES;
    _unitOfMeasurement = kDefaultUnitOfMeasurement;
    _unitOfMeasurementFont = kDefaultUnitOfMeasurementFont;
    _unitOfMeasurementTextColor = kDefaultUnitOfMeasurementTextColor;
}


#pragma mark - ANIMATION

- (void)strokeGauge
{
    /*!
     *  Set progress for ring layer
     */
    CGFloat progress = self.maxValue ? (self.value - self.minValue)/(self.maxValue - self.minValue) : 0;
    self.progressLayer.strokeEnd = progress;
    
    /*!
     *  Set ring stroke color
     */
    UIColor *ringColor = kDefaultRingColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(gaugeView:ringStokeColorForValue:)]) {
        ringColor = [self.delegate gaugeView:self ringStokeColorForValue:self.value];
    }
    self.progressLayer.strokeColor = ringColor.CGColor;
}


#pragma mark - CUSTOM DRAWING

- (void)drawRect:(CGRect)rect
{
    /*!
     *  Prepare drawing
     */
    self.divisionUnitValue = self.numOfDivisions ? (self.maxValue - self.minValue)/self.numOfDivisions : 0;
    self.divisionUnitAngle = self.numOfDivisions ? ABS(self.endAngle - self.startAngle)/self.numOfDivisions : 0;
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat ringRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.ringThickness/2;
    CGFloat dotRadius = ringRadius - self.ringThickness/2 - self.divisionsPadding - self.divisionsRadius/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*!
     *  Draw the ring background
     */
    if (self.showRingBackground) {
        CGContextSetLineWidth(context, self.ringThickness);
        CGContextBeginPath(context);
        CGContextAddArc(context, center.x, center.y, ringRadius, 0, M_PI * 2, 0);
        CGContextSetStrokeColorWithColor(context, [self.ringBackgroundColor colorWithAlphaComponent:0.3].CGColor);
        CGContextStrokePath(context);
    }
    
    /*!
     *  Draw the ring progress background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, self.startAngle, self.endAngle, 0);
    CGContextSetStrokeColorWithColor(context, self.ringBackgroundColor.CGColor);
    CGContextStrokePath(context);
    
    /*!
     *  Draw divisions and subdivisions
     */
    for (int i = 0; i <= self.numOfDivisions && self.numOfDivisions != 0; i++)
    {
        if (i != self.numOfDivisions)
        {
            for (int j = 0; j <= self.numOfSubDivisions && self.numOfSubDivisions != 0; j++)
            {
                // Subdivisions
                CGFloat value = i * self.divisionUnitValue + j * self.divisionUnitValue/self.numOfSubDivisions + self.minValue;
                CGFloat angle = [self angleFromValue:value];
                CGPoint dotCenter = CGPointMake(dotRadius * cos(angle) + center.x, dotRadius * sin(angle) + center.y);
                [self drawDotAtContext:context
                                center:dotCenter
                                radius:self.subDivisionsRadius
                             fillColor:self.subDivisionsColor.CGColor];
            }
        }
        
        // Divisions
        CGFloat value = i * self.divisionUnitValue + self.minValue;
        CGFloat angle = [self angleFromValue:value];
        CGPoint dotCenter = CGPointMake(dotRadius * cos(angle) + center.x, dotRadius * sin(angle) + center.y);
        [self drawDotAtContext:context
                        center:dotCenter
                        radius:self.divisionsRadius
                     fillColor:self.divisionsColor.CGColor];
    }
    
    /*!
     *  Draw the limit dot
     */
    if (self.showLimitDot && self.numOfDivisions != 0)
    {
        for (int i = 0; i < self.limitValues.count; i++) {
            NSNumber *limitValue = [self.limitValues objectAtIndex:i];
            if (limitValue.doubleValue >= self.minValue && limitValue.doubleValue <= self.maxValue) {
                CGFloat angle = [self angleFromValue:limitValue.doubleValue];
                CGPoint dotCenter = CGPointMake(dotRadius * cos(angle) + center.x, dotRadius * sin(angle) + center.y);
                UIColor *limitDotColor = i < self.limitDotColors.count ? self.limitDotColors[i] : kDefaultLimitDotColor;
                
                [self drawDotAtContext:context
                                center:dotCenter
                                radius:self.limitDotRadius
                             fillColor:limitDotColor.CGColor];
            }
        }
    }
    
    /*!
     *  Progress Layer
     */
    if (!self.progressLayer)
    {
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.progressLayer.fillColor = [UIColor clearColor].CGColor;
        self.progressLayer.lineCap = kCALineJoinBevel;
        self.progressLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:self.progressLayer];
        self.progressLayer.strokeEnd = 0;
    }
    self.progressLayer.frame = CGRectMake(center.x - ringRadius - self.ringThickness/2,
                                          center.y - ringRadius - self.ringThickness/2,
                                          (ringRadius + self.ringThickness/2) * 2,
                                          (ringRadius + self.ringThickness/2) * 2);
    self.progressLayer.bounds = self.progressLayer.frame;
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position
                                                                radius:ringRadius
                                                            startAngle:self.startAngle
                                                              endAngle:self.endAngle
                                                             clockwise:YES];
    self.progressLayer.path = smoothedPath.CGPath;
    self.progressLayer.lineWidth = self.ringThickness;
    
    /*!
     *  Value Label
     */
    if (!self.valueLabel)
    {
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        if (self.decimalFormat) {
            self.valueLabel.text = [NSString stringWithFormat:@"%.1f", self.value];
        }
        else {
            self.valueLabel.text = [NSString stringWithFormat:@"%0.f", self.value];
        }
        self.valueLabel.font = self.valueFont;
        self.valueLabel.adjustsFontSizeToFitWidth = YES;
        self.valueLabel.minimumScaleFactor = 0.5;
        self.valueLabel.textColor = self.valueTextColor;
        [self addSubview:self.valueLabel];
    }
    CGFloat insetX = self.ringThickness + self.divisionsPadding * 2 + self.divisionsRadius;
    self.valueLabel.frame = CGRectInset(self.progressLayer.frame, insetX, insetX);
    self.valueLabel.frame = CGRectOffset(self.valueLabel.frame, 0, self.showUnitOfMeasurement ? -self.divisionsPadding/2 : 0);
    
    /*!
     *  Min Value Label
     */
    if (!self.minValueLabel)
    {
        self.minValueLabel = [[UILabel alloc] init];
        self.minValueLabel.backgroundColor = [UIColor clearColor];
        self.minValueLabel.textAlignment = NSTextAlignmentLeft;
        self.minValueLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.minValueLabel];
    }
    self.minValueLabel.text = [NSString stringWithFormat:@"%0.f", self.minValue];
    self.minValueLabel.font = self.minMaxValueFont;
    self.minValueLabel.minimumScaleFactor = 0.5;
    self.minValueLabel.textColor = self.minMaxValueTextColor;
    self.minValueLabel.hidden = !self.showMinMaxValue;
    CGPoint minDotCenter = CGPointMake(dotRadius * cos(self.startAngle) + center.x, dotRadius * sin(self.startAngle) + center.y);
    self.minValueLabel.frame = CGRectMake(minDotCenter.x + 8, minDotCenter.y - 20, 40, 20);
    
    /*!
     *  Max Value Label
     */
    if (!self.maxValueLabel)
    {
        self.maxValueLabel = [[UILabel alloc] init];
        self.maxValueLabel.backgroundColor = [UIColor clearColor];
        self.maxValueLabel.textAlignment = NSTextAlignmentRight;
        self.maxValueLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.maxValueLabel];
    }
    self.maxValueLabel.text = [NSString stringWithFormat:@"%0.f", self.maxValue];
    self.maxValueLabel.font = self.minMaxValueFont;
    self.maxValueLabel.minimumScaleFactor = 0.5;
    self.maxValueLabel.textColor = self.minMaxValueTextColor;
    self.maxValueLabel.hidden = !self.showMinMaxValue;
    CGPoint maxDotCenter = CGPointMake(dotRadius * cos(self.endAngle) + center.x, dotRadius * sin(self.endAngle) + center.y);
    self.maxValueLabel.frame = CGRectMake(maxDotCenter.x - 8 - 40, maxDotCenter.y - 20, 40, 20);
    
    /*!
     *  Unit Of Measurement Label
     */
    if (!self.unitOfMeasurementLabel)
    {
        self.unitOfMeasurementLabel = [[UILabel alloc] init];
        self.unitOfMeasurementLabel.backgroundColor = [UIColor clearColor];
        self.unitOfMeasurementLabel.textAlignment = NSTextAlignmentCenter;
        self.unitOfMeasurementLabel.text = self.unitOfMeasurement;
        self.unitOfMeasurementLabel.font = self.unitOfMeasurementFont;
        self.unitOfMeasurementLabel.adjustsFontSizeToFitWidth = YES;
        self.unitOfMeasurementLabel.minimumScaleFactor = 0.5;
        self.unitOfMeasurementLabel.textColor = self.unitOfMeasurementTextColor;
        [self addSubview:self.unitOfMeasurementLabel];
        self.unitOfMeasurementLabel.hidden = !self.showUnitOfMeasurement;
    }
    self.unitOfMeasurementLabel.frame = CGRectMake(self.valueLabel.frame.origin.x,
                                                   self.valueLabel.frame.origin.y + CGRectGetHeight(self.valueLabel.frame) - 10,
                                                   CGRectGetWidth(self.valueLabel.frame),
                                                   20);
}


#pragma mark - SUPPORT

- (CGFloat)angleFromValue:(CGFloat)value
{
    CGFloat level = self.divisionUnitValue ? (value - self.minValue)/self.divisionUnitValue : 0;
    CGFloat angle = level * self.divisionUnitAngle + self.startAngle;
    return angle;
}

- (void)drawDotAtContext:(CGContextRef)context
                  center:(CGPoint)center
                  radius:(CGFloat)radius
               fillColor:(CGColorRef)fillColor
{
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillPath(context);
}


#pragma mark - PROPERTIES

- (void)setValue:(CGFloat)value
{
    _value = MIN(value, _maxValue);
    _value = MAX(_value, _minValue);
    
    /*!
     *  Set text for value label
     */
    if (self.decimalFormat) {
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f", _value];
    }
    else {
        self.valueLabel.text = [NSString stringWithFormat:@"%0.f", _value];
    }

    /*!
     *  Trigger the stoke animation of ring layer.
     */
    [self strokeGauge];
}

- (void)setMinValue:(CGFloat)minValue
{
    if (_minValue != minValue && minValue < _maxValue) {
        _minValue = minValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setMaxValue:(CGFloat)maxValue
{
    if (_maxValue != maxValue && maxValue > _minValue) {
        _maxValue = maxValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitValues:(NSArray *)limitValues
{
    if (_limitValues != limitValues) {
        _limitValues = limitValues;
        
        [self setNeedsDisplay];
    }
}

- (void)setNumOfDivisions:(NSUInteger)numOfDivisions
{
    if (_numOfDivisions != numOfDivisions) {
        _numOfDivisions = numOfDivisions;
        
        [self setNeedsDisplay];
    }
}

- (void)setNumOfSubDivisions:(NSUInteger)numOfSubDivisions
{
    if (_numOfSubDivisions != numOfSubDivisions) {
        _numOfSubDivisions = numOfSubDivisions;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingThickness:(CGFloat)ringThickness
{
    if (_ringThickness != ringThickness) {
        _ringThickness = ringThickness;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingBackgroundColor:(UIColor *)ringBackgroundColor
{
    if (_ringBackgroundColor != ringBackgroundColor) {
        _ringBackgroundColor = ringBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsRadius:(CGFloat)divisionsRadius
{
    if (_divisionsRadius != divisionsRadius) {
        _divisionsRadius = divisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsColor:(UIColor *)divisionsColor
{
    if (_divisionsColor != divisionsColor) {
        _divisionsColor = divisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsPadding:(CGFloat)divisionsPadding
{
    if (_divisionsPadding != divisionsPadding) {
        _divisionsPadding = divisionsPadding;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsRadius:(CGFloat)subDivisionsRadius
{
    if (_subDivisionsRadius != subDivisionsRadius) {
        _subDivisionsRadius = subDivisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsColor:(UIColor *)subDivisionsColor
{
    if (_subDivisionsColor != subDivisionsColor) {
        _subDivisionsColor = subDivisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setShowLimitDot:(BOOL)showLimitDot
{
    if (_showLimitDot != showLimitDot) {
        _showLimitDot = showLimitDot;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotRadius:(CGFloat)limitDotRadius
{
    if (_limitDotRadius != limitDotRadius) {
        _limitDotRadius = limitDotRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotColors:(NSArray *)limitDotColors
{
    if (_limitDotColors != limitDotColors) {
        _limitDotColors = limitDotColors;
        
        [self setNeedsDisplay];
    }
}

- (void)setValueFont:(UIFont *)valueFont
{
    if (_valueFont != valueFont) {
        _valueFont = valueFont;
        
        self.valueLabel.font = _valueFont;
    }
}

- (void)setValueTextColor:(UIColor *)valueTextColor
{
    if (_valueTextColor != valueTextColor) {
        _valueTextColor = valueTextColor;
        
        self.valueLabel.textColor = _valueTextColor;
    }
}

- (void)setShowMinMaxValue:(BOOL)showMinMaxValue
{
    if (_showMinMaxValue != showMinMaxValue) {
        _showMinMaxValue = showMinMaxValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setMinMaxValueFont:(UIFont *)minMaxValueFont
{
    if (_minMaxValueFont != minMaxValueFont) {
        _minMaxValueFont = minMaxValueFont;
        
        [self setNeedsDisplay];
    }
}

- (void)setMinMaxValueTextColor:(UIColor *)minMaxValueTextColor
{
    if (_minMaxValueTextColor != minMaxValueTextColor) {
        _minMaxValueTextColor = minMaxValueTextColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setShowUnitOfMeasurement:(BOOL)showUnitOfMeasurement
{
    if (_showUnitOfMeasurement != showUnitOfMeasurement) {
        _showUnitOfMeasurement = showUnitOfMeasurement;
        
        self.unitOfMeasurementLabel.hidden = !_showUnitOfMeasurement;
    }
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    if (_unitOfMeasurement != unitOfMeasurement) {
        _unitOfMeasurement = unitOfMeasurement;
        
        self.unitOfMeasurementLabel.text = _unitOfMeasurement;
    }
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    if (_unitOfMeasurementFont != unitOfMeasurementFont) {
        _unitOfMeasurementFont = unitOfMeasurementFont;
        
        self.unitOfMeasurementLabel.font = _unitOfMeasurementFont;
    }
}

- (void)setUnitOfMeasurementTextColor:(UIColor *)unitOfMeasurementTextColor
{
    if (_unitOfMeasurementTextColor != unitOfMeasurementTextColor) {
        _unitOfMeasurementTextColor = unitOfMeasurementTextColor;
        
        self.unitOfMeasurementLabel.textColor = _unitOfMeasurementTextColor;
    }
}

@end
