//
//  LMViewController.m
//  LMGaugeView
//
//  Created by LMinh on 01/08/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "LMViewController.h"
#import "LMGaugeView.h"

#define kMyRedColor   [UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:1]
#define kMyGreenColor [UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1]
#define kMyBlueColor  [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]

@interface LMViewController () <LMGaugeViewDelegate>
{
    CGFloat timeDelta;
    CGFloat velocity;
    NSInteger acceleration;
}
@property (strong, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet LMGaugeView *gaugeView;

@end

@implementation LMViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure gauge view
    self.gaugeView.minValue = 0;
    self.gaugeView.maxValue = 120;
    self.gaugeView.limitValue = 50;
    
    // Create a timer to update value for gauge view
    velocity = 0;
    acceleration = 5;
    timeDelta = 1.0/24;
    [NSTimer scheduledTimerWithTimeInterval:timeDelta
                                     target:self
                                   selector:@selector(updateGaugeTimer:)
                                   userInfo:nil
                                    repeats:YES];
}


#pragma mark - LMGAUGEVIEW DELEGATE

- (UIColor *)gaugeView:(LMGaugeView *)gaugeView ringStokeColorForValue:(CGFloat)value
{
    if (value >= self.gaugeView.limitValue) {
        return kMyRedColor;
    }
    if (self.nightModeSwitch.on) {
        return kMyBlueColor;
    }
    return kMyGreenColor;
}


#pragma mark - EVENTS

- (void)updateGaugeTimer:(NSTimer *)timer
{
    // Calculate velocity
    velocity += timeDelta * acceleration;
    if (velocity > self.gaugeView.maxValue) {
        velocity = self.gaugeView.maxValue;
        acceleration = -5;
    }
    if (velocity < self.gaugeView.minValue) {
        velocity = self.gaugeView.minValue;
        acceleration = 5;
    }
    
    // Set value for gauge view
    self.gaugeView.value = velocity;
}

- (IBAction)changedStyleSwitchValueChanged:(id)sender
{
    if (!self.nightModeSwitch.on)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        self.aboutLabel.textColor = [UIColor whiteColor];
        
        self.gaugeView.ringBackgroundColor = [UIColor blackColor];
        self.gaugeView.valueTextColor = [UIColor whiteColor];
        self.gaugeView.unitOfMeasurementTextColor = [UIColor colorWithWhite:0.7 alpha:1];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.view.backgroundColor = [UIColor whiteColor];
        self.aboutLabel.textColor = [UIColor blackColor];
        
        self.gaugeView.ringBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.gaugeView.valueTextColor = [UIColor colorWithWhite:0.1 alpha:1];
        self.gaugeView.unitOfMeasurementTextColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
}

@end
